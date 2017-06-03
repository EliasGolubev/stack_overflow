jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  if typeof(scrollPos) == 'undefined'
      scrollPos = 0
  $(window).scroll ->
    offset = $(".navbar-fixed-top").offset()
    if offset.top > 55
      if scrollPos < offset.top
        $(".navbar-fixed-top").fadeOut()
      else
        $(".navbar-fixed-top").fadeIn()
    scrollPos = $(".navbar-fixed-top").offset().top
