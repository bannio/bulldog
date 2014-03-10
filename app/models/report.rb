class Report
  include ActiveModel::Model
  
  attr_accessor(
    :account_id,
    :customer_id,
    :supplier_id,
    :category_id,
    :amount,
    :from_date,
    :to_date
  )

  validates :account_id, presence: true 

  def bills
    @bills ||= self.generate
  end

  def paginated_bills
    bills.page(params[:page])
  end

  def generate
    bills = Bill.where(account_id: @account_id)
    bills = bills.where("date >= ?", @from_date)   if @from_date.present?
    bills = bills.where("date <= ?", @to_date)     if @to_date.present?
    bills = bills.where(customer_id: @customer_id) if @customer_id.present?
    bills = bills.where(supplier_id: @supplier_id) if @supplier_id.present?
    bills = bills.where(category_id: @category_id) if @category_id.present?
    bills = bills.includes(:customer, :supplier, :category)
  end

end