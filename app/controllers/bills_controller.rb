class BillsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  # after_action :verify_policy_scoped, except: [:new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @bills = current_account.bills.uninvoiced.includes(:customer, :supplier, :category, :vat_rate).
                                              page(params[:page]).
                                              order(sort_column + " " + sort_direction)
    authorize @bills
    @bill = current_account.bills.build
    @bill.date = Date.today
    # authorize @bill
    respond_to do |format|
      format.html
      format.csv  {
        @bills = current_account.bills.includes(:customer, :supplier, :category, :vat_rate)
        send_data @bills.to_csv, filename: 'BulldogClip_bills.csv' unless @bills.empty?
      }
      format.js
    end
  end

  def new
    @bill = current_account.bills.build
    authorize @bill
    @bill.date = Date.today
    @bill.customer_id = default_customer.id if default_customer
  end

  def create
    collect_new_entries
    @bill = Bill.new(bill_params)
    authorize @bill
    if @bill.save
      # Rails.logger.debug "Supplier is #{@bill.reload.supplier_id}"
      redirect_to bills_url, notice: 'Bill was succesfully created'
    else
      render 'new'
    end
  end

  def edit
    # @bill = current_account.bill(params[:id])
    @bill = policy_scope(Bill).find(params[:id])
    authorize @bill
  end

  def update
    # @bill = current_account.bill(params[:id])
    collect_new_entries
    @bill = policy_scope(Bill).find(params[:id])
    authorize @bill
    if @bill.update(bill_params)
      flash[:success] = "Bill successfully updated"
      respond_to do |format|
        format.html {redirect_to bills_url}
        format.js {redirect_to bills_url, remote: true}
      end
    else
      render 'edit'
    end
  end

  def destroy
    @bill = current_account.bill(params[:id])
    authorize @bill
    if @bill.destroy
      flash[:success] = "Bill successfully deleted"
      redirect_to bills_url, status: 303
    else
      render 'edit'
    end
  end

  private

  def bill_params
    params.require(:bill).permit(*policy(@bill || Bill).permitted_attributes)
  end

  def collect_new_entries

    # If update then the params may be absent but the bill may still be valid.
    # If create then never valid without all three foriegn keys.
    # This method should create new entries if the id appears to be a name

    # note that this must be called before assigning params to @bills as that will
    # set invalid entries to 0 before they can be captured.


    if valid_string?(params[:bill][:supplier_id])
      new_id = Supplier.create(name: params[:bill][:supplier_id], account_id: current_account.id).id
      if new_id
        params[:bill][:supplier_id] = new_id.to_s
      else
        params[:bill][:supplier_id] = nil
      end
    end
    if valid_string?(params[:bill][:customer_id])
      new_id = Customer.create(name: params[:bill][:customer_id], account_id: current_account.id).id
      if new_id
        params[:bill][:customer_id] = new_id.to_s
      else
        params[:bill][:customer_id] = nil
      end
    end
    if valid_string?(params[:bill][:category_id])
      new_id = Category.create(name: params[:bill][:category_id], account_id: current_account.id).id
      if new_id
        params[:bill][:category_id] = new_id.to_s
      else
        params[:bill][:category_id] = nil
      end
    end
  end

  def valid_string?(str)
    # not blank, not nil and not a string representation of an integer
    # all params are strings so valid ids need converting
    str.present? && str.to_i == 0
  end

  def sort_column
    %w[date customers.name suppliers.name categories.name description amount].include?(params[:sort]) ? params[:sort] : "date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def default_customer
    @default_customer ||= current_account.customers.is_default.first
  end
end
