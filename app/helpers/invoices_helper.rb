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

  def current_plan_name(account)
    if account.plan_id == 0
      "no current subscription"
    else
      account.plan.name + " at " + 
      number_to_currency(@account.plan.amount/100) + " per " + 
      @account.plan.interval
    end
  end

  def next_invoice_date(account)
    if account.next_invoice.present?
      account.next_invoice.strftime("%d/%m/%Y")
    else
      "NA"
    end
  end

  def time_to_next_invoice(account)
    if account.next_invoice.present?
      if account.next_invoice > Time.now
        " - still #{distance_of_time_in_words(Time.now, account.next_invoice)} to go"
      else
        " - no unused subscription"
      end
    else
      ""
    end
  end

  def current_card(account)
    if account.card_last4.present?
      account.card_last4
    else
      "NA"
    end
  end
end
