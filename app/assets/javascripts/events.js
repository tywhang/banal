$(function() {
  $('.json-row').click(function(e) {
    $(e.target).parents('table').find('.active').removeClass('active');
    $(e.target).parents('.json-row').toggleClass('active');
  });

  $(".js-navigation-link").click(function(e) {
      $("body").animate({ scrollTop: $($(e.target).data().target).offset().top }, 1000);
  });
});
