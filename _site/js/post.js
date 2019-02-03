$(document).ready(function(){
  var clipbrd = new Clipboard('.btn-clipboard');
  clipbrd.on('success', function(e) {
    e.clearSelection();
  });
  $('[data-toggle=tooltip]').tooltip({trigger: 'click'});

  $("code").each(function(i, ele){
    $(ele).attr("id", "code-" + i)
    $(ele).prepend("<button type = 'button' data-clipboard-action='copy' data-toggle='tooltip' data-placement='bottom' title='Copy to Clipboard' class = 'btn clippy btn-clipboard' data-clipboard-target='" + "#code-" + i + "'><span alt='Copy to clipboard'>Copy</span></button>");
  });
  $("code").hover(function(){
    $(this).find(".btn-clipboard").css("display", "inline-block");
  })
  $('code').mouseenter(function() {
    $(this).find(".btn-clipboard").css("display", "inline-block");  
  });
  $('code').mouseleave(function() {
    $(this).find(".btn-clipboard").css("display", "none");  
  });

  $(".btn-clipboard").click(function () {
    $(this).text("Copied!");
    setTimeout(function(){
        $(".btn-clipboard").text("Copy");
    }, 1000);
  });

  $(".post .container .row .col-md-9 p img").on('click', function () {
      $src = $(this).attr('src');
      $(".overlay-dark").css('display', 'block');
      $('.img-overlay').css('opacity', 1);
      $('.img-overlay').attr('src', $src);
      $('.img-overlay').css('transform', 'translate(-50%, 0) scale(1, 1)');
  });

  $(".overlay-dark").on('click', function () {
      $(".overlay-dark").css('display', 'none');
      $('.img-overlay').css('opacity', 0);
      setTimeout(function () {
          $('.img-overlay').css('transform', 'translate(-50%, 0) scale(0, 0)');
      }, 600);
  });
 
});


document.addEventListener("DOMContentLoaded", function() {
  var lazyloadImages;    

  if ("IntersectionObserver" in window) {
    lazyloadImages = document.querySelectorAll(".lazy");
    var imageObserver = new IntersectionObserver(function(entries, observer) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          var image = entry.target;
          image.src = image.dataset.src;
          image.classList.remove("lazy");
          imageObserver.unobserve(image);
        }
      });
    });

    lazyloadImages.forEach(function(image) {
      imageObserver.observe(image);
    });
  } else {  
    var lazyloadThrottleTimeout;
    lazyloadImages = document.querySelectorAll(".lazy");
    
    function lazyload () {
      if(lazyloadThrottleTimeout) {
        clearTimeout(lazyloadThrottleTimeout);
      }    

      lazyloadThrottleTimeout = setTimeout(function() {
        var scrollTop = window.pageYOffset;
        lazyloadImages.forEach(function(img) {
            if(img.offsetTop < (window.innerHeight + scrollTop)) {
              img.src = img.dataset.src;
              img.classList.remove('lazy');
            }
        });
        if(lazyloadImages.length == 0) { 
          document.removeEventListener("scroll", lazyload);
          window.removeEventListener("resize", lazyload);
          window.removeEventListener("orientationChange", lazyload);
        }
      }, 20);
    }

    document.addEventListener("scroll", lazyload);
    window.addEventListener("resize", lazyload);
    window.addEventListener("orientationChange", lazyload);
  }
})