$(window).on('scroll', function() {
  scrollHeight = $(document).height();
  scrollPosition = $(window).height() + $(window).scrollTop();
  if ( (scrollHeight - scrollPosition) / scrollHeight <= 0.05) {
    $('.jscroll').jscroll({
      nextSelector: 'a.next',
      loadingHtml: '読み込み中',
      contentSelector: '.jscroll'
    });
  }
});