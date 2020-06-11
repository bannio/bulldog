module BillsHelper

  def get_supplier_data
    current_account.suppliers.order(:name).to_json(only: [:id, :name])
  end

  def get_customer_data
    current_account.customers.order(:name).to_json(only: [:id, :name])
  end

  def get_category_data
    current_account.categories.order(:name).to_json(only: [:id, :name])
  end

  def get_vat_rate_data
    current_account.vat_rates.active.order(:name).to_json(only: [:id, :name])
  end

  def get_header_data
    current_account.headers.order(:name) # revert to non-json format
    # current_account.headers.order(:name).to_json(only: [:id, :name])
  end

end
