module InvoicesHelper

  def total_vat(invoice)
    invoice.bills.sum(:vat)
  end

  def vat_by_rate(invoice, rate)
    invoice.bills.vat(rate).sum(:vat)
  end

  def vat_rates(bills)
    rates = bills.map {|bill| bill.vat_rate}.uniq
  end
end
