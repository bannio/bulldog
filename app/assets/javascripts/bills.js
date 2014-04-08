// $(document).ready(function(){
var ready;
ready = function() {

  var customerData        = $('#bill_customer_id').data('customers');
  var invCustomerData     = $('#inv_customer_id').data('customers');
  var invoiceCustomerData = $('#invoice_customer_id').data('customers');
  var supplierData        = $('#bill_supplier_id').data('suppliers');
  var categoryData        = $('#bill_category_id').data('categories');

  function format(item) { return item.name || item.text; };
  function text(value) { return value[0].name || ""; };
  function format_result(term) {
      if (term.isNew) {
        return '<span class="label label-important">New</span> ' + term.text;
      }
      else {
        return term.name;
      }
    };
  function create_choice(term, data) {
      if ($(data).filter(function() {
        return this.name.toLowerCase().localeCompare(term.toLowerCase()) === 0;
      }).length === 0) {
        return {id: term, text: term, isNew: true};
      } 
    };

  $("input.date_picker").datepicker({ 
    dateFormat: "yy-mm-dd", changeMonth: true, changeYear: true });


  $('#bill_customer_id').select2({
    placeholder: 'Customer',
    allowClear: true,
    width: 'resolve',
    data: {results: customerData, text: 'name'},
    initSelection : function (element, callback) {
        var value = $(customerData).filter(function(index){
                      return this.id == element.val();
                    });
        var data = {id: element.val(), 
                    text: text(value)};
        callback(data);
    },
    createSearchChoice: create_choice,
    formatResult: format_result,
    formatSelection: format
  });

  // used in new invoice form

  $('#invoice_customer_id').select2({
    placeholder: 'Customer',
    allowClear: true,
    width: 'resolve',
    data: {results: invoiceCustomerData, text: 'name'},
    // initSelection : function (element, callback) {
    //     var value = $(invoiceCustomerData).filter(function(index){
    //                   return this.id == element.val();
    //                 });
    //     var data = {id: element.val(), 
    //                 text: text(value)};
    //     callback(data);
    // },
    formatResult: format,
    formatSelection: format
  });

  // used in filter section of Invoices index

  $('#inv_customer_id').select2({
    placeholder: 'by customer',
    allowClear: true,
    width: 'resolve',
    data: {results: invCustomerData, text: 'name'},
    initSelection : function (element, callback) {
        var value = $(invCustomerData).filter(function(index){
                      return this.id == element.val();
                    });
        var data = {id: element.val(), 
                    text: text(value)};
        callback(data);
    },
    formatResult: format,
    formatSelection: format
  });

  $('#bill_supplier_id').select2({
    placeholder: 'Supplier',
    allowClear: true,
    width: 'resolve',
    data: {results: supplierData, text: 'name'},
    initSelection : function (element, callback) {
        var value = $(supplierData).filter(function(index){
                      return this.id == element.val();
                    });
        var data = {id: element.val(), 
                    text: text(value)};
        callback(data);
    },
    createSearchChoice: create_choice,
    formatResult: format_result,
    formatSelection: format
  });

  $('#bill_category_id').select2({
    placeholder: 'Category',
    allowClear: true,
    width: 'resolve',
    data: {results: categoryData, text: 'name'},
    initSelection : function (element, callback) {
        var value = $(categoryData).filter(function(index){
                      return this.id == element.val();
                    });
        var data = {id: element.val(), 
                    text: text(value)};
        callback(data);
    },
    createSearchChoice: create_choice,
    formatResult: format_result,
    formatSelection: format
  });

  // This function is adapted to work on either data-rowlink (invoices)
  // or data-url (bills) within a table where the rows have a class of 
  // rowlink. If/when the invoices table changes to JS then this could 
  // be simplified. Note that data-rowlink results in an HTML 

  $('tbody').on('click', 'tr.rowlink', function(e){
    // window.location = $(this).data("rowlink")
    var link = $(this).data("url");
    var link2 = $(this).data("rowlink");
    if (link) {
      $.getScript(link);
      e.stopImmediatePropagation();
    }
    else if (link2) {
      window.location = link2;
    }
    else {
      return false;
    }
  })
};


var bd_popover = function () {
$('#pop').popover();
};

// fix for Select2 not working in modals. Note that this
// overwrites something and maybe isn't the safest option.
$.fn.modal.Constructor.prototype.enforceFocus = function() {};


$(document).ready(ready);
$(document).ready(bd_popover);
$(document).on('page:update', ready);
$(document).on('page:update', bd_popover);






