/*------------------------------------------------------------
/ hots_core
/
/   Copyright (C) 2008, 2009 Alesc
/   This program is free software: you can redistribute it and/or modify
/   it under the terms of the GNU General Public License.
/
/------------------------------------------------------------*/
var module_name = "hots_core";
var module_ver = "0.6";

var psp_out_file;

// activeX
var fso = new ActiveXObject("Scripting.FileSystemObject");

function setOutput(outputFilename)
{
    psp_out_file = outputFilename;
}

/*------------------------------------------------------------
/ safeOpenFile
/
/ Arguemnts: filename - (IN) file name
/
/ Returns:
/   true / false
/
/ Description:
/   Open file or just set focus. Errors are written to psp_out_file.
/------------------------------------------------------------*/
function safeOpenFile(filename)
{
    if (fso.FileExists(filename))
    {
        var editor = newEditor();
        // check if file already opened in editor 
        if (hots_core.fileOpened(filename))
            editor.assignEditorByName(filename);
        else
            editor.openFile(filename);

        editor.activate();
    }
    else
    {
        hots_core.report("Error", "File [" + filename + "] not found.");
        return false;
    }

    return true;
}
/*------------------------------------------------------------
/ fileOpened
/
/ Arguemnts: filename - (IN) file name
/
/ Returns:
/   true / false
/
/ Description:
/   Checks if file is opened in the editor. Returns true if file
/   opened.
/------------------------------------------------------------*/
function fileOpened(filename)
{
    var ed = newEditor();
    for(var i=0; i<editorsCount(); i++)
    {
        ed.assignEditorByIndex(i);
        var tmpFile = ed.fileName();

        if (tmpFile.toLowerCase() == filename.toLowerCase())
        return true;
    }
    return false;
}
/*------------------------------------------------------------
/ readFile
/
/ Arguemnts: filename - (IN) file name
/
/ Returns:
/   Entire file content
/
/ Description:
/   Reads entire file and returns his content. Error to psp_out_file.
/-------------------------------------------------------------*/
function readFile(filename)
{
    var content="";
    if (fso.FileExists(filename))
    {
        var fhandle = fso.OpenTextFile(filename, 1);
        while(fhandle.AtEndOfStream==false)
            content += fhandle.ReadLine() + "\n";

        fhandle.Close();
    }
    else
    {
        hots_core.report("Error", "File [" + filename + "] not found.");
    }
    return content;
}
/*------------------------------------------------------------
/ deleteFile
/
/ Arguemnts: filename - (IN) file name
/
/ Returns:
/   nothing
/
/ Description:
/   Delete file. No error reported.
/-------------------------------------------------------------*/
function deleteFile(filename)
{
    if (fso.FileExists(filename))
        fso.DeleteFile(filename);
}
/*------------------------------------------------------------
/ writeFileStr
/
/ Arguemnts: txt - (IN) string to write
/            filename - (OUT) file name
/
/ Returns:
/   nothing
/
/ Description:
/   Writes specified text to file.
/-------------------------------------------------------------*/
function writeFileStr(txt, filename)
{
    var fhandle = fso.CreateTextFile(filename, true);
    fhandle.WriteLine(txt);
    fhandle.Close();
}

/*------------------------------------------------------------
/ writeFile
/
/ Arguemnts: array - (IN) array to write
/            filename - (OUT) file name
/
/ Returns:
/   nothing
/
/ Description:
/   Writes specified array to file. Every array element to new line.
/-------------------------------------------------------------*/
function writeFileArr(array, filename)
{
    var fhandle = fso.CreateTextFile(filename, true);

    for(var i=0; i<array.length; i++)
        fhandle.WriteLine(array[i]);

    fhandle.Close();
}
/*------------------------------------------------------------
/ getFileName
/
/ Arguemnts: nothig
/
/ Returns:
/   filename
/
/ Description:
/   Gets full filename of current active file in editor.
/-------------------------------------------------------------*/
function getFileName()
{
    var ed = newEditor();
    ed.assignActiveEditor();

    return ed.fileName();
}
/*------------------------------------------------------------
/ printArr
/
/ Arguemnts: array - (IN) array to print
/
/ Returns:
/   nothing
/
/ Description:
/   Prints array to output. Every array elem.to new line.
/   Used mostly for debuging.
/-------------------------------------------------------------*/
function printArr(array)
{
    var bro="";
    for(var i=0; i<array.length; i++)
        bro += array[i] + "\n";

    echo(bro);
}
/*------------------------------------------------------------
/ writePspadVersion
/
/ Arguemnts: nothing
/
/ Returns:
/   nothing
/
/ Description:
/   Writes pspad version to psp_out_file.
/-------------------------------------------------------------*/
function writePspadVersion()
{
    hots_core.writeFileStr(pspadVersion(), psp_out_file);
    return;
}
/*------------------------------------------------------------
/ writeCaretPosition
/
/ Arguemnts: nothing
/
/ Returns:
/   nothing
/
/ Description:
/   Writes caret position to psp_out_file. Format is:
/   Filename=<filename>, Y=<line number>, X=<column number>
/-------------------------------------------------------------*/
function writeCaretPosition()
{
    var ed = newEditor();
    ed.assignActiveEditor();
    // get caret position
    var yPos = ed.caretY();
    var xPos = ed.caretX();

    var txt = "Filename=" + hots_core.getFileName() + ", Y=" + yPos + ", X=" + xPos;
    hots_core.writeFileStr(txt, psp_out_file);

    return;
}
/*------------------------------------------------------------
/ report
/
/ Arguemnts: level - (IN) report level (Error, Warning, Normal)
/            txt - (IN) text message.
/
/ Returns:
/   nothing
/
/ Description:
/   Writes report message to psp_out_file.
/-------------------------------------------------------------*/
function report(level, txt)
{
    var report_str =  "HOTSERR:" + level + ": " + txt + "\n";
    hots_core.writeFileStr(report_str, psp_out_file);
}

function areualive()
{
    var txt = "yes";
    hots_core.writeFileStr(txt, psp_out_file);
}
