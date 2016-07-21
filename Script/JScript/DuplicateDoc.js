var module_name = "DuplDoc";
var module_ver = "0.001a";

function DuplDoc()
{	
  var thisdoc = newEditor();
  try{
		thisdoc.assignActiveEditor();
	}catch(e){
		echo("Sorry, you can not duplicate this document.");
		return;
	}
  var newdoc="";
  var dat = thisdoc.Text();
  
  var newdoc = newEditor();
  newdoc.newFile();
  newdoc.Text(dat);
  newdoc.fileName("New Document");
}

function Init(){
  //addMenuItem("Duplicate Document", "", "DuplDoc");
  addMenuItem("Duplicate Document", "", "DuplDoc", "Shift+Alt+D");
}
