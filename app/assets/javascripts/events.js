$(function() {
  $('.json-row').click(function(e) {
    $(e.target).parents('table').find('.active').removeClass('active');
    $(e.target).parents('.json-row').toggleClass('active');
  });
});
