' it will print all open files to printer
const module_name  = "ListTransform"
const module_ver   = "1.1"          

sub ListString
	dim item, s
  set obj = NewEditor()
  obj.assignActiveEditor()
  s = ""
  for each item in obj
	if Trim(Item) <> "" then
        s = s & "'" & Trim(item) & "', "
    end if    
  next
  s = "(" & ( Left(s, len(s)-2 ) ) & ")"
  obj.command("ecSelectAll")
  obj.selText(s)
  setClipboardText(s)
end sub

sub ListItems
	dim item, s
  set obj = NewEditor()
  obj.assignActiveEditor()
  s = ""
  for each item in obj
	if Trim(Item) <> "" then
        s = s & Trim(item) & ", "
    end if    
  next
  s = "(" & Left(s, len(s)-2) & ")"
'   obj.command("ecSelectAll")
  obj.selText(s)
  setClipboardText(s)
end sub


sub ArrListString
	dim item, s
  set obj = NewEditor()
  obj.assignActiveEditor()
  s = ""
  for each item in obj
	if Trim(Item) <> "" then
        s = s & "'" & Trim(item) & "', "
    end if
  next
  s = "[" & Left(s, len(s)-2) & "]"
'   obj.command("ecSelectAll")
  obj.selText(s)
  setClipboardText(s)
end sub

sub JsonListString
	dim item, s
  set obj = NewEditor()
  obj.assignActiveEditor()
  s = ""
  for each item in obj
	if Trim(Item) <> "" then
        s = s & """" & Trim(item) & """, "
    end if
  next
  s = "{" & Left(s, len(s)-2) & "}"
  
'   obj.command("ecSelectAll")
  obj.selText(s)
  setClipboardText(s)
end sub


sub TransformSQLLine
  dim s
  set obj = NewEditor()
  obj.assignActiveEditor()
  obj.command("ecSelectAll")
  s = obj.selText()
  s = Replace(s, "              ", Chr(13) & Chr(10))
  obj.selText(s)
end sub  
    

' name "Init" is required, its called automatically during initialization to create menu items
sub Init
  addMenuItem "&1. List of strings","List conversion", "ListString"  , ""
  addMenuItem "&2. List of items"  ,"List conversion", "ListItems"   , ""
  addMenuItem "&3. List of items"  ,"List conversion", "ArrListString", ""
  addMenuItem "&4. List of items"  ,"List conversion", "JsonListString", ""
  'addMenuItem "&3. Transform MS SQL line","List conversion", "TransformSQLLine", "Shift+Ctrl+L"
end sub
