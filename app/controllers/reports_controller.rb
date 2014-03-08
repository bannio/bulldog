class ReportsController < ApplicationController
  before_action :authenticate_user!

  # respond_to :html

  def new
    @report ||= Report.new(account_id: current_account.id)
    @bills = @report.bills.page(params[:page]).per(10)
  end

  def create
    @report = Report.new(report_params)
    if @report.valid?
      @report.generate
      if params[:commit] == "Export"
        send_data @report.bills.to_csv
      else
        @bills = @report.bills.page(params[:page]).per(10)
        render :new
      end
    else
      flash[:error] = 'something not right'
      @bills = @report.bills.page(params[:page]).per(10)
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:from_date, :to_date, :account_id, :customer_id, :supplier_id, :category_id)
  end
end
