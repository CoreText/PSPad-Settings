var module_name = "Linkify list of URLs";
var module_ver = "0.1";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   Takes a raw text list of URLs and turns them into HTML links.


   Brian Stamper

*/

function LinkifyURLsList()
{
    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();
    thistext = thisdoc.Text();

    thistext = thistext.replace(/^\s*/gm, ""); // trim whitespace front
    thistext = thistext.replace(/\s*$/gm, ""); // trim whitespace back
    thistext = thistext.replace(/[^\r\S]+/g, "%20"); // any space into single URL-encoded space
    thistext = thistext.replace(/^(.*?)$/gm, "<a href=\"$1\">$1</a><br />"); //build link

    thisdoc.Text(thistext);

}

function Init() {
    addMenuItem("Linkify list of URLs", "&HTML", "LinkifyURLsList");
}
