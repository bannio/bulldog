require "prawn/table"

class InvoicePdf < Prawn::Document

  def initialize(invoice, bills, view)
    super(page_size: "A4", page_layout: :portrait)
    font_size 9
    font "Helvetica"
    @invoice = invoice
    @bills = bills
    @view = view
    fold_mark
    header
    divider_one
    sub_header
    divider_two
    invoice_comment
    invoice_table
    invoice_total
    # divider_three
    vat_summary_table
    payment_details
    invoice_page_number
    generated_by
  end
  
  def fold_mark
    repeat([1]) do         # only on first page
      transparent(0.5){stroke_horizontal_line -20, -10, at: 514 }
    end
  end
  


  def header
    bounding_box([0,745], :width => 523) do
    float do
      # adds logo
      bounding_box([0,0], :width => 360, :height => 100) do 
        logo = @view.logo_file(@invoice)
        image open("#{ logo.to_s.sub!(/\?.+\Z/, '') }"), :fit => [250, 100] if logo
      end
    end

    # adds our_address
    float do
      bounding_box([360,0], :width => 180, :height => 105, :overflow => :shrink_to_fit) do
        if @invoice.setting.address.present?
          name = @invoice.setting.name
          addr = @invoice.setting.address
          postcode = @invoice.setting.postcode
          tel = @invoice.setting.telephone 
          email = @invoice.setting.email
          user_details = "#{name}\n#{addr}\n#{postcode}\n\n#{'Telephone: ' + tel if tel.present?}\n#{'Email: ' + email if email.present?}"
          text_box user_details, :at => [0,cursor],
           :width => 180, :height => 105,
           :overflow => :shrink_to_fit
        else
          text "<color rgb='ff0000'>Update your Invoice Settings \n for your address to appear here</color>",
            inline_format: true
        end
      end
    end
  end
end

  
  def divider_one
    self.line_width= 0.5
    stroke_horizontal_line 0, 523, :at => [640]
  end

  def sub_header
  bounding_box([0,630], :width => 523) do
    # adds customer address_box
    bounding_box([18,0], :width => 360) do
      customer_details = "#{@invoice.customer_name}\n#{@invoice.customer.address}\n#{@invoice.customer.postcode}"
      if @invoice.customer.address.present?
        text_box customer_details, :at => [0,cursor],
           :width => 360, :height => 85,
           :overflow => :shrink_to_fit
      else
        text_box "#{@invoice.customer_name}\n<color rgb='ff0000'>Update your Customer for their \n address to appear here</color>", 
        inline_format: true
      end 
    end

    @end_of_customer_address = cursor
    
    # adds invoice_heading
      bounding_box([360,0], :width => 180) do
        text_box (@invoice.header_name.upcase).presence || "INVOICE", 
              size: 16, 
              style: :bold,
              :width => 180, :height => 20,
              :overflow => :shrink_to_fit
    end
    
    # adds invoice_number_and_date
      bounding_box([360,cursor], :width => 180) do
        move_down 20
        if @invoice.include_vat?
          if @invoice.header_name.upcase == "INVOICE"
          data = [["Invoice No:", "#{@invoice.number}"],["Invoice Date:","#{@invoice.date}"],["VAT Registration No:","#{@invoice.setting.vat_reg_no}"]]
          else
          data = [["Document No:", "#{@invoice.number}"],["Date:","#{@invoice.date}"],["VAT Registration No:","#{@invoice.setting.vat_reg_no}"]]
          end
        else
          if @invoice.header_name.upcase == "INVOICE"  
          data = [["Invoice No:", "#{@invoice.number}"],["Invoice Date:","#{@invoice.date}"]]
          else
          data = [["Document No:", "#{@invoice.number}"],["Date:","#{@invoice.date}"]]
          end
        end
        table(data) do
        cells.borders = []
        cells.padding = [2,0]
        columns(1).align = :left
        columns(2).align = :left
        columns(0).width = 90
        columns(1).width = 90
      end
    end

    # move_down 15
    move_down 20
  end

  end

  def divider_two
    bounding_box([0,cursor], :width => 523) do
    self.line_width = 0.5
    stroke_horizontal_line 0, 523, :at => [cursor]
    # horizontal_rule
  end
