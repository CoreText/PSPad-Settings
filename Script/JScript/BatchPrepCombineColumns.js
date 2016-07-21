var module_name = "BatchPrepCombineColumns";
var module_ver = "0.002";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   This takes multiple columns copied from a metadata spreadsheet and merges them
   into a single column, with data separated by ||, as required by the SAFbuilder
   script. (See https://github.com/peterdietz/SAFBuilder/wiki)

   We have to account for rows where some columns are empty, and we want to remove
   excess whitespace. The algorithm is to replace all tabs with ||, then remove
   excess pipes and whitespace from that.

   Note that by 'whitespace' we use [^\r\S] because we want to retain newlines.

   Brian Stamper

*/

function BatchPrepCombineColumns()
{

    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();

    thistext = thisdoc.Text();

    thistext = thistext.replace(/^/gm, "\t"); // An extra tab at BOL catches other excess whitespace
    thistext = thistext.replace(/\t/gm, "||"); // replace tabs with ||
    thistext = thistext.replace(/[^\r\S]+\|\|/gm, "||"); // trim whitespace before any ||
    thistext = thistext.replace(/\|\|[^\r\S]+/gm, "||"); // trim whitespace after any ||
    thistext = thistext.replace(/^\|*/gm, ""); // trim excess || at BOL
    thistext = thistext.replace(/\|*$/gm, ""); // trim excess || at EOL
    thistext = thistext.replace(/\|{3,}/gm, "||"); // trim excess || in middle (more than one pair)

    thisdoc.Text(thistext);
}

function Init() {
    addMenuItem("Batch Prep Combine Columns", "", "BatchPrepCombineColumns");
}
