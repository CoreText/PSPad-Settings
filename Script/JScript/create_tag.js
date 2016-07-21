/*******************************************************************************
	Filename		: create_tag.js
	
	Created			: 22 September 2005
	Created by		: James Swan 
	
	Description		: Converts the word left of the cursor into a tag and places
					  the cursor between them. If the word ends with a blank space
					  then no closing tag is added. If the word ends with a "."
					  then an xml/xhtml style "non-closing" tag is added. If a
					  "non-closing" tag is added then the cursor is placed inside
					  the tag.

	Note			: This script has only been tested on Windows 2000 and XP
	
	You may distribute this script freely, but please keep this header intact.
*******************************************************************************/
var module_name = "CreateTag";
var module_ver = "0.1";
var module_title = "Create Tag";

function Init() {
	addMenuItem (module_title, "&HTML", module_name, "ALT+,");
}

function CreateTag() {

	var strInput = "";
	var strOutput = "";
	var editor = newEditor();
	var nonClosingTags = "|area|base|basefont|bgsound|col|frame|hr|img|input|isindex|link|meta|param|spacer|wbr|"

	if (!editor) return;
	editor.assignActiveEditor();

	// grab the character to the left of the cursor
	editor.command("ecSelLeft");
	var strPreviousChar = editor.selText();

	// return the cursor to its original position
	editor.command("ecRight");

	if (strPreviousChar != " " && strPreviousChar != ".") {

		// grab the word to the left of the cursor
		editor.command("ecSelWordLeft");
		strInput = editor.selText();

		if(strInput == "br") {
			
			// construct the tag
			strOutput = "<"+strInput+">";
			
			// write the tag to the document
			editor.selText(strOutput);
			
		}else if(nonClosingTags.indexOf("|"+strInput.toLowerCase()+"|") != -1) {

			// construct the tag
			strOutput = "<"+strInput+">";
			
			// write the tag to the document
			editor.selText(strOutput);
			
			// position the cursor inside the tag
			editor.command("ecLeft");
			
		} else {

			// construct the tag
			strOutput = "<"+strInput+"></"+strInput+">";
			
			// write the tag to the document
			editor.selText(strOutput);
	
			// position the cursor between the start and end tag
			editor.command("ecWordLeft");
			editor.command("ecLeft");
			editor.command("ecLeft");
		}

	}else {

		// grab the word to the left of the cursor
		editor.command("ecLeft");
		editor.command("ecSelWordLeft");
		strInput = editor.selText();

		// construct the tag
		var tagClose = (strPreviousChar == " ")? ">": " />";
		strOutput = "<"+strInput+tagClose;

		// write the tag to the document
		editor.selText(strOutput) ;

		// delete the trailing character
		editor.command("ecSelRight");
		editor.selText("");

		// position the cursor inside the tag
		editor.command("ecLeft");
		if(strPreviousChar == ".") {
			editor.command("ecLeft");
			editor.command("ecLeft");
		}

	}
}
