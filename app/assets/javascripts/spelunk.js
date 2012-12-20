$(function(){

  $('input[type=submit]').click(start_crawling);

});

function start_crawling()
{
  $('form').submit();
  setInterval(get_photos, 250);
  return false;
}

function get_photos()
{
  $.ajax({
    type: "GET",
    url: "/photo"
  }).done(function( msg ) {
    if(msg != null)
    {
      var div = $('<div>');
      div.addClass('photo');
      div.css('background', 'url(' + msg.url + ') no-repeat');
      $('#photos').prepend(div);
    }
  });
}
