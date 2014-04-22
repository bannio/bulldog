module InvoicesHelper

  def total_vat(invoice)
    invoice.bills.sum(:vat)
  end

  def vat_by_rate(invoice, rate)
    invoice.bills.vat(rate).sum(:vat)
  end

  def vat_rates(bills)
    # bills.inject([]) do |rates, bill|
    #   rates << bill.vat_rate unless rates.include?(bill.vat_rate)
    #   rates
    # end
    rates = bills.map {|bill| bill.vat_rate}.uniq
  end
end
