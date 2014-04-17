
var bankToggle = function(){
  
  $("#check_bank").click(function(){
    $("#bankaccount").toggleClass("hidden");
  });
}
$(document).on('page:update', bankToggle);