end

  def invoice_comment
    move_down 10
    bounding_box([5,cursor], :width => 520) do
    text "#{@invoice.comment}"
    move_down 10
  end
  end

  def invoice_lines
      if @invoice.include_vat?
        [["Date", "Description", "Amount", "VAT rate", "VAT"]] +
        @bills.map do |bill|
        [bill.date, bill.description, price(bill.excl_vat), bill.vat_rate_value, price(bill.vat)]
      end
      else
        [["Date", "Type", "Description", "Amount"]] +
        @bills.map do |bill|
        [bill.date, bill.category.name, bill.description, price(bill.amount)]     
      end
    end
  end


  def invoice_table
    if cursor > 514
      move_cursor_to 514
    end

    if @invoice.include_vat?
      table invoice_lines do
        row(0).font_style = :bold
        columns(2..4).align = :right
        self.header = true
        cells.borders = []
        cells.padding = [2,5]
        row(0).borders = [:bottom]
        row(-1).borders = [:bottom]
        row(0).border_width = 0.5
        row(-1).border_width = 0.5
        # columns(0).width = 80
        # columns(1).width = 240
        # columns(2).width = 80
        # columns(3).width = 80
        # columns(4).width = 60
        columns(0).width = 75
        columns(1).width = 238
        columns(2).width = 75
        columns(3).width = 75
        columns(4).width = 60
    end
    else
      table invoice_lines do
        row(0).font_style = :bold
        columns(3).align = :right
        self.header = true
        cells.borders = []
        cells.padding = [2,5]
        row(0).borders = [:bottom]
        row(-1).borders = [:bottom]
        row(0).border_width = 0.5
        row(-1).border_width = 0.5
        # columns(0).width = 80
        # columns(1).width = 120
        # columns(2).width = 260
        # columns(3).width = 80
        columns(0).width = 75
        columns(1).width = 115
        columns(2).width = 258
        columns(3).width = 75
    end
  end

  
  def invoice_total
      if @invoice.include_vat?
      data = [["Total excl. VAT", "#{price(@invoice.total - @view.total_vat(@invoice))}", "", "#{price(@view.total_vat(@invoice))}"]]
        table(data) do
          cells.borders = []
          columns(0..3).align = :right
          # columns(0).width = 320
          # columns(1).width = 80
          # columns(2).width = 80
          # columns(3).width = 60
          columns(0).width = 313
          columns(1).width = 75
          columns(2).width = 75
          columns(3).width = 60
          columns(0).font_style = :bold
        end
      else
      data = [["Total:", "#{price(@invoice.total)}"]]
      table(data) do
        cells.borders = []
        columns(0).align = :right
        columns(1).align = :right
        # columns(0).width = 460
        # columns(1).width = 80
        columns(0).width = 448
        columns(1).width = 75
        columns(0).font_style = :bold
        end
      end
    end
  end

  def divider_three
    self.line_width= 0.5
    stroke_horizontal_line 0, 523, :at => [cursor]
    move_down 5
  end

  def vat_summary_table
    if @invoice.include_vat? && vat_summary.length > 0
      table vat_summary do
        columns(1).font_style = :bold
        columns(0..4).align = :right
        cells.borders = []
        cells.padding = [2,5]
        row(0).borders = [:bottom]
        # row(-1).borders = [:bottom]
        row(0).border_width = 0.5
        # row(-1).border_width = 0.5
        columns(0).width = 83
        columns(1).width = 230
        columns(2).width = 75
        columns(3).width = 75
        columns(4).width = 60
      end
    end
  end
  
  def vat_summary
    summary_table = []
    summary_table << ["","VAT", "#{price(@view.total_vat(@invoice))}","",""]
    summary_table << ["","TOTAL", "#{price(@invoice.total)}","",""]
    # @view.vat_rates(@bills).each_with_index do |rate, index|
    # summary_table << ["", "#{'VAT Summary' if index == 0}", "", rate.name, "#{price(@view.vat_by_rate(@invoice, rate))}"]
    # summary_table << ["", "#{'VAT Summary' if index == 0}", "", rate.name, "#{price(@view.vat_by_rate(@invoice, rate))}"]
    # end
    summary_table
  end

  def payment_table
    pay_table = []
    pay_table = pay_table << ["Account Name","#{@invoice.setting.bank_account_name}"] if @invoice.setting.bank_account_name.present?
    pay_table = pay_table << ["Bank","#{@invoice.setting.bank_name}"] if @invoice.setting.bank_name.present?
    pay_table = pay_table << ["Branch","#{@invoice.setting.bank_address}"] if @invoice.setting.bank_address.present?
    pay_table = pay_table << ["Sort Code:","#{@invoice.setting.bank_sort}"] if @invoice.setting.bank_sort.present?
    pay_table = pay_table << ["Account No:","#{@invoice.setting.bank_account_no}"] if @invoice.setting.bank_account_no.present?
    pay_table = pay_table << ["BIC:","#{@invoice.setting.bank_bic}"] if @invoice.setting.bank_bic.present?
    pay_table = pay_table << ["IBAN:","#{@invoice.setting.bank_iban}"] if @invoice.setting.bank_iban.present?
    pay_table

  end

  def payment_details

    if @invoice.include_bank_details? && payment_table.length > 0
      move_down 5
      if cursor < 95 
        start_new_page
      end
      if cursor > 300
        move_down 50
      end
      text "<b>Please make payment to:</b>", inline_format: true
      move_down 5
      table(payment_table) do
        cells.borders = []
        cells.padding = [0,0]
        columns(0).width = 100
        columns(1).width = 150
      end
    end
  end
  
  def price(num)
    @view.number_to_currency(num)
  end
  
  def invoice_page_number
    string = "page <page> of <total>"
    options = {
              at: [bounds.left,8],
              start_count: 1,
              size: 8
              }
    number_pages string, options

  end


  def generated_by
    repeat(:all) do
      draw_text "generated using www.bulldogclip.co.uk", :at => [420,5], size: 6
    end
  end
end