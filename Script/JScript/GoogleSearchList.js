var module_name = "Google list of search terms";
var module_ver = "0.1";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   Takes a raw text list of search terms and turns them into HTML Google links.
   This is rather crude; all special characters are simply converted to spaces.
   The "tbs=qdr:y" part forces the results to be filtered for "in the past year",
   which I usually prefer.

   Brian Stamper
   */
function GoogleSearchList()
{
    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();
    thistext = thisdoc.Text();
    thistext = thistext.replace(/[^\r\w]/g, " "); // non-word into single space
    thistext = thistext.replace(/^\s*/gm, ""); // trim whitespace front
    thistext = thistext.replace(/\s*$/gm, ""); // trim whitespace back
    thistext = thistext.replace(/[^\r\S]+/g, "+"); // any space into +
    thistext = thistext.replace(/^(.*?)$/gm, "<a href=\"https://www.google.com/search?q=$1&tbs=qdr:y\">$1</a><br />"); //build Google URL, results in past year only

    thisdoc.Text(thistext);

}

function Init() {
    addMenuItem("Google list of search terms", "&HTML", "GoogleSearchList");
}


