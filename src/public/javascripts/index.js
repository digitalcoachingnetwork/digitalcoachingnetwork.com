// set defaults, but they will be set dynamically when the DOM is ready
var navHeight = 50,
    subscribeTop = 7079;

function checkScroll(){
  var scrollTop = $(window).scrollTop();
  var isNavTransparent = scrollTop > navHeight && scrollTop < subscribeTop;
  $('.navbar').toggleClass('scrolled', isNavTransparent);
}

function getDimensions() {
  navHeight = $('#stickynav').height();
  subscribeTop = $('#subscribe').offset().top;
}

$(function() {

  $(window).on("load resize", getDimensions);
  $(window).on("scroll load resize", checkScroll);

  // we have to delay getDimensions briefly since they are incorrect for some reason the instant the page loads
  setTimeout(getDimensions, 200);

  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 2000);
        return false;
      }
    }
  });
});
