class ReportsController < ApplicationController
  before_action :authenticate_user!

  def new
    respond_to do |format|
      format.html do
        params[:report] = {account_id: current_account.id}
        @report = Report.new(params[:report])
        @bills = @report.bills.page(params[:page]).per(25)
      end

      format.js do
        # pagination request only
        @report = Report.new(report_params)
        @report.valid? # trigger validations
        @bills = @report.bills.page(params[:page]).per(25)
      end
    end
  end

  def create
    @report = Report.new(report_params)
    if @report.valid?
      #@report.generate
      @bills = @report.bills.page(params[:page]).per(25)
      if params[:commit] == "Export"
        send_data @report.bills.to_csv
      else
        render :new
      end
    else
      flash.now[:error] = "Please correct the highlighted errors" 
      @bills = @report.bills.page(params[:page]).per(25)
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:from_date, :to_date, :account_id, :customer_id, :supplier_id, :category_id)
  end
end
