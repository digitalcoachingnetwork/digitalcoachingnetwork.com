// $(document).on('scroll', function (e) {
//     $('#stickynav').css('opacity', ($(document).scrollTop() / 500));
// });

function checkScroll(){
  var startY = 50; // the point where the navbar changes in px
  $('.navbar').toggleClass('scrolled', $(window).scrollTop() > startY);
}

if($('.navbar').length > 0){
    $(window).on("scroll load resize", checkScroll);
}

$(function() {
  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 2500);
        return false;
      }
    }
  });
});
