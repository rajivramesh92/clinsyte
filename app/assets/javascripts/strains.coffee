# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  try ->
    draw_thc_fingerprint();
    draw_cbd_fingerprint();
    draw_cannabinoids_fingerprint();
    draw_terpenoids_fingerprint();

    $('.donut').peity('donut')

$(document).ready(ready)
$(document).on('page:load', ready)
$(window).resize(ready);
