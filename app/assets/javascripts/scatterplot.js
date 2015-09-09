$(function() {
  var radius;
  var $target;
  $(".candidate_avatar").mouseover(function(){
    var $target = $($(this).attr('data-target'));
    var radius = $target.attr("r");
    $target.attr("r-initial", radius);
    $target.attr("r", 60);
  })
  .mouseleave(function() {
    var $target = $($(this).attr('data-target'));
    var rInitial = $target.attr("r-initial");
    $target.attr("r", rInitial);
  })
});
