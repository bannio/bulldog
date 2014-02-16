module BillsHelper

  def get_supplier_data
    suppliers = current_account.suppliers.order(:name).to_json(only: [:id, :name])
  end

  def get_customer_data
    customers = current_account.customers.order(:name).to_json(only: [:id, :name])
  end

  def get_category_data
    categories = current_account.categories.order(:name).to_json(only: [:id, :name])
  end

end
