
var bankToggle = function(){
  
  $("#check").click(function(){
    $("#bankaccount").toggleClass("hidden");
  });
}
$(document).on('page:update', bankToggle);