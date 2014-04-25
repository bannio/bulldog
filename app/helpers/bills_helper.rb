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

  def get_vat_rate_data
    vat_rates = current_account.vat_rates.active.order(:name).to_json(only: [:id, :name])
  end

  def get_header_data
    headers = current_account.headers.order(:name).to_json(only: [:id, :name])
  end

end
