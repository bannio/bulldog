class InvoicePdf < Prawn::Document
  def initialize(invoice, bills, view)
    super()
    @invoice = invoice
    @bills = bills
    @view = view
    
    define_grid(columns: 3, rows: 7, gutter: 0)
    #grid.show_all
    
    grid([0,0],[0,0]).bounding_box do
      invoice_heading
    end
    grid([0,1],[1,1]).bounding_box do
      our_address
    end
    grid([1,0],[1,1]).bounding_box do
      address_box
    end
    grid([2,0],[6,2]).bounding_box do
      invoice_number_and_date
      invoice_comment
      invoice_table
      invoice_total
      payment_details     
    end
    fold_mark
    invoice_page_number
    
    
  end
  
  def fold_mark
    repeat([1]) do         # only on first page
      transparent(0.5){stroke_horizontal_line -20, -10, at: 464 }
    end
  end
  
  def address_box
    if @invoice.customer.address.present?
      text_box "#{@invoice.customer.name}\n#{@invoice.customer.address}\n#{@invoice.customer.postcode}"
    else
      text_box "#{@invoice.customer.name}\n<color rgb='ff0000'>Update your Customer for their \n address to appear here</color>", 
      inline_format: true
    end
  end
  
  def invoice_heading
    text @invoice.account.invoice_heading || "Invoice", 
          size: 30, 
          style: :bold
  end
  
  def our_address
    if @invoice.account.address.present?
      addr = @invoice.account.address
      postcode = @invoice.account.postcode
      text_box "#{addr}\n#{postcode}", 
        align: :center 
    else
      text_box "<color rgb='ff0000'>Update your Account \n for address to appear here</color>",
        align: :center,
        inline_format: true
    end
  end
  
  def invoice_number_and_date
    data = [["","Invoice No.:", "#{@invoice.number}"],["","Invoice Date:","#{@invoice.date}"]]
    table(data) do
      cells.borders = []
      columns(1).align = :right
      columns(2).align = :right
      columns(0).width = 380
      columns(1).width = 80
      columns(2).width = 80
    end
  end
  
  def invoice_comment
    move_down 15
    text "#{@invoice.comment}", style: :italic
  end
  
  def invoice_table
    move_down 15
    table invoice_lines do
      row(0).font_style = :bold
      columns(3).align = :right
      self.header = true
      cells.borders = []
      row(0).borders = [:bottom]
      row(-1).borders = [:bottom]
      row(0).border_width = 0.5
      row(-1).border_width = 0.5
      columns(0).width = 80
      columns(1).width = 120
      columns(2).width = 220
      columns(3).width = 120
    end
  end
  
  def invoice_lines
    [["Date", "Type", "Description", "Amount"]] +
    @bills.map do |bill|
      [bill.date, bill.category.name, bill.description, price(bill.amount)]
    end
  end
  
  def invoice_total
    move_down 15
    data = [["","Total:", "#{price(@invoice.total)}"]]
    table(data) do
      cells.borders = []
      columns(1).align = :right
      columns(2).align = :right
      columns(0).width = 360
      columns(1).width = 80
      columns(2).width = 100
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

    if @invoice.account.include_bank_details? && payment_table.length > 0
      # move_down 20
      if cursor < 200 #cursor lower than 100
        start_new_page
      end

      text "Please make payment to:", size: 10
      table(payment_table) do
        cells.borders = []
        cells.padding = [0,0,0,0]
        cells.size = 10
        columns(0).width = 100
        columns(1).width = 150
        # columns(1).font_style = :bold
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
    options = {at: [bounds.right - 150,0],
              width: 150,
              align: :right,
              start_count: 1
              }
    number_pages string, options
  end
end