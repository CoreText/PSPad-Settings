/*******************************************************************************
 Comments v1.0 - 08/24/2006
 maleval@gawab.com
 Update (11/28/2007) : added hash comments #
 ------------------------------------------------------------------------------
Add HTML Comments, Add Multi Lines Comments, Add Single Line Comments :
  Insert HTML comments, multilines comments or single line comments
  around a selection. If there is no selection, it is inserted
  at the insertion point. For single line comments, a double slash is added
  at the beginning of each line.

Remove Comments Tags:
  Search for comments tags in a selection. If there is no selection,
  search in the active line. This feature uncomment the lines,
  it does not remove the comment itself.

Remove All Comments Lines :
  Big Clean up.Remove everything found in comments, except HTML comments.
  Warning : it can be dangerous, depending on what you have in your file.
  Be sure to create a backup first.

Tested with PSPad 4.5.1 (2207) - Win XP SP2
*******************************************************************************/

var module_name = "InsertComments_eng";
var module_ver = "1.0";

function insertHTMLComments(){
  var ceDoc = newEditor();
  ceDoc.assignActiveEditor();
  var s = ceDoc.selText();
  s = "<!--"+s+"-->";
  ceDoc.selText(s);
}

function insertMultiLinesComments(){
  var ceDoc = newEditor();
  ceDoc.assignActiveEditor();
  var s = ceDoc.selText();
  s = "/*"+s+"*/";
  ceDoc.selText(s);
}

function insertSingleLineComments(){
  var ceDoc = newEditor();
  ceDoc.assignActiveEditor();
  var l, i, s;
  s = ceDoc.selText();
  var sArr = s.split("\n");
  for (i in sArr) {
    l = "//"+sArr[i];
    ceDoc.selText(l);
  }
}

function insertBashComments(){
  var ceDoc = newEditor();
  ceDoc.assignActiveEditor();
  var l, i, s;
  s = ceDoc.selText();
  var sArr = s.split("\n");
  for (i in sArr) {
    l = "#"+sArr[i];
    ceDoc.selText(l);
  }
}

function removeCommentsTags(){
  var r, s, flag = false;;
  var ceDoc = newEditor();
  ceDoc.assignActiveEditor();
  s = ceDoc.selText();

  if (!s) {
    flag = true;
    s = ceDoc.lineText();
  }

  r = /<!--|-->|#|\/\*|\*\/|\/\//g;
  var res = s.search(r);

  if (res != -1) {
    s = s.replace(r, "");
    if (!flag) {
      ceDoc.selText(s);
    }
    else {
      ceDoc.lineText(s);
    }
  }
}

function removeAllComments(){
  var warning = "This will remove ALL comments lines in the document.\n "+
                "Are you sure you want to do this ?";

  if (confirm(warning)) {
    var r, s, x, y;
    var ceDoc = newEditor();
    ceDoc.assignActiveEditor();

    x = ceDoc.caretX();
    y = ceDoc.caretY();
    s = ceDoc.text();

    // Nettoyer commentaires ligne simple
    // Convertir avant les URL en http:/
    r = new RegExp("([a-z]+)://", "g");
    s = s.replace(r, "$1:/");

    // Commentaires ligne simple
    r = /\/\/.*/g;
    s = s.replace(r,"");

    // Conversion inverse pour les URL
    r = new RegExp("([a-z]+):/", "g");
    s = s.replace(r, "$1://");

    // Commentaires multilignes
    r = /\/\*[^\*\/]*\*\//g;
    s = s.replace(r,"");

    ceDoc.text(s);
    ceDoc.setCaretPos(x,y);
  }
}

function Init(){
  addMenuItem("Insert HTML Comments <!-- --> ", "Comments", "insertHTMLComments", "");
  addMenuItem("Insert Multi Lines Comments /* */", "Comments", "insertMultiLinesComments", "Shift+Ctrl+;");
  addMenuItem("Insert Single Line Comments //", "Comments", "insertSingleLineComments", "");
  addMenuItem("Insert Single Line Comments #", "Comments", "insertBashComments");
  addMenuItem("-", "Comments", "");
  addMenuItem("Remove Comments Tags", "Comments", "removeCommentsTags", "Shift+Alt+;");
  addMenuItem("Remove All Comments Lines", "Comments", "removeAllComments");
}

function confirm(text) {
  // Provided by gogogadgetscott
  // http://forum.pspad.com/read.php?2,30707
  text = text ? text : "Are you sure ?";
  var ie = CreateObject("InternetExplorer.Application");
  ie.width = 0; ie.height = 0; ie.left = 10000000; ie.visible = true;

  ie.navigate("about:blank");

  var returnValue = ie.Document.parentWindow.confirm(text);
  ie.quit();
  return returnValue;
}
