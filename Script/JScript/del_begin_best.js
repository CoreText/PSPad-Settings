// JavaScript Document
//*****************************************************************************
//	filename   : del_begin_best.js
//	description: Delete to the begining of line
//	created    : 24.11.2006
//	author     : Serge Balance
//
//	You may distribute this script freely, but please keep this header intact.
//*****************************************************************************
var MODULE_NAME  = "Del to left best";
var MODULE_VER   = "0.7";
var MODULE_TITLE = "Delete to the begining of line";
function Init() {
    menuName = "&" + MODULE_NAME;
    subMenu = "&Edit";
    addMenuItem(menuName, subMenu, "main", "CTRL+SHIFT+BKSP");
}

function main() {
var	ed = neweditor();
ed.assignActiveEditor();
ed.command('ecDeleteBOL');
}
