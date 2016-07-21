/*

miketodo.js extension for PSPad
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/
var module_name = "MikesTodos";
var module_ver = "1.0";

///////////////// Configuration ///////////////////////////

var config = {
  // will quit if this isn't found at top of file
  magicHeader: "#!todofile!#",
  // this plus a section label starts a section area (and ends prev section)
  // plain string instead of RegExp b/c it's concatenated with stuff
  labelPrefixRegex: "^#+ *",
  labelSuffixRegex: " *$",
  // when this is encountered, ends a section and starts freeform area
  endSectionRegex: new RegExp("^#+/$"),
  // directory locations
  todoLogExt: ".log.txt",
  backupExt: ".bak.txt",
  newline: "\r\n",
  makeBackup: true,
  doLogging: true,
  modifyText: true,
  sections: {
    // SECTIONS: each section object is a todo list section.
    //   label is the text identifying each section in the file
    //   logCompleted is true if move completed items to logfile
    //   xxxRotate if not null, label of section to move items to
    // items yet to be prioritized
    inbox: {
      label: "in queue",
      logCompleted: false,
      dailyRotate: null,
      weeklyRotate: null
    },
    // rotated items
    today: {
      label: "today",
      logCompleted: true,
      dailyRotate: null,
      weeklyRotate: null
    },
    tomorrow: {
      label: "tomorrow",
      logCompleted: true,
      dailyRotate: "today",
      weeklyRotate: null
    },
    thisWeek: {
      label: "this week",
      logCompleted: true,
      dailyRotate: null,
      weeklyRotate: null
    },
    nextWeek: {
      label: "next week",
      logCompleted: true,
      dailyRotate: null,
      weeklyRotate: "this week"
    },
    // not auto-rotated
    eventually: {
      label: "eventually",
      logCompleted: true,
      dailyRotate: null,
      weeklyRotate: null
    },
    // transient todos that aren't logged or rotated
    topub: {
      label: "to publish",
      logCompleted: false,
      dailyRotate: null,
      weeklyRotate: null
    }
    // freeform section is not touched by scripts
    //freeformLbl: "freeform section"
  } // end of sections sub-obj
};

function copyFile(src, dest)
{
  // http://msdn.microsoft.com/en-us/library/z9ty6h50%28VS.85%29.aspx
  var fso = new ActiveXObject("Scripting.FileSystemObject");
  fso.CopyFile(src, dest);
}

// trim extension from filename
function trimExt(filename)
{
  var dotIdx = filename.lastIndexOf(".");
  return filename.substr(0, dotIdx > 0 ? dotIdx : filename.length);
}

// for trimming elements of a given value from end of array
// returns target length of new array
function rTrimIndex(ary, value) {
  for ( var i = ary.length - 1; i >= 0; --i )
    if ( ary[i] != value ) return i + 1;
  return 0;
}

function makeBackup(ed)
{
  try {
    var origFile = ed.fileName();
    var bakFile = trimExt(origFile) + config.backupExt;
    copyFile(origFile, bakFile);
    //echo("copyFile(" + origFile + ", " + bakFile + ");");
  } catch(e) {
    echo(".fileName failed");
  }
}

function getAndVerifyAndBackupCurrentFile() 
{
	var ed = newEditor();
	ed.assignActiveEditor();
	
	// now verify it's the right file type
	var origText = ed.text();
	if ( 0 != origText.indexOf(config.magicHeader) )
	  throw "File is not a TODO file.";
	
	// all ok, do backup etc.
	if ( config.makeBackup )
  	makeBackup(ed);
	
	return ed;
}

// enum
var TodoType = {
  notStarted: "not_started",
  inProgress: "in_progress",
  complete: "complete",
  remark: "remark"
};

var TTRgx = {
  notStarted: /^ *-/,
  inProgress: /^ *>/,
  complete:   /^ *[+x]/
};

function checkTodoType(line) {
  if ( TTRgx.notStarted.test(line) )
    return TodoType.notStarted;
  if ( TTRgx.inProgress.test(line) )
    return TodoType.inProgress;
  if ( TTRgx.complete.test(line) )
    return TodoType.complete;
  return TodoType.remark;
};


//////////////////////////////// Todo class ////////////////////////////

function Todo(ed)
{
  if ( !ed ) throw "Failed to init.";
  // editor object for current file
  this.ed = ed;
  // original unmodified text
  this.origText = ed.text();
  this.origLines = this.origText.split(config.newline);
  // this.sections[labelName] gets info for section with given label.
  //  see newSection in the findSections method for details
  this.sections = new Array();
  // array of lines to append to the rotate log 
  this.logItems = new Array();
  this.findSections();
}

Todo.prototype.findSections = function()
{
  var ln = 0;
  // start with freeform section
  function newSection(cfg, line) {
    var cfg = {
      cfg: cfg, // section config
      startLine: line,
      endLine: null, // exclusive
      newLines: new Array(), // array of final lines to keep
      addedLines: new Array() // array of lines added from rotate
    };
    return cfg;
  }
  var currSection = newSection(null, 0);
  var numsec = 0;
  for ( ln = 0; ln < this.origLines.length; ++ln ) {
    var thisLine = this.origLines[ln];
    var endSection = false; // set to true if applicable
    var startSection = null; // set to section config obj if applicable
    if ( config.endSectionRegex.test(thisLine) ) {
      endSection = true;
    } else {
      // check whether it's the start of any section
      for ( var cs in config.sections ) {
        var secCfg = config.sections[cs];
        // regexes not working, so just a straight string match for now
        if ( thisLine == "#" + secCfg.label ) {
          endSection = true;
          startSection = secCfg;
          break;
        }
        /*var rgx = new RegExp(config.labelPrefixRegex
                             + secCfg.label
                             + config.labelSuffixRegex);
        if ( rgx.test[thisLine] ) {
          startSection = secCfg;
          break;
        }*/
      }
    }
    
    if ( endSection ) {
      //echo("endSection = true for: " + thisLine);
      currSection.endLine = ln;
      var idx = currSection.cfg ? currSection.cfg.label : numsec;
      //echo(idx);
      this.sections[idx] = currSection;
      ++numsec;
      currSection = newSection(startSection, ln);
    }
  } // end for each line
  
  if ( this.origLines.length-1 > currSection.startLine ) {
    currSection.endLine = this.origLines.length;
    var idx = currSection.cfg ? currSection.cfg.label : numsec;
    //echo("last is " + idx);
    this.sections[idx] = currSection;
    ++numsec;
  }
  
  // for debugging only
  /*for ( var ss in this.sections ) {
    var sec = this.sections[ss];
    var lbl = sec.cfg ? sec.cfg.label : "*"; 
    var desc = lbl + "/" + sec.startLine + "/" + sec.endLine;
    echo(desc);
  }*/
} // end findSections method

