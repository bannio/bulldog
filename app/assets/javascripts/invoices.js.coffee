addSelect =->
  $("#invoice_customer_id").select2
    width: 'resolve'
    placeholder: 'Customer'

$ ->
  $(document).on "page:load", addSelect
  $(document).ready addSelect
  
