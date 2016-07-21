var module_name = "KB title searches";
var module_ver = "0.1";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   Takes a list of titles and turns them into search links for the KB.

   Brian Stamper

*/

function KBTitleSearches()
{
    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();
    thistext = thisdoc.Text();
    thistext = thistext.replace(/[^\r\w]/g, " "); // non-word into single space
    thistext = thistext.replace(/^\s*/gm, ""); // trim whitespace front
    thistext = thistext.replace(/\s*$/gm, ""); // trim whitespace back
    thistext = thistext.replace(/[^\r\S]+/g, "%20"); // any space into single URL-encoded space
    thistext = thistext.replace(/^(.*?)$/gm, "<a href=\"https://kb.osu.edu/dspace/advanced-search?scope=/&rpp=40&field1=title&query1=$1\">$1</a><br />"); //prefix query URL

    thisdoc.Text(thistext);

}

function Init() {
    addMenuItem("KB title searches", "&HTML", "KBTitleSearches");
}
