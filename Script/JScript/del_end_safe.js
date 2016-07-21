// JavaScript Document
//*****************************************************************************
//	filename   : del_end_safe.js
//	description: Delete to the end of line more slow but more safe than del_end
//	created    : 11.10.2006
//	author     : Serge Balance
//
//	You may distribute this script freely, but please keep this header intact.
//*****************************************************************************
var MODULE_NAME  = "Del to right safe";
var MODULE_VER   = "0.5";
var MODULE_TITLE = "Delete to the end of line slowly but safe";
function Init() {
    menuName = "&" + MODULE_NAME;
    subMenu = "&" + "Edit";
    addMenuItem(menuName, subMenu, "main", "CTRL+SHIFT+DEL");
}

function main() {
var	ed = neweditor();
ed.assignActiveEditor();
var text = new String(ed.text());
var curx = ed.caretX();
var cury = ed.caretY();
var ind = indexInText(text, curx, cury);
var str = new String();
var brk;
str = text.substring(0,ind);
brk = text.indexOf("\n", ind);
str += text.substring(brk, text.length);
ed.text(str);
ed.setCaretPos(curx, cury);
}

function indexInText(text, curx, cury) { //function for lib WSH-PSPad
// calculate linear coordinate in String text, based on cursor coordinates 
var i = 1; // from first line, not zero
var pos = 0;
var cursymb = new String();
while (i < cury) {
	pos = text.indexOf("\n",pos);
	pos++; // next search from next position
	i++;
}
cursymb = text.charAt(pos);
if ((cursymb == "\n") || (cursymb == "\r") || (cursymb == "\f")) {
	pos++;
}
pos = pos + curx - 1; // Array index from 0, string index from 1
return (pos);
}
