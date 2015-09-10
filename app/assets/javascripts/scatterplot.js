$(function() {

  $(".candidate_avatar img").mouseover(function(){
    var $target = $("circle" + $(this).attr('data-target'));
    var radius = $target.attr("r");
    $target.attr("r", radius * 2);
  })

  $(".candidate_avatar img").mouseleave(function() {
    var $target = $("circle" + $(this).attr('data-target'));
    var radius = $target.attr("r");
    $target.attr("r", radius / 2);
  })
});
