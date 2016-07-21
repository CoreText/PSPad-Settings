/*------------------------------------------------------------
/ hots_ctag
/
/   Copyright (C) 2008, 2009 Alesc
/   This program is free software: you can redistribute it and/or modify
/   it under the terms of the GNU General Public License.
/
/------------------------------------------------------------*/
var module_name = "hots_ctag";
var module_ver = "0.6";

var psp_out_file;

function setOutput(outputFilename)
{
    psp_out_file = outputFilename;
}
/*------------------------------------------------------------
/ moveto
/
/ Arguemnts:
/   input_file
/
/ Returns:
/   nothing
/
/ Description:
/   Reads filename and line number from input_file and moves to these
/   coordinates.
/-------------------------------------------------------------*/
function moveto(input_file)
{
    // read file created from ctags by autohotkey
    var target = hots_core.readFile(input_file);
    if (!target)
        return;

    // parse lines
    var lines = new Array();
    lines = target.split(/\n/);

    // delete < and extract filename & line number
    var mapData = new Array();
    var regex = new RegExp("<");
    for(var i=0; i<lines.length; i++)
    {
        if (regex.exec(lines[i]) != null)
        {
            var cleanLine = new Array();
            cleanLine = lines[i].split(/</);
            mapData = cleanLine[0].split(/\s+/);
            break;
        }
    }

    // safe open filename
    if (!hots_core.safeOpenFile(mapData[0]))
        return;

    var ed = newEditor();
    ed.assignActiveEditor();
    // move to line
    ed.setCaretPos(0, mapData[1]);

    hots_core.report("Normal", "Move to compelted.");
    return;
}
/*------------------------------------------------------------
/ hotword
/
/ Arguemnts:
/   none
/
/ Returns:
/   wordFile
/
/ Description:
/   Gets a word from current caret position backwards and
/   writes it to psp_out_file.
/-------------------------------------------------------------*/
function hotword()
{
    var ed = newEditor();
    ed.assignActiveEditor();

    // get carret pos and line
    var xPos = ed.caretX();
    var startPos = 0;
    var line = ed.lineText();

    // split curr.line by characters
    var arr = new Array();
    arr = line.split("");

    // word characters
    var regex = new RegExp("\\w{1}", "i");

    // find begining of the word
    for(var i=xPos-2; i>=0; i--)
    {
        if (regex.exec(arr[i]) == null)
        {
            startPos = i+1;
            break;
        }
    }

    // construct the word
    var word = "";
    for(var i=startPos; i<xPos-1; i++)
        word = word + arr[i];

    // write word to output
    hots_core.writeFileStr(word, psp_out_file);

    return;
}
