module InvoicesHelper

  def total_vat(invoice)
    invoice.bills.sum(:vat)
  end

  def vat_by_rate(invoice, rate)
    invoice.bills.vat(rate).sum(:vat)
  end

  def vat_rates(bills)
    rates = []
    bills.each do |bill|
      rates << bill.vat_rate unless rates.include?(bill.vat_rate)
    end
    rates
  end
end
