// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('jquery')


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.

// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(document).ready(function() {
    $('#flash').fadeOut(2000, function() {
        $(this).remove();
    });
    $('#playlists-btn').click(function() {
        $('#playlists-container').removeClass('d-none');
        $('#music-container').removeClass('d-flex');
        $('#music-container').addClass('d-none');
        $('#playlists-container').addClass('d-flex');
    });
    $('#artists-btn').click(function() {
        $('#artists-container').removeClass('d-none');
        $('#music-container').removeClass('d-flex');
        $('#music-container').addClass('d-none');
        $('#artists-container').addClass('d-flex');
    });
    $('#playlists-back').click(function() {
        $('#music-container').removeClass('d-none');
        $('#playlists-container').removeClass('d-flex');
        $('#playlists-container').addClass('d-none');
        $('#music-container').addClass('d-flex');
    });
    $('#artists-back').click(function() {
        $('#music-container').removeClass('d-none');
        $('#artists-container').removeClass('d-flex');
        $('#artists-container').addClass('d-none');
        $('#music-container').addClass('d-flex');
    });
});
