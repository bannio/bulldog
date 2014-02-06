attachRowLinkHandler =->
  $('tr.rowlink').click ->
    window.location = $(this).data("rowlink")
$ ->
  $(document).on "page:change", attachRowLinkHandler