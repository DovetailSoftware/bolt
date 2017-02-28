function validate_filter(fieldName) {
	var $field = $("#"+fieldName);
	var filter = $field.val();
	if(filter.length == 0) {
		// alert('You must specify a filter.');
		notify('You must specify a filter.', true);
		$field.focus();
		return false;
	}

	return true;
}

function validate_id(fieldName) {
	var $field = $("#"+fieldName);
	var filter = $field.val();

	if (filter.length == 0) {
		//alert('You must specify a filter.');
		notify('You must specify a filter.', true);
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
		// alert('Table or View ID must be an Integer.');
		notify('Table or View ID must be an Integer.', true);
		$field.focus();
		return false;
	}

	return true;
}

function validate_custom_form() {
   return true;
}

function help(){
	HelpWindow=window.open("","newwin","height=200,width=300");
	HelpWindow.document.write("<HTML><HEAD>");
	HelpWindow.document.write("<TITLE>My Recent Objects</TITLE></HEAD>");
	HelpWindow.document.write("<BODY>");
	HelpWindow.document.write("<B>My Recent Objects</B><P>");
	HelpWindow.document.write("Displays the last 10 tables or views you have opened.<BR>");
	HelpWindow.document.write("Note that you must have cookies turned on in your browser for this to work.<BR><P>");
	HelpWindow.document.write("<a href='javascript:self.close()'> Close This Window");
	HelpWindow.document.write("</BODY>");
	HelpWindow.document.write("</HTML>");
}

function quick_help(){
	HelpWindow=window.open("","newwin","height=200,width=300");
	HelpWindow.document.write("<HTML><HEAD>");
	HelpWindow.document.write("<TITLE>Quick Links</TITLE></HEAD>");
	HelpWindow.document.write("<BODY>");
	HelpWindow.document.write("<B>Quick Links</B><P>");
	HelpWindow.document.write("Displays a list of tables and views that have been configured on a system wide basis for quick access.<BR>");
	HelpWindow.document.write("<P><a href='javascript:self.close()'> Close This Window");
	HelpWindow.document.write("</BODY>");
	HelpWindow.document.write("</HTML>");
}
