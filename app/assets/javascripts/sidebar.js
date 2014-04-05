  var stickSidebar = function () {
$('#sidebar').affix();
};
  $(document).on('page:update', stickSidebar);