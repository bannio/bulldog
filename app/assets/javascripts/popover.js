var bd_popover = function () {
$('#pop').popover({html : true, trigger : 'hover', placement : 'left', container : 'body' });
};
$(document).ready(bd_popover);
$(document).on('page:update', bd_popover);


// useful code if we want to change to click away or on x button to close. incase the hover function doesn't work for ipad/phone
// 
// var isVisible = false;
// var clickedAway = false;

// $('#pop').popover({
//         html: true,
//         trigger: 'manual'
//     }).click(function(e) {
//         $(this).popover('show');
//     $('.popover-content').append('<a class="close" style="position: absolute; top: 0; right: 6px;">&times;</button>');
//         clickedAway = false
//         isVisible = true
//         e.preventDefault()
//     });

// $(document).click(function(e) {
//   if(isVisible & clickedAway)
//   {
//     $('.btn-danger').popover('hide')
//     isVisible = clickedAway = false
//   }
//   else
//   {
//     clickedAway = true
//   }
// });

