function notify(message, isError = false) {
	$('#notifications')
		.empty()
		.text(message)
		.toggleClass('error', isError)
		.removeClass('hidden-xs-up');
}