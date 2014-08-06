module InvoicesHelper

  def total_vat(invoice)
    invoice.bills.sum(:vat)
  end

  def vat_by_rate(invoice, rate)
    invoice.bills.vat(rate).sum(:vat)
  end

  def vat_rates(bills)
    rates = bills.map {|bill| bill.vat_rate}.uniq.compact
  end

  def logo_file(invoice)
    if invoice.account.setting.logo_file_name.present?
      invoice.account.setting.logo.url(:medium)
    else
      nil
    end
  end
end
