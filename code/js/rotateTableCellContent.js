(function ($) {
  $.fn.rotateTableCellContent = function (options) {
  /*
  Version 1.0
  7/2011
  Written by David Votrubec (davidjs.com) and
  Michal Tehnik (@Mictech) for ST-Software.com
  */

		var cssClass = ((options) ? options.className : false) || "vertical";

		var cellsToRotate = $('.' + cssClass, this);

		var betterCells = [];
		cellsToRotate.each(function () {
			var cell = $(this)
		  , newText = cell.text()
		  , height = 20 //cell.height()
		  , width = 300 //cell.width()
		  , newDiv = $('<div>', { height: width, width: height })
		  , newInnerDiv = $('<div>', { text: newText, style: 'text-align: left; margin-left: -276px; width: 570px;', 'class': 'rotated' });

			newDiv.append(newInnerDiv);

			betterCells.push(newDiv);
		});

		cellsToRotate.each(function (i) {
			$(this).html(betterCells[i]);
		});
	};
})(jQuery);