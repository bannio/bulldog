class InvoicePdf < Prawn::Document 

  def initialize(invoice, bills, view)
    super()
    font_size 9
    font "Helvetica"
    @invoice = invoice
    @bills = bills
    @view = view
    # stroke_axis
    fold_mark
    header
    divider_one
    sub_header
    divider_two
    invoice_comment
    invoice_table
    invoice_total
    divider_three
    vat_summary_table
    payment_details
    invoice_page_number
    generated_by
  end
  
  def fold_mark
    repeat([1]) do         # only on first page
      transparent(0.5){stroke_horizontal_line -20, -10, at: 464 }
    end
  end
  
  def header
    bounding_box([0,720], :width => 540) do
    float do
      # adds logo
      bounding_box([0,0], :width => 360, :height => 100) do 
        logopath =  "#{Rails.root}/app/assets/images/UbuntuLogo.png"
        image logopath, :fit => [250, 110]
      end
    end

    # adds our_address
    float do
      bounding_box([360,0], :width => 180) do
        if @invoice.setting.address.present?
          name = @invoice.setting.name
          addr = @invoice.setting.address
          postcode = @invoice.setting.postcode
          # tel = @invoice.setting.telephone
          # email = @invoice.setting.email
          text "#{name}\n#{addr}\n#{postcode}\n\ntelephone to add\nemail to add"

        else
          text "<color rgb='ff0000'>Update your Account \n for address to appear here</color>",
            inline_format: true
        end
      end
    end
  end
