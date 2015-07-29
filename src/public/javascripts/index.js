// set defaults, but they will be set dynamically when the DOM is ready
var navHeight = 50,
    subscribeTop = 7079;

function isScrolled() {
  var scrollTop = $(window).scrollTop();
  return scrollTop > navHeight && scrollTop < subscribeTop;
}

function isScrolledBottom() {
  var scrollTop = $(window).scrollTop();
  return scrollTop >= subscribeTop;
}

function setNavbarTransparency(){
  $('.navbar')
    .toggleClass('scrolled', !$('.navbar-toggle').is('.collapsed') || isScrolled())
    .toggleClass('scrolled-bottom', isScrolledBottom());
}

function getDimensions() {
  navHeight = $('#stickynav').height();
  subscribeTop = $('#subscribe').offset().top;
}

$(function() {

  $(window).on("load resize", getDimensions);
  $(window).on("scroll load resize", setNavbarTransparency);

  // we have to delay getDimensions briefly since they are incorrect for some reason the instant the page loads
  setTimeout(getDimensions, 200);

  // when the mobile navbar is toggled, ensure that the background is not transparent by toggling .scrolled
  // delay it till the next event loop so that bootstrap goes first
  $('.navbar-toggle').click(setTimeout.bind(null, setNavbarTransparency));

  $('a[href*=#]:not([href=#])').click(function() {

    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {

        $('html,body').animate({
          scrollTop: target.offset().top,
        }, 2000);

        // collapse the navbar if it is open
        if(!$('.navbar-toggle').is('.collapsed')) {
          $('.navbar-toggle').trigger('click');
        }

        return false;
      }
    }
  });
});
