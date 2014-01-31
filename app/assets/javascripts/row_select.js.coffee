attachRowLinkHandler =->
  $('tr.rowlink').click ->
    window.location = $(this).data("rowlink")
jQuery ->
  $(document).on "page:load", attachRowLinkHandler
  $(document).ready attachRowLinkHandler