end

  
  def divider_one
    self.line_width= 0.5
    stroke_horizontal_line 0, 540, :at => [610]
  end

  def sub_header
  bounding_box([0,600], :width => 540) do
    # adds customer address_box
    bounding_box([14,0], :width => 360) do
      if @invoice.customer.address.present?
        text_box "#{@invoice.customer.name}\n#{@invoice.customer.address}\n#{@invoice.customer.postcode}" 
      else
        text_box "#{@invoice.customer.name}\n<color rgb='ff0000'>Update your Customer for their \n address to appear here</color>", 
        inline_format: true
      end 
    end
    
    # adds invoice_heading
      bounding_box([360,0], :width => 180) do
        text_box @invoice.header_name.upcase || "INVOICE", 
              size: 16, 
              style: :bold
    end
    
    # adds invoice_number_and_date
      bounding_box([360,cursor], :width => 180) do
        move_down 20
        if @invoice.include_vat?
          data = [["Invoice No:", "#{@invoice.number}"],["Invoice Date:","#{@invoice.date}"],["Time of Supply:","to be added"],["VAT Registration No:","#{@invoice.setting.vat_reg_no}"]]
        else  
          data = [["Invoice No:", "#{@invoice.number}"],["Invoice Date:","#{@invoice.date}"]]
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
    move_down 15
  end

  end
  
  def divider_two
    self.line_width= 0.5
    stroke_horizontal_line 0, 540, :at => [cursor]
        # text "<color rgb='ff0000'>#{cursor}</color>",
        #    inline_format: true     
  end

  def invoice_comment
    move_down 10
    bounding_box([5,cursor], :width => 525) do
    text_box "#{@invoice.comment}"
    move_down 20
  end
  end
  


  def invoice_table
    # text "#{cursor}"
    move_down 15
        bounding_box([0,cursor], :width => 540) do
        #                            stroke_bounds
        # stroke_circle [0, 0], 10
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
          columns(0).width = 80
          columns(1).width = 240
          columns(2).width = 80
          columns(3).width = 80
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
          columns(0).width = 80
          columns(1).width = 120
          columns(2).width = 260
          columns(3).width = 80
        end
      end
    end
  end
  
  def invoice_lines
      if @invoice.include_vat?
        [["Date", "Description", "Amount", "VAT rate", "VAT"]] +
        @bills.map do |bill|
        [bill.date, bill.description, price(bill.amount), bill.vat_rate_name, price(bill.vat)]
      end
      else
        [["Date", "Type", "Description", "Amount"]] +
        @bills.map do |bill|
        [bill.date, bill.category.name, bill.description, price(bill.amount)]     
      end
    end
  # else
  # [["Date", "Description", "Amount"]] +
  #   @bills.map do |bill|
  #     [bill.date, bill.description, price(bill.amount)]
  # end
  end
  
  def invoice_total
    move_down 10
    bounding_box([0,cursor], :width => 540) do
      data = [["Total:", "#{price(@invoice.total)}"]]
      if @invoice.include_vat?

        table(data) do
          cells.borders = []
          columns(0).align = :right
          columns(1).align = :right
          columns(0).width = 320
          columns(1).width = 80
          columns(0).font_style = :bold
          # columns(2).width = 100
        end
      else
      # data = [["Total:", "#{price(@invoice.total)}"]]
      table(data) do
        cells.borders = []
        columns(0).align = :right
        columns(1).align = :right
        columns(0).width = 460
        columns(1).width = 80
        columns(0).font_style = :bold
        # columns(2).width = 100 
        end
      end
    end
  end

  def divider_three
    self.line_width= 0.5
    stroke_horizontal_line 0, 540, :at => [cursor]
    move_down 5
  end

  def vat_summary_table
    if @invoice.include_vat?
      # if vat_enabled?
      bounding_box([0,cursor], :width => 540) do
          # stroke_bounds
          # stroke_circle [0, 0], 10
        table vat_summary do
          columns(1).font_style = :bold
          columns(0..4).align = :right
          # self.header = true
          cells.borders = []
          cells.padding = [2,5]
          columns(0).width = 80
          columns(1).width = 240
          columns(2).width = 80
          columns(3).width = 80
          columns(4).width = 60
        end
      end
    else
        #do nothing
    end
  end
  
  def vat_summary
    [["","VAT Summary:","", "", ""]] +
    @bills.map do |bill|
      ["", "", "", bill.vat_rate_name, bill.vat]
    end
  end




  def payment_table
    pay_table = []
    pay_table = pay_table << ["Account Name","#{@invoice.account.bank_account_name}"] if @invoice.account.bank_account_name.present?
    pay_table = pay_table << ["Bank","#{@invoice.account.bank_name}"] if @invoice.account.bank_name.present?
    pay_table = pay_table << ["Branch","#{@invoice.account.bank_address}"] if @invoice.account.bank_address.present?
    pay_table = pay_table << ["Sort Code:","#{@invoice.account.bank_sort}"] if @invoice.account.bank_sort.present?
    pay_table = pay_table << ["Account No:","#{@invoice.account.bank_account_no}"] if @invoice.account.bank_account_no.present?
    pay_table = pay_table << ["BIC:","#{@invoice.account.bank_bic}"] if @invoice.account.bank_bic.present?
    pay_table = pay_table << ["IBAN:","#{@invoice.account.bank_iban}"] if @invoice.account.bank_iban.present?
    pay_table

  end

  def payment_details

    if @invoice.include_bank_details? && payment_table.length > 0
      # move_down 20
      # if cursor < 200 #cursor lower than 100
        # start_new_page
      # end
      # text "#{cursor}"
      bounding_box([5,cursor], :width => 535) do
        text_box "<b>Please make payment to:</b>", inline_format: true
        move_down 15
        table(payment_table) do
          cells.borders = []
          cells.padding = [0,0]
          # cells.size = 9
          columns(0).width = 100
          columns(1).width = 150
        end
      end
      else
      # do nothing
    end
  end
  
  def price(num)
    @view.number_to_currency(num)
  end
  
  def invoice_page_number
    string = "page <page> of <total>"
    options = {
              at: [bounds.left,0],
              # align: :center,
              start_count: 1,
              size: 8
              }
    number_pages string, options
    #   def invoice_page_number
    # string = "page <page> of <total>"
    # options = {at: [bounds.right - 150,0],
    #           width: 150,
    #           align: :right,
    #           start_count: 1
    #           }
    # number_pages string, options
  end


  def generated_by
    repeat(:all) do
      draw_text "generated using www.bulldogclip.co.uk", :at => [400,-5], size: 8
    end
  end
end