// $(document).ready(function(){
var ready;
ready = function() {
  $("input.date_picker").datepicker({ 
    dateFormat: "yy-mm-dd", changeMonth: true, changeYear: true });

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
        return this.name.localeCompare(term) === 0;
      }).length === 0) {
        return {id: term, text: term, isNew: true};
      } 
    };

  var customerData = $('#bill_customer_id').data('customers');
  var supplierData = $('#bill_supplier_id').data('suppliers');
  var categoryData = $('#bill_category_id').data('categories');

  $('#bill_customer_id').select2({
    placeholder: 'Customer',
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

  $('#bill_supplier_id').select2({
    placeholder: 'Supplier',
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

};

$(document).ready(ready);
$(document).on('page:change', ready);
