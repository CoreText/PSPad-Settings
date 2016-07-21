/*******************************************************************************
    Filename        : dirfiles.js
    Description     : List all files from directory recursively

    Created         : 02 December 2011
    Created by      : Afanasenkov Andrey
*******************************************************************************/

module_name = "DirFiles";
module_ver = "0.1";


function Init() {
  addMenuItem ("Dir Files", "Utilities", "DirFiles", "Shift+Ctrl+Alt+`" );
}


function DirFiles() {
  var editor = newEditor();
  editor.assignActiveEditor();

  var path = inputText("Please enter folder path:", "");
  if (path == "")
    return;

  var fso = new ActiveXObject("Scripting.FileSystemObject");

  var folder = fso.GetFolder(path);
  DirWithSubFolders(folder, editor);
}


function DirWithSubFolders(folder, editor) {
  EnumerateFiles(folder, editor);
  var moreFolders = new Enumerator(folder.SubFolders);
  for (; !moreFolders.atEnd(); moreFolders.moveNext()) {
    var oneFolder = moreFolders.item();
    DirWithSubFolders(oneFolder, editor);
  }
}


function EnumerateFiles(folder, editor) {
    var moreFiles = new Enumerator(folder.Files);
    for (; !moreFiles.atEnd(); moreFiles.moveNext()) {
        var oneFile = moreFiles.item();
        editor.appendText(oneFile.Path + "\n");
    }
}
