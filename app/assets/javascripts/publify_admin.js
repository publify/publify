//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require datetimepicker
//= require bootstrap
//= require publify_jquery
//= require administration_jquery
//= require_self
//= require widearea
//= require tagmanager
//= require typeahead
//= require admin_publify
//= require sidebar
//= require lightbox

// Front javascript manifest
//= require ckeditor/init

$('.content-form-tabs a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})

$(function(){
  $('#tag-help-text').hide();
});
