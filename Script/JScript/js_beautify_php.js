/*****************************************************************************
 * The contents of this file are subject to the RECIPROCAL PUBLIC LICENSE
 * Version 1.1 ("License"); You may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/rpl.php. Software distributed under the
 * License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
 * either express or implied.
 *
 * @author:  Mr. Milk (aka Marcelo Leite)
 * @email:   mrmilk@anysoft.com.br
 * @version: 1.0
 * @date:    2007-11-22
 *
 *****************************************************************************/
function js_Format() {

    php_path = "C:\\Program Files\\php\\php.exe";
    stylist_path = "C:\\Program Files\\php\\js_beautify.php";
    params = "";

    var ed = newEditor();
    ed.assignActiveEditor();
    var cx = ed.caretX();
    var cy = ed.caretY();
    var fni = ed.fileName();
    var fno = fni + ".cb.js";
    if (!fni.match(/\.js$/)) {
        echo("NOT A JS FILE!");
        return;
    }
    fni = fni + ".tmp.js";
    edt = newEditor();
    edt.newFile(fni);
    if (ed.selText() == '') {
        edt.text(ed.Text());
    }
    else {
        edt.text(ed.selText());
    }
    edt.saveFile();
    var sh = new ActiveXObject("WScript.shell");
    var fs = new ActiveXObject("Scripting.FileSystemObject");
    sh.run('cmd /c ""' + php_path + '" -f "' + stylist_path + '" "' + fni + '" ' + params + ' > "' + fno + '""', 0, true);
    edt.openFile(fno);
    var txt = edt.Text();
    edt.closeFile();
    fs.DeleteFile(fno);
    fs.DeleteFile(fni);
    if (ed.selText() == '') {
        ed.Text(txt);
    }
    else {
        txt = txt.substr(7, txt.length - 10);
        ed.selText(txt);
    }
    ed.caretX(cx);
    ed.caretY(cy);

}

var module_name = 'js_beautify_php';
var module_ver = '0.1';

function Init() {
    menuName = "&Format Code";
    addMenuItem("&JS Beautify from Einars(php)", menuName, "js_Format");
}
