// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function init_tinyMCE(){
	
if (!tinyMCE) return;
tinyMCE.isLoaded = false;
tinyMCE.onLoad();
}

function update_from_tinyMCE(form){
if (!tinyMCE || !form) return;
tinyMCE.triggerSave();
}

