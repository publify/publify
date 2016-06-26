// Admin javascript manifest
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require datetimepicker
//= require bootstrap
//= require publify_jquery
//= require quicktags
//= require widearea
//= require tagmanager
//= require typeahead
//= require admin_publify
//= require sidebar
//= require spinnable
//= require lightbox
//
//= require_self

$(document).ready(function(){
  // DatePickers
  $('.datepicker').datepicker();

  // DropDown
  $(".dropdown-toggle").dropdown();
});
