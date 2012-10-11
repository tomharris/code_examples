//= require_self
//= require_tree .

/* video setup and compatibility */
$(function() {
  $('video').makeVideosCompatible();
  $('video').stopOtherVideosWhenPlayed();
});