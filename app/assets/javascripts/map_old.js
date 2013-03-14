// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require jquery.address.min
//= require maps_lib
//= require jquery-ui-slider.min

$(window).resize(function () {
  var h = $(window).height(),
    offsetTop = 70; // Calculate the top offset

  $('#mapCanvas').css('height', (h - offsetTop));
  $('#view_accordion').css('height', (h - offsetTop - 120));
}).resize();

$(function() {
  $('label.checkbox.inline').popover();

  MapsLib.initialize();

  $('.accordion-toggle').click(function(){
    var view = $(this).attr('data-view');
    var colors = $(this).attr('data-colors');
    MapsLib.doSearch(view, colors);
  });

  $("#diabetes-year").slider({
      orientation: "horizontal",
      range: "min",
      min: 2006,
      max: 2010,
      value: 1,
      slide: function (event, ui) {
          $("#diabetes-year-selected").html(ui.value);
          MapsLib.doSearch(ui.value + " diabetes percent", '["#B2E2E2", "#66C2A4", "#2CA25F", "#006D2C"]');
      }
  });
  $("#diabetes-year-selected").html($("#diabetes-year").slider("value"));

  $('.accordion').on('show', function (e) {
     $(e.target).prev('.accordion-heading').find('.accordion-toggle').addClass('active');
  });

  $('.accordion').on('hide', function (e) {
      $(this).find('.accordion-toggle').not($(e.target)).removeClass('active');
  });

  $('#accordionDiabetes').click();

});