/*	FILENAME:       HtmlTools.js
 *	DESCRIPTION:   PSPad WSH Extension. Generic tools to speed up writing code html.
 *	VERSION:       1.0.0 
 *	PSPAD VERSION: 2.5.5 (2386) Tested 
 *	CREATED:       19.05.2014
 *	CREATED BY:    Matteo Nigro
 *	COPYRIGHT (C), 2014 Matteo Nigro (Provided under the MIT License www.opensource.org/licenses/mit-license.php)
 *  NOTE:          The extension is still under development, early new functions will be bootable 
 * ================================================================= 
*/
var module_name="Html Tools";
var module_ver="0.2";
var module_title="Html Generic Tools";
var nan="The entered value is not a number!";
function Init() {
  addMenuItem("Table Maker","&HTML","Table","Shift+Alt+H");
  addMenuItem("List Maker" ,"&HTML","List" ,"Alt+H");
}
//TABLE MAKER
function Table(){
  var E=NewEditor();
  E.assignActiveEditor();
  var o="<table>"
  var r=inputText("Enter the number of rows:")*1;
  while(isNaN(r)){
    echo(nan);
    r=inputText("Enter the number of rows:")*1;
  }
  var c=inputText("Enter the number of columns:")*1;
  while(isNaN(c)){
    echo(nan);
    c=inputText("Enter the number of columns:")*1;
  }
  for(i=1;i<=r;i++){
    o+="\n\t<tr>";
    for(j=1;j<=c;j++){
      o+="\n\t\t<td></td>";
    }
    o+="\n\t</tr>";
  }
  if(r!=0&&c!=0){
    E.selText(o+"\n</table>");
  }
  else{
    echo("Insufficient data! The table will not be created.");
  }
}
//LIST MAKER
function List(){
  var E=NewEditor();
  E.assignActiveEditor();
  var es="u1IiAa";
  var t=inputText("Enter one of the following characters to indicate the style of the list:\n\n U = Default List\n 1 = Numbered List\n I = Capital Roman numeral\n i = Lowercase Roman numerals\n A = Uppercase letters\n a = Lowercase letters");
  var o="<ul";
  if(es.indexOf(t)!=-1){
    if(t!="U"&&t!=""){
      o+=" type="+t+">";
    }
    else{
      o+=">";
    }
  }
  else{
    echo("The entered character is not one of those listed!\nThis will set the default style.");
    o+=">";
  }
  if(E.selText()==""){
    var r=inputText("Enter the number of list elements:")*1;
    while(isNaN(r)){
      echo(nan);
      r=inputText("Enter the number of list elements:")*1;
    }
    for(i=1;i<=r;i++){
      o+="\n\t<li></li>";
    }
  }
  else{
    o+=("\n\t<li>"+E.selText().replace(/\n/g,"\t<li>").replace(/\r/g,"</li>\n")+"</li>");
  }
  E.selText(o+"\n</ul>");
}