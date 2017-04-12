var $button = $('<button type="button" class="close" data-dismiss="alert" aria-label="Close"></button>')
								.append('<span aria-hidden="true">&times;</span>');
var $alertTemplate = $('<div class="alert alert-danger alert-dismissible fade show col-6 offset-3" role="alert"></div>')
								.append($button)
								.append('<div class="message"></div>');

function addNotification(message) {
	$('div.alert').remove();
	var $alert = $alertTemplate.clone();
	$alert.find('div.message').append(message);
	$alert.insertAfter('.navbar');
}

