Option Explicit
Const module_name  = "dir2html"
Dim myfsObject, editor, actFile, folder, folderName, file, outputText

Sub Init
  addMenuItem "dir2html", "&HTML", "Main"
End Sub

Sub Main
  Set myfsObject=CreateObject("Scripting.FileSystemObject") 
  Set editor = newEditor()
  editor.assignActiveEditor
  Set actFile   = myfsObject.GetFile(editor.FileName)
  folderName = InputBox("Please enter folder name:","Folder", actFile.ParentFolder)
  If foldername = "" Then Exit Sub
  Set folder = myfsObject.GetFolder(folderName)
  outputText = "<ul>"
  For Each file In folder.Files
    outputText = outputText & vbCrLf & "<li><a href=""" & Escape(file.Name) & """>" & file.Name &"</a></li>"
  Next
  editor.SelText(outputText & vbCrLf & "</ul>")
End Sub
