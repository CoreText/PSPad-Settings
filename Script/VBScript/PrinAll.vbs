' it will print all open files to printer
const module_name  = "PrintAll"         'this name must be unique !!!
const module_ver   = "0.001a"            'version

sub PrintAll
  set obj = NewEditor()
  for i = 0 to editorsCount - 1
      obj.assignEditorByIndex(i)
      if i = 0 then     'for first file we call printer settings dialog
         obj.printFile(True)
      else              'all other files will be printed to selected printer
         obj.printFile(False)
      end if
  next  
end sub

sub ConvertAll
  set obj = NewEditor()
  for i = 0 to editorsCount - 1
      obj.assignEditorByIndex(i)
      obj.activate()
      sleep(100)
      if i = 0 then     'for first file we call printer settings dialog
         runPSPadAction("aUserConvertors")
      else              'all other files will be printed to selected printer
         runPSPadAction("aLastUserConvertor")
      end if
  next  
end sub

sub NamesToClipbrd
  set obj = NewEditor()
  s = ""
  for i = 0 to editorsCount - 1
      obj.assignEditorByIndex(i)
      s = s & obj.fileName & vbNewLine
  next  
  setClipboardText(s)
end sub

' name "Init" is required, its called automatically during initialization to create menu items
sub Init
  addMenuItem "&Print all files","All open files", "PrintAll", ""
  addMenuItem "&User convert all files","All open files", "ConvertAll"
  addMenuItem "&List of open files to clipboard","All open files", "NamesToClipbrd", "Shift+Ctrl+Alt+Tab"
end sub
