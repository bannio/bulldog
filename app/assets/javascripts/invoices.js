
var strikeThrough = function(){

  $("#bill_table_body").on("click", "td.remove-col",function(){
    $("this").parent().toggleClass("line-through");
  });
}
$(document).ready(strikeThrough);
$(document).on('page:update', strikeThrough);