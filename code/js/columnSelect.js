function resetColumnSelection() {
	$(".temp, .column").remove();
	$(".columnHighlight").removeClass("columnHighlight");
}

function columnSelect() {
   $(".headerRow th").dblclick(function() {
   	resetColumnSelection()

   	$th = $(this);
   	var colIndex = $th.index();
   	var colData = "";
		$th.parents("table").find("tbody tr").each(function() {
			var $columnCell = $(this).children("td:eq(" + colIndex + ")");
			colText = $.trim($columnCell.text());
			$columnCell.addClass("columnHighlight");
			if(colText > "") colData += ((colData > "")? ", " : "") + colText;
		});

		$("<span class='column'>Text from Selected Column:<i class='icon icon-remove deleteIcon' title='Hide column text'></i></span><input type=text class=temp title='text from column' />").val(colData).insertBefore($th.parents("table"));
		$(".temp").focus().select();
      return false;
   });
}

$(document).ready(function() {
   $("<p class='helpSpan'>(double-click a column header to select column text)</p>").insertAfter("#fields");
   $(".deleteIcon").live("click", resetColumnSelection);

   columnSelect();
});
