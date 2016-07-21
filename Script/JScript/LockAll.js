var module_name = "LockAll";
var module_ver = "1.0";

function Init(){
	addMenuItem("&Lock All", "", "LockAll", "Ctrl+Alt+\\");
}

function LockAll(){
	var build_number = getBuildNumber();
	if(!build_number || build_number >= 2231){
		var total_readonly = 0;
		var total_tabs = editorsCount();
		
		var the_editors = [];
		for(var i=0; i<total_tabs; i++){
			the_editors[i] = newEditor();
			the_editors[i].assignEditorByIndex(i);
			
			if(the_editors[i].readOnly()){
				total_readonly++;
			}
		}
		
		if(total_readonly / total_tabs >= 0.5){
			for(var i=0; i<the_editors.length; i++){
				the_editors[i].readOnly(false);
			}
		}else{
			for(var i=0; i<the_editors.length; i++){
				the_editors[i].readOnly(true);
			}
		}		
	}else{
		for(var i=0; i<editorsCount(); i++){
			var wsh = new ActiveXObject("WScript.Shell");
			wsh.sendKeys("^{TAB}");
			wsh.sendKeys("%fd");
		}
	}
}

function getBuildNumber(){
	var theversion = pspadVersion();
	var left_parenth = theversion.indexOf("(");
	var right_parenth = theversion.indexOf(")");
	var buildnum = parseInt(theversion.substring(left_parenth+1, right_parenth),10);
	
	if(isNaN(buildnum)){
		return 0;
	}else{
		return buildnum;
	}
}
