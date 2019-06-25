//  (c) 2019 Antonio Perdices.
//  License: Public Domain.
//	You can use this code freely and wisely in your applications.

function insertAtCursor (fieldName, textToInsert) {
	
	var targetField = document.getElementById(fieldName);

	// IE support.
	// Uses IE text range funcion.
	if (document.selection) {
		targetField.focus();
		sel = document.selection.createRange();
		sel.text = textToInsert;
	}

	// MOZILLA/NETSCAPE support.
	else if (targetField.selectionStart || targetField.selectionStart == '0') {
		var startPos = targetField.selectionStart;
		var endPos = targetField.selectionEnd;
		targetField.value = targetField.value.substring(0, startPos) + textToInsert + targetField.value.substring(endPos, targetField.value.length);

	// None of the above.
	} else {
		targetField.value += textToInsert;
	}

}