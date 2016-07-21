// JavaScript Document
//*******************************************************************************
//	filename   : tag_close.js
//	description: Automatic closing html tag
//	created    : 08.10.2006
//	author     : Serge Balance
//
//	You may distribute this script freely, but please keep this header intact.
//*******************************************************************************
var MODULE_NAME  = "autoclosing TAG";
var MODULE_VER   = "1.2";
var MODULE_TITLE = "Automatic closing html tag";
function Init() {
    menuName = "&" + MODULE_NAME;
    subMenu = "&" + "HTML";
    addMenuItem(menuName, subMenu, "main", "ALT+.");
}

var htmlTAGsingle = new Array("area", "base", "basefont", "br", "col", "frame", "hr", "img", "input", "isindex", "link", "meta", "param");

var htmlTAGpair = new Array("a", "abbr", "acronym", "address", "applet", "area", "b", "bdo", "big", "blink", "blockquote", "body", "button", "caption", "center", "cite", "code", "colgroup", "dd", "del", "dfn", "dir", "div", "dl", "dt", "em", "fieldset", "object", "font", "form", "textarea", "frameset", "noframes", "frameset", "html", "form", "h1", "h2", "h3", "h4", "h5", "h6", "head", "style", "i", "iframe", "ilayer", "ins", "kbd", "label", "layer", "legend", "li", "listing", "map", "marquee", "menu", "script", "multicol", "nobr", "noembed", "nolayer", "noscript", "object", "ol", "optgroup", "option", "p", "pre", "q", "s", "samp", "select", "server", "small", "span", "strike", "strong", "sub", "sup", "table", "td", "tr", "div", "tbody", "tfoot", "th", "thead", "textarea", "title", "tt", "u", "ul", "var", "comment", "xml", "xmp");

function main() {
var	ed = neweditor();
ed.assignActiveEditor();
var text = new String(ed.text());
var curx = ed.caretX();
var cury = ed.caretY();
var cursymb, i, pos, postest, posopen;
var insString = new String();
var stk = new Array();
var stkpop = new String();
var tagName = new String();

pos = indexInText(text, curx, cury); //index correction counted in indexInText
postest = pos - 1; // - 1 for search not from current position
insString = "";
while ((posopen = text.lastIndexOf("<",postest)) != -1) {
	cursymb = text.substring(posopen,postest+1);
	if (text.charAt(posopen+1) != "/") {
		tagName = matchOpenTagName(cursymb);
		if ((tagName != null) && (isSingleTag(cursymb, tagName, htmlTAGsingle) == false)) {
			if (stk.length > 0) {
				stkpop = stk.pop();
				if (tagName != stkpop) {
					incorrect_html(stkpop, "left");
					return (-1); // with incorect html we don't working
				}
			} else {
				i = isInArray(tagName, htmlTAGpair); // without it script will close ANY not single tags
				if (i != -1) {
					insString = "</" + htmlTAGpair[i] + ">";
				}
			}
		}
	} else { //building stack closed tags
		tagName = matchCloseTagName(cursymb);
		if (tagName != null) { stk.push(tagName); } // if null - broken tag
	}
	if (insString != "") { break };
	postest = posopen - 1;
	if (postest <= 0) { break; }
}
if (insString != "") {
postest = pos;
var closed = false; //check may be first unpair tag from left already closed on right
	while ((posopen = text.indexOf("<",postest)) != -1) {
		cursymb = text.substring(posopen,text.length);
		if (text.charAt(posopen+1) == "/") {
			tagName = matchCloseTagName(cursymb);
			if (stk.length > 0) {
				stkpop = stk.pop()
				if ((tagName == null) || (tagName != stkpop)) {
					incorrect_html(stkpop, "right");
					return (-1); // with incorect html we don't working
				}
			} else {
			if ((tagName != null) && ("</"+tagName+">" == insString)) {
				closed = true;
			}
			break; // if first unpair closing tag at right not our - it's OK!
			}
		} else { //building stack opened tags
			tagName = matchOpenTagName(cursymb);
			if ((tagName != null) && (isSingleTag(cursymb, tagName, htmlTAGsingle) == false)) {
				stk.push(tagName);
			} // if null - broken tag
		}
		postest = posopen + 1;
		if (postest >= text.length) { break; }
	}
	if (closed) {
		echo("Tag already closed!");
		return (-1);
	} else {
		ed.text(text.substring(0,pos) + insString + text.substring(pos,text.length-1));
		ed.setCaretPos(curx + insString.length, cury);
		return (0);
	}
} else {
	echo("Open tag not found!");
	return (-1);
}
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

function matchXMLsingleTagName(str) {
	return(((str.match(/^<(\w+)\s\/>/i)) != null) ? RegExp.$1 : null);
}

function matchOpenTagName(str) {
	return(((str.match(/^<(\w+)[\s>]/i)) != null) ? RegExp.$1 : null);
}

function matchCloseTagName(str) {
	return(((str.match(/^<\/(\w+)>/i)) != null) ? RegExp.$1 : null);
}

function isSingleTag(str, tagName, htmlTAGsingle) {
	if (matchXMLsingleTagName(str) != null) {
		return true;
	}		
	if (isInArray(tagName, htmlTAGsingle) != -1) {
		return true;
	}
return false;
}

function isInArray (str, arra) {
var i;
for (i in arra) {
	if (str == arra[i]) {
		return i;
	}
}
return -1;
}

function incorrect_html(stkpop, side) {
	echo("Incorrect html! See <" + stkpop + "> on the " + side + " from cursor");
	return (0);
}
