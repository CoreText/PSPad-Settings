var module_name = "FixQuotesDashes";
var module_ver = "0.002";
/*
   (This is a script for the PSPad editor, see http://www.pspad.com/. I have no
   affiliation with the developers of PSPad. These scripts are offered as-is,
   use at your own risk.)


   Converts "smart" quotes and long dashes to plain-ASCII quotes and hyphens.

   Brian Stamper

*/

function FixQuotesDashes()
{
    var thisdoc = newEditor();
    thisdoc.assignActiveEditor();
    var newdoc = "";
    var dat = thisdoc.Text();

    var squoteleft = String.fromCharCode(8216);
    var squoteright= String.fromCharCode(8217);
    var quoteleft  = String.fromCharCode(8220);
    var quoteright = String.fromCharCode(8221);
    var baddashlo  = String.fromCharCode(8208);
    var baddashhi  = String.fromCharCode(8213);
    var badspacelo = String.fromCharCode(8192);
    var badspacehi = String.fromCharCode(8202);

    var changecount = 0;

    for (var i=0; i<dat.length; i++)
    {
        var thechr = dat.substr(i,1);
        if (thechr == quoteleft || thechr == quoteright)
        {
            changecount++;
            thechr = "\"";
        }
        if (thechr == squoteleft || thechr == squoteright)
        {
            changecount++;
            thechr = "'";
        }
        if (baddashlo <= thechr && thechr <= baddashhi )
        {
            changecount++;
            thechr = "-";
        }
        if (badspacelo <= thechr && thechr <= badspacehi )
        {
            changecount++;
            thechr = " ";
        }
        if (thechr)
        {
            newdoc += thechr;
        }
    }
    thisdoc.Text(newdoc);
    echo(changecount + " quotes, dashes and spaces have been corrected.");
}

function Init() {
    addMenuItem("Fix Quotes and Dashes", "Utilities", "FixQuotesDashes");
}
