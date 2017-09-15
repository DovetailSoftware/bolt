function resetColumnSelection() {
  $(".temp, .column").remove();
  $('button.close').remove();
  $(".columnHighlight").removeClass("columnHighlight");
}

function columnSelect() {
   $(".headerRow th").dblclick(function() {
    resetColumnSelection()

    $th = $(this);
    var colIndex = $th.index();
    var colData = [];
    $th.parents("table").find("tbody tr").each(function() {
      var $columnCell = $(this).children("td:eq(" + colIndex + ")");
      colText = $.trim($columnCell.text());
      $columnCell.addClass("columnHighlight");
      if(colText > "" && colData.indexOf(colText) === -1) {
        colData.push(colText);
      }
    });

    $("<span class='column d-inline'>Text from Selected Column:</span><button type='button' class='close float-none ml-2' title='Close'><span>&times;</span></button><input type=text class='temp' title='text from column' />").val(colData).insertBefore($th.parents("table"));
    $("button.close").click(resetColumnSelection);

    $(".temp").keydown(function(e) {
      if (e.keyCode === 27) {
        $("button.close").trigger('click');
      }
    });

    $(".temp").focus().select();
    return false;
   });
}

$(document).ready(function() {
  $("<p class='text-right small p-0' style='margin:-1.7rem 0 0;'>(double-click a column header to select column text)</p>").insertAfter("#fields");
  columnSelect();
});
