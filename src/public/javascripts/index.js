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

function smoothScroll() {

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
}

// replace the subscribe form with a thankyou message
function showThankyou() {
  $('#signup-form').animate({
    opacity: 0
  }, {
    complete: function () {
      $('#signup-form').css('visibility', 'hidden')
      $('#signup-thankyou')
        .fadeIn()
        .removeClass('hidden')
    }
  })
}

// send the email to the server
function signupSubmit() {

  var email = $('#signup-form').serializeArray()[0].value;
  $.post('/signup', { email: email }, showThankyou);

  return false;
}

$(function() {

  $(window).on("load resize", getDimensions);
  $(window).on("scroll load resize", setNavbarTransparency);

  // we have to delay getDimensions briefly since they are incorrect for some reason the instant the page loads
  setTimeout(getDimensions, 200);

  // when the mobile navbar is toggled, ensure that the background is not transparent by toggling .scrolled
  // delay it till the next event loop so that bootstrap goes first
  $('.navbar-toggle').click(setTimeout.bind(null, setNavbarTransparency));

  // when a url frament link is clicked, smooth scroll to the position and close the navbar if open
  $('a[href*=#]:not([href=#])').click(smoothScroll);
  $('#signup-form').submit(signupSubmit);

  if(app.subscribed) {
    showThankyou();
  }

});
