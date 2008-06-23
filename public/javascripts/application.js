// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
tinyMCE.init({
    theme:"advanced",
    mode:"textareas",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_path_location : "bottom",
    theme_advanced_resize_horizontal : false,
    theme_advanced_resizing : true,
    auto_reset_designmode : true,
    width : "600"
});   
requestOnLoad = function() {
														tinyMCE.idCounter=0;
														tinyMCE.execCommand('mceAddControl',true,'record[description]');
													 }
