var module_name = "KB linkify list of handles";
var module_ver = "0.1";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   Takes a list of handle.net identifiers and turns them into KB links.
   Identifiers are of the form ####/#####, e.g., 1811/48299

   Brian Stamper

*/

function KBLinkifyHandleList()
{
    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();
    thistext = thisdoc.Text();
    thistext = thistext.replace(/^\s*/gm, ""); // trim whitespace front
    thistext = thistext.replace(/\s*$/gm, ""); // trim whitespace back
    thistext = thistext.replace(/^(.*?)$/gm, "<a href=\"https://kb.osu.edu/dspace/handle/$1?show=full\">$1</a><br />"); //build KB URL

    thisdoc.Text(thistext);

}

function Init() {
    addMenuItem("KB linkify list of handles", "&HTML", "KBLinkifyHandleList");
}