Todo.prototype.rotate = function(isWeekly)
{
  for ( var ss in this.sections ) {
    var sec = this.sections[ss];
    // clear out completed to-publish
    // move completed items to log
    // rotate through sections
    
    // if no cfg, it's a freeform section, so don't monkey with it
    if ( !sec.cfg ) {
      //echo("no cfg for line starting at " + this.origLines[sec.startLine]);
      sec.newLines = this.origLines.slice(sec.startLine, sec.endLine);
      //echo("freeform sec: newlines#" + sec.newLines.length);
      continue;
    }
    
    for ( var ln = sec.startLine; ln < sec.endLine; ++ln ) {
      var thisLine = this.origLines[ln];
      var action = "keep";
      var lineType = checkTodoType(thisLine);
      switch ( lineType ) {
        case TodoType.notStarted:
          if ( sec.cfg.dailyRotate ) action = sec.cfg.dailyRotate;
          else if ( sec.cfg.weeklyRotate && isWeekly )
            action = sec.cfg.weeklyRotate;
          break;
        case TodoType.inProgress:
          if ( sec.cfg.dailyRotate ) action = sec.cfg.dailyRotate;
          else if ( sec.cfg.weeklyRotate && isWeekly )
            action = sec.cfg.weeklyRotate;
          break;
        case TodoType.complete:
          if ( sec.cfg.logCompleted ) action = "log";
          else action = "delete";
          break;
        default:
          action = "keep";
          break;
      }
      //echo("A" + action + " T" + lineType + ": " + thisLine);
      switch ( action ) {
        case "keep":
          sec.newLines.push(thisLine);
          break;
        case "log":
          this.logItems.push(thisLine);
          break;
        case "delete":
          // just don't put in newLines
          break;
        default:
          // action == rotate target
          this.sections[action].addedLines.push(thisLine);
      }
    } // end for each line
  } // end for each section
} // end rotate method

