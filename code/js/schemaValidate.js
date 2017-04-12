function validate_filter(fieldName) {
	var $field = $("#"+fieldName);
	var filter = $field.val();
	if(filter.length == 0) {
		addNotification('You must specify a filter.');
		$field.focus();
		return false;
	}

	return true;
}

function validate_id(fieldName) {
	var $field = $("#"+fieldName);
	var filter = $field.val();

	if (filter.length == 0) {
		addNotification('You must specify a filter.');
		$field.focus();
		return false;
	}

	// Make sure the data is an integer
	// Search through string's characters one by one
	// until we find a non-numeric character.
	// Start by assuming that it is an Integer

	var isInteger = true;
	for(var i = 0; i < filter.length; i++) {
		// Check that current character is number.
		var c = filter.charAt(i);
		if(!((c >= "0") && (c <= "9"))) isInteger = false;
	}

	if(!isInteger) {
		addNotification('Table or View ID must be an Integer.');
		$field.focus();
		return false;
	}

	return true;
}
