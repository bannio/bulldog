class ReportsController < ApplicationController
  before_action :authenticate_user!

  # respond_to :html

  def new
    if params[:report]
      @report = Report.new(report_params)
    else 
      @report = Report.new(account_id: current_account.id)
    end
    @bills = @report.bills.page(params[:page]).per(25)
  end

  def create

    @report = Report.new(report_params)
    if @report.valid?
      @report.generate
      @bills = @report.bills.page(params[:page]).per(25)
      if params[:commit] == "Export"
        send_data @report.bills.to_csv
      else
        render :new
      end
    else
      flash[:error] = 'something not right'
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:from_date, :to_date, :account_id, :customer_id, :supplier_id, :category_id)
  end
end
