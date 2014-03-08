var select;

select = function() {

$('#report_customer_id').select2({
    placeholder: 'Customer',
    // width: 'resolve',
    allowClear: true
  });

$('#report_supplier_id').select2({
    placeholder: 'Supplier',
    // width: 'resolve',
    allowClear: true
  });

$('#report_category_id').select2({
    placeholder: 'Category',
    // width: 'resolve',
    allowClear: true
  });
};

$(document).on('page:update', select);