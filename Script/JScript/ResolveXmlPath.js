/*******************************************************************************
 * (c) 2010 - http://www.hofrichter.net - sven hofrichter - pspad@hofrichter.net
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * author ......... : Sven Hofrichter
 * date ........... : 27.08.2010
 * version ........ : 1.0
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * description .... : This script was made, to resolve the path of an element of
 *                    an xml-file/-structure. It shows up an InputText-dialog to
 *                    give the user an option, to view and to copy the path of
 *                    the selected item (or the item, where the cursor was
 *                    placed). The script returns the previous xml-tag, if the
 *                    cursor was placed outside the xml-structure.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * history:
 * 27.08.2010 - 1.0 - hofsve - initial version
 ******************************************************************************/
 
// you can change this:
var SHORT_CUT_KEYS_PLAIN = 'CTRL+SHIFT+ALT+X';
var SHORT_CUT_KEYS_NAMESPACE = 'CTRL+ALT+X';
 
//------------------------------------------------------------------------------
// DO NOT CHANGE THIS:
var module_name = "ResolveXmlPath";
var module_ver = "1.0";

function resolveXmlPathPlain() {
  ResolveXmlPath(true);
}
function resolveXmlPathNamespace() {
  ResolveXmlPath(false);
}
function ResolveXmlPath(removeNamespace) {
  var editor = newEditor();
  editor.assignActiveEditor();
  var selStart  = editor.selStart(); 
  var selLength = editor.selLength();
  editor.selStart(0);
  editor.selLength(selStart + selLength);
 
  var txtLenth = editor.Text().length;
  var textToParse = editor.selText();
  var pos = 1;
  
  textToParse = textToParse.replace(/[\n\r]+/g, ''); // remove NLBR
  textToParse = textToParse.replace(/<\!\-\-(.(?!\-\->))*?.(\-\->|$)/g, ''); // remove comments
  while (!textToParse.match(/<[^>]+>[^<]*$/g) && txtLenth > pos) {
    editor.selLength(selStart + selLength + pos);
    textToParse = editor.selText();
    textToParse = textToParse.replace(/[\n\r]+/g, ''); // remove NLBR
    textToParse = textToParse.replace(/<\!\-\-(.(?!\-\->))*?.(\-\->|$)/g, ''); // remove comments
    pos++;
  }
  
  editor.selStart(selStart);
  editor.selLength(selLength);
  
  textToParse = textToParse.replace(/<\!\-\-(.(?!\-\->))*?.(\-\->|$)/g, ''); // remove comments
  textToParse = textToParse.replace(/>[^<]+$/g, '>'); // remove NLBR
  textToParse = textToParse.replace(/<[^>]+$/g, ''); // remove NLBR
  textToParse = textToParse.replace(/>[^<]+</g, '><'); // remove tag-values: "...>value<..." 

  textToParse = textToParse.replace(/<(([^>](?!\/>))*?.)\s*\/>$/g, '<$1>'); // remove self-closed tags: <tag />
  
  textToParse = textToParse.replace(/<[^\/>]+\/>/g, ''); // remove self-closed tags: <tag />
  textToParse = textToParse.replace(/<([^>](?!\/>))*?.\/>/g, ''); // remove self-closed tags: <tag />
    
  while (textToParse.match(/<[^>]+><\/[^>]+>/g)) {
    textToParse = textToParse.replace(/<[^>\/]+><\/[^>]+>/g, ''); // remove open-close-combinations
  }
  
  var openTags = textToParse.match(/<([^>\s]+)\s*[^>]*>/g);
  if (!openTags) {
    echo ("No valid xml or cursor wasn't placed at a item!");
    return;
  }
  for (var i = 0; i < openTags.length; i++) {
    var tmpRegex = new RegExp('<' + openTags[i] + '>.*<\/' + openTags[i] + '>', 'g');
    textToParse = textToParse.replace(tmpRegex, '');
  }
  textToParse = textToParse.replace(/<([^>\s]+)(\s[^>]+)*>/g, '/$1');
  textToParse = textToParse.replace(/\/\?xml/, '');
  if (removeNamespace) {
    textToParse = textToParse.replace(/\/[^\:]+\:/g, '/');
  }
  textToParse = textToParse.replace(/\/\!\-\-/g, ''); // remove comments
  InputText("path in xml to copy:", textToParse);
}
 
function Init() {
 addMenuItem( "XML-Path (v" + module_ver + ")", "XML", "resolveXmlPathPlain", SHORT_CUT_KEYS_PLAIN);
 addMenuItem( "XML-Path with namespace (v" + module_ver + ")", "XML", "resolveXmlPathNamespace", SHORT_CUT_KEYS_NAMESPACE);
}
