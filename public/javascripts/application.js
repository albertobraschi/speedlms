function init_tinyMCE() {
	if (!tinyMCE) return;
	tinyMCE.isLoaded = false;
	tinyMCE.onLoad();
}

function update_from_tinyMCE(form) {
	if (!tinyMCE || !form) return;
	tinyMCE.triggerSave();
}

