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
      var win_width = $(window).width();
      $(".overlay-dark").css('display', 'block');
      if(win_width < 1040)
        $(".img-overlay").css("width", win_width/1.05)

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

$(document).ready(function() {
  var navpos = $('#toc-nav').offset();
    $(window).bind('scroll', function() {
      if ($(window).scrollTop() > navpos.top) {
        $('#toc-nav').addClass('fixed-navbar');
       }
       else {
         $('#toc-nav').removeClass('fixed-navbar');
       }
    });
});
