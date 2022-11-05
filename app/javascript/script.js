

$(function() {
  $('.drawer-icon').on('click', function(e) {
    e.preventDefault();

    $('.drawer-icon').toggleClass('is-active');
    return false;
  });
});