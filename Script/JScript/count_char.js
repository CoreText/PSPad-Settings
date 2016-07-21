/*******************************************************************************
	Filename		: count_char.js
	Description		: Counts the number of characters in the selected text of 
					  the active document.

	Created			: 19 September 2005
	Created By		: James Swan

	Note			: This script has only been tested on Windows 2000 and XP.

	You may distribute this script freely, but please keep this header intact.
'*******************************************************************************/

module_name = "CountChar";
module_ver = "0.1";

function Init() {
	addMenuItem ("Count Char", "Utilities", "CountChar");
}

function CountChar() {

	var editor = newEditor();
	if (!editor) return;
	editor.assignActiveEditor();

	var strInput = editor.selText();
	var intLen = strInput.length;

	if (intLen == 0) {
	   echo("Please select some text...\t");
	}else {
		echo("The selection is " + intLen + " characters long.");
	}

}