Todo.prototype.dailyRotate = function()
{
  this.rotate(false);
}

Todo.prototype.weeklyRotate = function()
{
  this.rotate(true);
}

Todo.prototype.logFilePath = function()
{
  return trimExt(this.ed.fileName()) + config.todoLogExt;
}

Todo.prototype.render = function()
{
  if ( config.doLogging && this.logItems.length > 0 ) {
    var logFilename = this.logFilePath();
    var logText = this.logItems.join(config.newline)
      + config.newline + config.newline;
    
    // http://msdn.microsoft.com/en-us/library/314cz14s%28VS.85%29.aspx
    var fso = new ActiveXObject("Scripting.FileSystemObject");
    
    // Get date todo file was modified, use that as when the log items  
    // were "completed".
    var statF = fso.GetFile(this.ed.fileName());
    var logDate = new Date(statF.DateLastModified);
    statF = null;
    
    var ForAppending = 8;
    var logF = fso.OpenTextFile(logFilename, ForAppending, true);
    // instead of logging current date, log last mod date of the file 
    logF.WriteLine(logDate.toDateString());
    logF.Write(logText);
    logF.Close();
    logF = null;
    fso = null;
  }
  
  if ( config.modifyText ) {
    var newText = "";
    for ( var ss in this.sections ) {
      var sec = this.sections[ss];
      // remove trailing empty lines
      var lastIdx = rTrimIndex(sec.newLines, "");
      var lastIdx2 = rTrimIndex(sec.addedLines, "");
      if ( lastIdx < 0 ) lastIdx = sec.newLines.length;
      if ( lastIdx2 < 0 ) lastIdx2 = sec.addedLines.length;
      //echo ("lastIdx=" + lastIdx + " lastIdx2 = " + lastIdx2);
      if ( lastIdx > 0 ) {
        if ( newText.length > 0 ) newText += config.newline;
        newText += sec.newLines.slice(0, lastIdx).join(config.newline);
      }
      if ( lastIdx2 > 0 ) {
        if ( newText.length > 0 ) newText += config.newline;
        newText += sec.addedLines.slice(0, lastIdx2).join(config.newline);
      }
      newText += config.newline;
      //echo("new text for sec " + ss + " is:\n" + newText);
    }
    //echo("newText is \n" + newText);
    this.ed.text(newText);
  }
}

/////////////////////////// top-level commands //////////////////////////////

function dailyRotate()
{
  try {
    var t = new Todo(getAndVerifyAndBackupCurrentFile());
    t.dailyRotate();
    t.render();
  } catch(e) {
    echo("Error in Daily Rotate: " + e);
  }
}

function weeklyRotate()
{
  try {
    var t = new Todo(getAndVerifyAndBackupCurrentFile());
    t.weeklyRotate();
    t.render();
  } catch(e) {
    echo("Error in Weekly Rotate: " + e);
  }
}

function viewLog()
{
  try {
    var t = new Todo(getAndVerifyAndBackupCurrentFile());
    var obj1 = newEditor();
    obj1.openFile(t.logFilePath());
  } catch(e) {
    echo("Error in View Log: " + e);
  }
}

function openScript() {
  var obj1 = newEditor();
  obj1.openFile(moduleFileName(module_name));
}

function Init(){
  var menuName = "Todo";
  // Here is an example of setting up a keyboard shortcut:
  //addMenuItem("Daily Rotate",  menuName, "dailyRotate", "Ctrl+Shift+R");
  addMenuItem("Daily Rotate",  menuName, "dailyRotate");
  addMenuItem("Weekly Rotate", menuName, "weeklyRotate");
  addMenuItem("View Log",      menuName, "viewLog");
  addMenuItem("View Script",   menuName, "openScript");
}
