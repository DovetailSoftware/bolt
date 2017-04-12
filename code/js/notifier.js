function notify(message, isError = false) {
	$('#notifications')
		.empty()
		.text(message)
		.removeClass('hidden-xs-up');
}