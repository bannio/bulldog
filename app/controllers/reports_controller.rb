class ReportsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def new
    respond_to do |format|
      format.html do
        params[:report] = {account_id: current_account.id}
        @report = Report.new(params[:report])
        authorize @report
        @bills = @report.bills.order(date: :desc).page(params[:page])
      end

      format.js do
        # pagination request only
        @report = Report.new(report_params)
        authorize @report
        @report.valid? # trigger validations
        @bills = @report.bills.order(date: :desc).page(params[:page])
      end
    end
  end

  def create
    @report = Report.new(report_params)
    authorize @report
    if @report.valid?
      @bills = @report.bills.order(date: :desc).page(params[:page])
      if params[:commit] != "View" && !@bills.empty? # = submit by JS Export button
        send_data @report.bills.to_csv, type: 'text/csv', filename: 'BulldogClip_analysis.csv'
      else
        render :new
      end
    else
      flash.now[:error] = "Please correct the highlighted errors"
      @bills = @report.bills.order(date: :desc).page(params[:page])
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(*policy(@report || Report).permitted_attributes)
  end
end
