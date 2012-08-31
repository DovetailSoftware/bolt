$(document).ready(function() {
	$("body").click(function() {
		$("#newTheme", window.parent.document).val($("h2:first").text()).click();
	});
});
