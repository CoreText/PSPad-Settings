/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Code Formatter for PSPad
Filename :     style.js

Created :      10 june 2008
Created by :   Marcio (a.k.a. Marshall)
One Target - Simple Solutions
Instalation :
AStyle.exe need to be installed in a directory named "Styler".
Doc files need to be installed in a directory named "Styler\doc".
The JS (style.js) will need to be installed in a directory named "Script\JScript".

Note :
This script has been tested on all Windows Versions.
You may distribute this script freely, but please keep this header intact.

About Artistic Style :
See more information on the website of author : http : // astyle.sourceforge.net /

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
var module_name = "Code Formatter for PSPad";
var module_ver = "3.2.2";
var module_desc = "Code Formatter for PSPad"
var module_copyright = "Marcio (a.k.a. Marshall)\nOne Target - Simple Solutions";

var fs = new ActiveXObject("Scripting.FileSystemObject");
var wsh = new ActiveXObject("WScript.Shell");
var wsn = new ActiveXObject("WScript.Network");
var menu_name = "- AStyle";
var editor = newEditor();

function Init() {
   addMenuItem("- About Artistic Style", menu_name, "AStyleInfo");
   addMenuItem("- About Predefined Style Options", menu_name, "AboutPre");
   addMenuItem("  ANSI", menu_name, "Aansi"  , "");
   addMenuItem("  GNU", menu_name, "Agnu"    , "");
   addMenuItem("  kr", menu_name, "Akr"      , "");
   addMenuItem("  linux", menu_name, "Alinux", "");
   addMenuItem("  java",  menu_name, "Ajava" , "");
   addMenuItem("  your own code",  menu_name, "Apersonal", "");
   addMenuItem("- System Information", menu_name, "Info");
   addMenuItem("- Edit this script", menu_name, "editMe");
   addMenuItem("- About Code Formatter", menu_name, "About");
   return;
}

function editMe() {
   editor.openFile(moduleFileName(module_name));
}

function Info() {
   var drv = fs.GetDrive(fs.GetDriveName(fs.GetAbsolutePathName("c:")));
   var VN = "--- System Information ---\nDrive " + drv.DriveLetter + "\n";
   switch (drv.DriveType) {
      case 0 :
         t = "Unknown";
      case 1 :
         t = "Removable";
      case 2 :
         t = "Fixed";
      case 3 :
         t = "Network";
      case 4 :
         t = "CD-ROM";
      case 5 :
         t = "RAM Disk";
   }
   VN += "Volume Name: " + drv.VolumeName + "\nSerial Number: " + drv.SerialNumber +
   "\nFreeSpace: " + drv.FreeSpace / 1024 + " Kbytes" + "\nUser: " + wsn.UserName;
   echo(VN);
}

function About() {
   var VN = "--- Code Formatter Information ---\nModule: " + module_desc +
   "\nVersion: " + module_ver + "\n\nCreated by: " + module_copyright;
   echo(VN);
}

function AboutPre() {
   var VN = "ANSI: Brackets are broken, indentation is 4 spaces.\n" +
   "           Namespaces, classes, and switches are NOT indented.\n" +
   "GNU: Brackets are broken, blocks are indented, and indentation is 2 spaces.\n" +
   "          Namespaces, classes, and switches are NOT indented.\n" +
   "kr: Kernighan & Ritchie. Brackets are attached, indentation is 4 spaces.\n" +
   "     Namespaces, classes, and switches are NOT indented.\n" +
   "linux: All brackets are linux style, indentation is 8 spaces.\n" +
   "          Namespaces, classes, and switches are NOT indented.\n" +
   "java: Brackets are attached, indentation is 4 spaces.\n" +
   "         Switches are NOT indented.";
   echo(VN);
}

function MyPath() {
   var Path = modulePath();
   if (Path.length == 0) {
      echo("The path to this script file could not be retrieved");
      return "Not Found";
   }
   return Path.substr(0, Path.lastIndexOf("\\Script\\JScript\\")) + "\\";
}

function StyleCmd(tip){
   try {
      editor.assignActiveEditor();
      editor.saveFile();
      var myFile = editor.fileName();
      if (fs.FileExists(MyPath() + "\\Styler\\AStyle.exe")) {
         command  = MyPath() + "Styler\\AStyle.exe " + tip + " --options=none --suffix=none " + myFile;
         logClear();
         var oExec = wsh.Exec(command);
         var stdOut = oExec.StdOut;
         while ( ! stdOut.AtEndOfStream) {
            logAddLine(stdOut.ReadLine().replace(/[\r\n]/g, ''));
         }
         while (oExec.Status == 0) {
            sleep(1000);
         }
         editor.reloadFile();
      }
      else {
         echo ("This script needs AStyle installed in " + MyPath() + "\Styler\nDownload AStyle from http://astyle.sourceforge.net/" );
      }
   }
   catch(err) {
      txt = "There was an error on StyleCmd.\n\n";
      txt += "Error description: " + err.description + "\n\n";
      txt += "Click OK to continue.\n\n";
      echo(txt);
      return;
   }
}

function Aansi(){
   StyleCmd("--style=ansi");
}
function Agnu(){
   StyleCmd("--style=gnu");
}
function Akr(){
   StyleCmd("--style=kr");
}
function Alinux(){
   StyleCmd("--style=linux");
}
function Ajava(){
   StyleCmd("--style=java");
}
function Apersonal(){
   try {
      var command = inputText("Please enter your code", "-A2t8CSKBGNLwFpU");
      if (command != null && command != "") {
         StyleCmd(command);
      }
   }
   catch(err) {
      txt = "There was an error on Apersonal.\n\n";
      txt += "Error description: " + err.description + "\n\n";
      txt += "Click OK to continue.\n\n";
      echo(txt);
      return;
   }
}

function AStyleInfo(){
   try {
      if (fs.FileExists(MyPath() + "\\Styler\\doc\\index.html")) {
         command = MyPath() + "Styler\\doc\\index.html";
         command = command.replace(/ /g, '%20');
         command  = "%ProgramFiles%\\Internet Explorer\\iexplore.exe file:///" + command.replace(/\\/g,'/');
         var oExec = wsh.Exec(command);
         while (oExec.Status == 0) {
            sleep(1000);
         }
      }
      else {
         echo ("This script needs AStyle installed in " + MyPath() + "\Styler\nDownload AStyle from http://astyle.sourceforge.net/" );
      }
   }
   catch(err) {
      txt = "There was an error on AStyleInfo.\n\n";
      txt += "Error description: " + err.description + "\n\n";
      txt += "Click OK to continue.\n\n";
      echo(txt);
      return;
   }
}
