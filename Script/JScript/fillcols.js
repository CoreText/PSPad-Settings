/*
Fillcols
A Javascript for PSPad

Version 0.1
By John Hendrickx <John2.Hendrickx@gmail.com>

Fillcols replaces a rectangular selection of text with either fill characters 
or number sequences. The user is prompted to enter the fill text. In overwrite 
mode (fillcols_ovr, Ctrl+Shift+F) the selection is replaced, in insert mode 
(fillcols_ins, Ctrl+Alt+F)) the fill text is inserted before the selection. An 
error message is given if there is no rectangular selection of text.

The syntax <x>++[<y>] can be used to create number sequences. For example,
entering "1++" in the fill characters will insert 1, 2 etc. Entering "10++-1" 
will insert 10, 9, 8, etc.

In overwrite mode, a text insert is repeated if it is shorter than the 
selection width. For example, if 5 columns have been selected and "ab" is 
entered, then the fill text will be "ababa". A number sequence will be padded 
to the selection width but will be truncated if too long. For example, if 2 
columns have been selected and "1++50" is entered, the fill text will be " 1", 
"51", "01" (the value of "101" is truncated).

In insert mode, the fill text is insterted before the selection. Numeric 
sequences have the width of the largest number, smaller numbers are padded 
with zeros. For example, if "1++50" is entered in insert mode, the fill text 
will be "  1", " 51", "101".
*/ 

function Init(){
	addMenuItem("Fill Columns, overwrite", "Fill Columns", "fillcols_ovr");
	addMenuItem("Fill Columns, insert", "Fill Columns", "fillcols_ins"   ,"Shift+Alt+C" );
}

function fillcols_ovr() {
	fillcols(1);
}

function fillcols_ins() {
	fillcols(0);
}

function fillcols(overwrite) {
	var editor = NewEditor();
	editor.assignActiveEditor(); 
	var x1=editor.blockBeginX();
	var y1=editor.blockBeginY();
	var x2=editor.blockEndX();
	var y2=editor.blockEndY();
	logClear();
	// Exit if a block selection has not been used
	if (x1==x2) {
		echo("For use only in block selection mode");
		return;
	}
	var filler = inputText("Fill Characters","Enter fill character(s) or <x>++[<y>]");
	if (filler=="") return;
	
	// If a number followed by "++" is specified, optionally followed by a 
	// second number, then add the second number (or 1 if not specified)
	// to each line
	var re=/^(-?\d+)\+\+(-?\d*)$/;
	var numfill, startnum, incr;
	if (re.test(filler)) {
		numfill=1;
		startnum=filler.replace(re,"$1");
		incr=filler.replace(re,"$2");
		if (incr=="") incr=1;
	}
	
	var fill_lngth;
	if (overwrite) fill_lngth=x2-x1;
	else {
		if (numfill) fill_lngth=maxnumlngth(parseInt(startnum),parseInt(incr),y2-y1);
		else fill_lngth=filler.length;
	}
	
	if (numfill) currnum=parseInt(startnum);
	else fillval=repeatstr(filler,fill_lngth);
	for (i = y1; i <= y2; i++) {
		if (overwrite) {
			editor.setBlockBegin(x1, i);
			editor.setBlockEnd(x2, i);
		}
		else editor.setCaretPos(x1,i);
		
		if (numfill) {
			fillval=padnum(currnum,fill_lngth);
			currnum=parseInt(currnum)+parseInt(incr);
		}
		editor.selText(fillval);
	}
	editor.setBlockBegin(x1, y1);
	editor.setBlockEnd(x2, y2);
}

function maxnumlngth(n1,plusval,ntimes) {
	var lastnum=n1+ntimes*plusval;
	var maxlngth1=lastnum.toString().length;
	var maxlngth2=n1.toString().length;
	var maxlngth=Math.max(maxlngth1,maxlngth2);
	return(maxlngth);
}

function padnum(num,lngth) {
	var padchar=" ";
	var rslt=num.toString();
	while (rslt.length < lngth) {
		rslt=padchar+rslt;
	}
	var rslt2=rslt.substr(rslt.length-lngth);
	return(rslt2);
}

function repeatstr(string,lngth) {
	var resultstr=string;
	while (resultstr.length < lngth) {
		resultstr=resultstr+string;
	}
	resultstr2=resultstr.substr(0,lngth);
	return(resultstr2);
}