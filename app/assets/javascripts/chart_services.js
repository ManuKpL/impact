$(function(){
  $('.chart-menu-item').click(function(){
    var chart = $(this).data('chart')
    $('.chart-container').addClass('hidden')
    $('.active').removeClass('active')
    $(this).addClass('active')
    $('#' + chart).removeClass('hidden')
    $('#' + chart).prependTo('.chart-overlay')
    $('.legend').addClass('hidden')
    $('#' + chart + '-legend').removeClass('hidden')
  })
})
