$(function() {

  $(".candidate-avatar").mouseover(function(){
    var $target = $("circle" + $(this).attr('data-target'));
    var radius = $target.attr("r");
    $target.attr("r", radius * 2);
  })

  $(".candidate-avatar").mouseleave(function() {
    var $target = $("circle" + $(this).attr('data-target'));
    var radius = $target.attr("r");
    $target.attr("r", radius / 2);
  })
});




