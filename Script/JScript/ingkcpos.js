/* @editortab( real char 09 = 3 spaces )
	°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•
	ingkcpos
	

	Provided under the MIT License
	Copyright (c) July 2007-2013 Damion Hankejh, d@ingk.com, http://ingk.com/d

	PSPad scripting guide: http://gogogadgetscott.info/pspad/functions.htm

	---

	FILE:			ingkcpos.js
	VERSION:		0.7
	WEB:			www.sf.net/projects/ingkcpos

	DESCRIPION:	PSPad Editor Extension to enhance cursor behavior:
					-	[ CTRL + (SHIFT) + RIGHT/LEFT ] moves to next right/left-context cursor stop
					-	[ CTRL + ALT + W ] selects and copies word
					-	[ CTRL + ALT + UP/DOWN ] moves current or selected line(s) up/down

					Compatible/tested with PSPad versions:
					-	(full version) 4.5.2 (2240) - Windows XP/SP2 
					-	(beta release) 4.5.3 (2262) - Windows XP/SP2
					-	(beta release) 4.5.3 (2265) - Windows XP/SP2
					-	(beta release) 4.5.3 (2278) - Windows XP/SP2
					-	(full version) 4.5.3 (2291) - Windows XP/SP2
					-	(beta release) 4.5.3 (2296) - Windows XP/SP2
                  ...
               -  (full version) 4.5.8 (2457) - Windows 7/SP1


	INSTALL:		1. Exit PSPad

               2.	Place this script (ingkcpos.js) in:
						~\PSPad editor\Script\JScript\

					3.	Place the settings.dat and settings.hta files in:
						~\PSPad editor\Script\JScript\Ingkcpos\

					4.	Start PSPad


	USE:			[ CTRL + RIGHT ] and [ CTRL + LEFT ] move the cursor to next right/left-context cursor stop

					[ CTRL + SHIFT + RIGHT/LEFT ] selects text with each cursor move

               [ CTRL + ALT + W ] selects and copies word at cursor
               
               [ CTRL + ALT + UP/DOWN ] moves current or selected line(s) up/down

					Scripts (menu) > Ingkcpos > Settings -- allows altering the regular expressions used
					to specifying whitespace, alphanumeric and delimiter characters


	AUTHORS:		Original:	Damion Hankejh, d@ingk.com, http://ingk.com/d
					Updates:		AndyBridges, Michal Caplygin, GriGri,
									Petr Matejka, Jirí Prokop

	LICENSE:		MIT License
					www.opensource.org/licenses/mit-license.php


	---
	NOTES:		Cursor Behavior

					-	Native positioning in PSPad yields cursor stops 
						indicated by "|" in:

							Key combo					PSPad cursor stops marked with |
							---							---
							Original text				if (isSet($error) && $error != '') $text_block.= '<p>'.$error.'</p>';			
							CTRL + (SHIFT) + RIGHT	if (|isSet($|error) && $|error != '') $|text_block.= '<|p>'.$|error.'</|p>';|
							CTRL + (SHIFT) + LEFT	|if (|isSet($|error) && $|error != '') $|text_block.= '<|p>'.$|error.'</|p>';		

					-	Enhanced positioning enabled with the ingkcpos 
						PSPad extension yields:

							Key combo					ingkcpos cursor stops marked with |
							---							---
							Original text				if (isSet($error) && $error != '') $text_block.= '<p>'.$error.'</p>';
							CTRL + (SHIFT) + RIGHT	if |(|isSet|($|error|) |&& $|error |!= |'') $|text|_|block|.= |'<|p|>'.$|error|.'</|p|>';|
							CTRL + (SHIFT) + LEFT	|if |(|isSet|(|$|error|)| |&&| |$|error |!=| |'')| |$|text|_|block|.=| |'<|p|>'.$|error|.'</|p|>';| 


               Select Word

               -  UltraEdit [ CTRL + J ] behavior implementation:

                     Key combo					ingkcpos behavior
                     ---							---
                     CTRL + ALT + W				Selects word at cursor and copies it to clipboard (words include _ character)


					Move Lines

					-	Native PSPad [ Edit > Lines Manipulation > Swap with Line Above/Below ] 
						swaps two lines.

					-	Enhanced line movement enabled with the ingkcpos PSPad 
						extension allows moving the current or selected lines 
						up/down to any location.					


					Settings GUI Dialog

					-	GriGri has added a settings dialog to ease management of whitespace, alphanumeric and 
						delimiter characters (using existing regexp patterns). I've also added a "Reset to Default"
						button to the dialog to allow easily restoring default Ingkcpos behavior.

					
	---
	TODO:			Additional Settings GUI options
	
					-	In some cases, it is useful to have cursor stops on specific characters (eg. TAB) or to
						pass over characters (eg. $). These could be added as options in the Settings GUI Dialog
						implemented above.


					Implement alternate cursor behavior models (cursor themes)

					-	Ingkcpos cursor behavior is modeled on (most similar to) UltraEdit/TextPad. Implementing 
						alternate behavior models drawn from other editors or browsers, selectable via a settings 
						dialog addition (see 'Add Settings GUI Dialog' above) -- perhaps using a theme approach, 
						would further customize cursor movement:

						Theme Name				Cursor Behavior of CTRL + (SHIFT) + RIGHT
						---						---
						WinVi:			  		if |(isSet($error) |&& |$error |!= |'') |$text_block.= |'<p>'.$error.'</p>';|
						Firefox:					if |(|isSet($|error) |&& |$|error |!= |'') |$|text_|block.= |'<|p>'.$|error.'</|p>';|
						Cold fusion(R):		if (|isSet($|error) && $|error != |'') $|text_block.= |'|<p>|'.$|error|.'|</p>|';|
						Cold Fusion(K):		|if (|isSet($|error) && $|error != |'') $|text_block.= |'|<p>|'.$|error.|'|</p>|';


					Select Word at Cursor

					-	This UltraEdit feature is fully implemented. However, it could be smarter -- when the
						the cursor is on whitespace (or delimiters), it could be improved to find the word closest 
						to the cursor position and select/copy it.


	---
	DONE:			Select Word

					-	[ CTRL + ALT + W ] selects and copies the word at the cursor. As with the UltraEdit  
						behavior of [ CTRL + J ], the underscore character is treated as part of a full word, 
						thus the text "foo_bar" is fully selected rather than selecting either "foo" or "bar". 
						Forum user chuckf suggested this feature in the PSPad Developer forum.

						July 29, 2013 - Damion Hänkejh implemented this feature.


					Move Lines

					-	[ CTRL + ALT + UP/DOWN ] moves current or selected line(s) up/down

						July 28, 2013 - Jirí Prokop implemented this feature.


					Scroll Past EOL/EOF Support

					-	[ CTRL + (SHIFT) + LEFT ] does not behave correctly with this setting enabled:
						Settings > Program Settings > Editor (part 1) > Scroll pas EOL and EOF

						November 22, 2007 - Petr Matejka killed this bug.  
						Petr patched the ueCL, ueCSL and ueCSR functions (see PM notes in comments).


					Non-ASCII Character Support

					-	Cursor movement stops upon encountering non-ASCII characters.

						July 16, 2007 - Michal Caplygin
						Altered the alpha regular expression to enable cursor movement when editing files 
						containing non-ASCII characters.


					Unsaved Changes

					-	Use  of ingkcpos to reposition the cursor causes the editor to flag the file as
						modified (indicated by a red triangle in the file tab, or by a diskette icon in the 
						status bar).  However, no changes whatsoever are made to the contents of the file.

						June 26, 2007 - AndyBridges killed this bug.  
						Thanks to his investigation, the "modified flag" bug appears to be related to the 
						use of 'ed.command("ecNextLineStart");' to position the cursor, so he replaced it 
						with calls to ed.caretX() and ed.caretY().


	°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•°•
*/


var module_name	= "Ingkcpos";
var module_ver		= "0.7";
var module_title	= "CTRL + (SHIFT) + LEFT/RIGHT cursor navigator and related features";

var white    = /\s/;																				// Specify whitespaces, alphanumerics and delimiters
var alpha    = /[^\s\~\!\@\#\$\%\^\&\*\(\)\_\+\{\}\|\:\<\>\?\`\-\=\[\]\\\;\,\.\/\"\']/;	
var delim    = /[\~,\!,\@,\#,\$,\%,\^,\&,\*,\(,\),\_,\+,\{,\},\|,\:,\<,\>,\?,\`,\’,\-,\–,\—,\=,\[,\],\\,\;,\,,\.,\/,\",\']/;
var nonalpha = /[\~,\!,\@,\#,\$,\%,\^,\&,\*,\(,\),\_,\+,\{,\},\|,\:,\<,\>,\?,\`,\’,\-,\–,\—,\=,\[,\],\\,\;,\,,\.,\/,\",\']/;
var new_line = "\r\n";

var settings_keys = ['white', 'alpha', 'delim'];

var fso = new ActiveXObject("Scripting.FileSystemObject");
var shl = new ActiveXObject("WScript.Shell");


function Init() 
{
	/* Add this extension to the PSPad Script menu and assign hot keys
	*/

	var dataFilePath = settingsFolder() + "\\settings.dat";							// Load settings
	if (fso.FileExists(dataFilePath)) {
		var config = loadSettingsFile(dataFilePath);
		for (i = 0; i < settings_keys.length; i++) {
			if (typeof(config[settings_keys[i]]) != 'undefined') {
				this[settings_keys[i]] = eval(config[settings_keys[i]]);				// use eval because they are regexps
			}
		}
	}

	addMenuItem("Move cursor right"             , module_name, "ueCR", "CTRL+RIGHT");
	addMenuItem("Move cursor left"              , module_name, "ueCL", "CTRL+LEFT");			
	addMenuItem("Move cursor right and select"  , module_name, "ueCSR", "CTRL+SHIFT+RIGHT");
	addMenuItem("Move cursor left and select"   , module_name, "ueCSL", "CTRL+SHIFT+LEFT");
	addMenuItem("-"                             , module_name, "", "");       // -- menu divider
	addMenuItem("Select and copy word at cursor", module_name, "selectWord",  // Select word under cursor, copy to clipboard (chuckf suggestion)
		"CTRL+ALT+W");
	addMenuItem("-"                             , module_name, "", "");       // -- menu divider
	addMenuItem("Move line(s) up"               , module_name, "linesUp",     // Move current or selected line(s) up
		"");
	addMenuItem("Move line(s) down"             , module_name, "linesDown",   // Move current or selected line(s) down
		"");
	addMenuItem("-"                             , module_name, "", "");       // -- menu divider
	addMenuItem("Settings..."                   , module_name, "showConfig"); // Script settings dialog (customize behavior)
	addMenuItem("-"                             , module_name, "", "");       // -- menu divider
	addMenuItem("Edit this script"              , module_name, "editMe");     // Edit this script in PSPad
 	addMenuItem("-"                            , module_name, "", "");       // -- menu divider
	addMenuItem("About"                         , module_name, "about", "");  // About this extension
	return;
} // Init()


function constructEditor() 
{
	/* Construct new editor object, get line text and current 
		column/line coordinates of cursor, set trim tally to 0
	*/
	ed = newEditor();																				// Construct new editor object
	try {
		ed.assignActiveEditor();																// Assign active editor window

	} catch(e) {
		echo("Failed to assign active editor window in the "
			+ module_name + "script.");
		return;															
	}

	line = ed.lineText();																		// Get current text line
	curx = ed.caretX();																			// Current cursor column position
	cury = ed.caretY();																			// Current cursor row position
	trim = 0;																						// Tally of trimmed characters

	return;
} // constructEditor()


function ueCR() 
{
	/* UltraEdit/TextPad [ CTRL + RIGHT ] cursor behavior:
		move to next right-context cursor stop
	
		Note: cursor begins at column 1, string at 0
	*/
	constructEditor();																			// Construct editor obj, etc.
	var posx = curx - 1;																			// String pos begins at 0, cursor begins at column 1.

	if (curx >= line.length) {																	// IF cursor at end-of-line,
		curx = 0;
		cury++;

	} else {																							// ELSE find next CTRL+RIGHT stop
		c = line.charAt(posx);
		if (c.match(white)) {																	// CURSOR ON WHITE SPACE:
			trim += count(line.slice(posx + trim), white);								// move over white spaces,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}

		} else 
		if (c.match(delim)) {																	// CURSOR ON DELIMITER:
			trim += count(line.slice(posx + trim), delim);								// move over delimiters,
			c = line.charAt(posx + trim);
			trim += count(line.slice(posx + trim), white);								// move over white space trailing delims,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}

		} else 
		if (c.match(alpha)) {																	// CURSOR ON ALPHANUMERIC:
			trim += count(line.slice(posx + trim), alpha);								// move over alphanumerics,
			c = line.charAt(posx + trim);
			trim += count(line.slice(posx + trim), white);								// move over white space trailing alphas,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}
		}
		
		curx += trim;																				// Account for trimmed chars.
	} // IF (cursor at end of line)	

	ed.caretX(curx);																				// Reposition cursor column.
	ed.caretY(cury);																				// Reposition cursor row.
	return;
} // ueCR()


function ueCL() 
{
	/* UltraEdit/TextPad [ CTRL + LEFT ] cursor behavior: 
		move to next left-context cursor stop

		Note: cursor begins at column 1, string at 0
	*/
	constructEditor();																			// Construct editor obj, etc.
	var posx = line.length - curx + 1;														// Column position in string.

	if (curx == 1) {																				// IF cursor at start-of-line,
		if (cury > 1) {																			// PM: if not on first line
			ed.command("ecUp");																	// PM: move cursor up
			ed.command("ecLineEnd");															// PM: and to the end of line
		}

	} else 
	if (curx > line.length + 1) {																// PM: if beyond end of line
		ed.command("ecLineEnd");																// PM: move cursor to the end of line

	} else {																							// ELSE find next CTRL+LEFT stop
		line = line.reverse();																	// Reverse the text to leverage CTRL-RIGHT logic. PM: moved from beginning of the function to here, no need to run it every time
		c = line.charAt(posx);
		if (c == '$') {																			// CURSOR ON $:
			trim++;																					// move over $.

		} else
		if (c.match(white)) {																	// CURSOR ON WHITE SPACE:
			trim += count(line.slice(posx + trim), white);								// move over white spaces,
			trim += count(line.slice(posx + trim), alpha);								// move over alphas.
			c = line.charAt(posx + trim);

		} else 
		if (c.match(delim)) {																	// CURSOR ON DELIMITER:
			trim += count(line.slice(posx + trim), delim);								// move over delimiters,

		} else 
		if (c.match(alpha)) {																	// CURSOR ON ALPHANUMERIC:
			trim += count(line.slice(posx + trim), alpha);								// move over alphanumerics,
		}

		curx = curx - trim;																		// Account for trimmed chars.
		ed.caretX(curx);																			// Reposition cursor.
	} // IF (cursor at start-of-line)
	return;
} // ueCL()


function ueCSR() 
{
	/*	UltraEdit/TextPad [ CTRL + SHIFT + RIGHT ] cursor behavior: 
		move and select text through next right-context cursor stop

		Note: cursor begins at column 1, string at 0
	*/
	constructEditor();																			// Construct editor obj, etc.
	var posx =	curx - 1;																		// String pos begins at 0, cursor begins at column 1.

	if (curx >= line.length) {																	// If cursor at end-of-line,
		ed.command("ecSelDown");																// PM: Move selection to the next line
		ed.command("ecSelLineStart");															// PM: Move selection to the begging of the line

	} else {																							// ELSE find next CTRL+RIGHT stop
		c = line.charAt(posx);
		if (c.match(white)) {																	// CURSOR ON WHITE SPACE:
			trim += count(line.slice(posx + trim), white);								// move over white spaces,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}

		} else 
		if (c.match(delim)) {																	// CURSOR ON DELIMITER:
			trim += count(line.slice(posx + trim), delim);								// move over delimiters,
			c = line.charAt((posx + trim));
			trim += count(line.slice(posx + trim), white);								// move over white space trailing delims,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}

		} else 
		if (c.match(alpha)) {																	// CURSOR ON ALPHANUMERIC:
			trim += count(line.slice(posx + trim), alpha);								// move over alphanumerics,
			c = line.charAt(posx + trim);
			trim += count(line.slice(posx + trim), white);								// move over white space trailing alphas,
			c = line.charAt(posx + trim);
			if (c == '$') {																		// move over $ trailing whites.
				trim++;
			}
		}

		for (n=0; n < trim; n++) {																// Position cursor by
			ed.command("ecSelRight");															// selecting each trim char.
		}
	}
	return;
} // ueCSR()


function ueCSL() 
{
	/* UltraEdit/TextPad [ CTRL + SHIFT + LEFT ] cursor behavior: 
		move and select text through next left-context cursor stop

		Note: cursor begins at column 1, string at 0
	*/
	constructEditor();																			// Construct editor obj, etc.
	var posx = line.length - curx + 1;														// Column position in string.

	if (curx == 1) {																				// If cursor at start-of-line,
		if (cury > 1) {																			// PM: If not on first line
			ed.command("ecSelUp");																// PM: move selection on line up
			ed.command("ecSelLineEnd");														// PM: and to the end of line
		}

	} else 
	if (curx > line.length+1) {																// PM: if beyond end of line
		ed.command("ecSelLineEnd");															// PM: move selection to the end of line

	} else {																							// ELSE find next CTRL+LEFT stop
		line = line.reverse();																	// Reverse the text so as to reuse CTRL-RIGHT logic. PM: moved from beginning of the function to here, no need to run it every time
		c = line.charAt(posx);
		if (c == '$') {																			// CURSOR ON $:
			trim++;																					// move over $.

		} else
		if (c.match(white)) {																	// CURSOR ON WHITE SPACE:
			trim += count(line.slice(posx + trim), white);								// move over white spaces,
			trim += count(line.slice(posx + trim), alpha);								// move over alphas.
			c	  = line.charAt( (posx + trim) );

		} else 
		if (c.match(delim)) {																	// CURSOR ON DELIMITER:
			trim += count(line.slice(posx + trim), delim);								// move over delimiters,

		} else 
		if (c.match(alpha)) {																	// CURSOR ON ALPHANUMERIC:
			trim += count(line.slice(posx + trim), alpha);								// move over alphanumerics,
		}

		for (n=0; n < trim; n++) {																// Position cursor by
			ed.command("ecSelLeft");															// selecting each trim char.
		}
	} // IF (cursor at start-of-line)
	return;
} // ueCSL()


function selectWord() 
{
	/*	Select word at cursor and copy to clipboard
	
		As with UltraEdit behavior (CTRL + J), the underscore character is 
		treated as part of a full word, thus the text "foo_bar" is fully 
		selected rather than selecting either "foo" or "bar"

		(chuckf request from PSPad Developer forum thread)
	*/
	constructEditor();																			// Construct editor obj, etc.
	var word  = /[0-9a-zA-Z\_]/;	
	var posx  = curx - 1;

	if (! line.charAt(posx).match(word) && ( (posx - 1) >= 0) ) {					// Check for alphanumeric or _ char at cursor,
		if (! line.charAt(posx - 1).match(word)) {										// repeat check on left side of cursor,
			return;																					// do nothing if no alphanumeric/_ is found on either side of cursor
		}
	}

	posx2   = curx + count((line.slice(posx)), word);									// move over alphas to right end of word
	revline = line.reverse();																	// reverse text so as to walk forward (right) along string to left-end of word
	posx    = line.length - curx + 1;														// Column position in reversed string
	posx1   = curx - count((revline.slice(revline.length - curx + 1)), word);	// find right end of word,
	ed.caretX(posx1);																				// position cursor at start of word
	x = posx2 - posx1;
	for (n = 0; n < x; n++) {
		ed.command("ecSelRight");																// select each char to end of word
	}

	ed.command("ecCopy");																		// copy selected word to clipboard
	return;
} // selectWord()


function linesUp()
{
	/*	Move current or selected line(s) up	
		Inspired by Eclipse ALT + UP behavior
	*/
	constructEditor();
	var y1 = ed.blockBeginY();
	var y2 = ed.blockEndY();
	var endLineLength;
	var line;
	var selBlock;

	if (ed.blockEndX() == 1 && y1 != y2) {
		y2--;
	}

	if (y1 > 1) {
		// read text of line above selection
		ed.caretY(y1 - 1);
		line = ed.lineText();

		// length for selection of block
		ed.caretY(y2);
		endLineLength = ed.lineText().length;

		// selection of block
		ed.caretY(y1);
		ed.caretX(0);
		ed.setBlockBegin(0, y1);
		ed.setBlockEnd(endLineLength + 1, y2);

		// read selected text                                                
		selBlock = ed.selText();

		// selection for switching texts
		ed.setBlockBegin(0, y1 - 1);
		ed.setBlockEnd(endLineLength + 1, y2);    
		ed.selText(selBlock + new_line + line);

		// final selection
		ed.caretY(y1 - 1);
		ed.caretX(0);
		ed.setBlockBegin(0, y1 - 1);
		ed.setBlockEnd(endLineLength + 1, y2 - 1);
	}
	return;
} // linesUp()


function linesDown() 
{
	/*	Move current or selected line(s) down
		Inspired by Eclipse ALT + DOWN behavior
	*/
	constructEditor();
	var y1 = ed.blockBeginY();
	var y2 = ed.blockEndY();
	var endLineLength;
	var line;
	var selBlock;

	if (ed.blockEndX() == 1 && y1 != y2) {
		y2--;
	}

	if (y2 < ed.linesCount()) {
		// read text of line under selection
		ed.caretY(y2 + 1);
		line = ed.lineText();

		// length for selection of block
		ed.caretY(y2);
		endLineLength = ed.lineText().length;

		// selection of block
		ed.caretY(y1);
		ed.caretX(0);
		ed.setBlockBegin(0, y1);
		ed.setBlockEnd(endLineLength + 1, y2);

		// read selected text                                                
		selBlock = ed.selText();

		// selection for switching texts
		ed.setBlockBegin(0, y1);
		ed.setBlockEnd(line.length + 1, y2 + 1);    
		ed.selText(line + new_line + selBlock);

		// final selection
		ed.caretY(y1 + 1);
		ed.caretX(0);
		ed.setBlockBegin(0, y1 + 1);
		ed.setBlockEnd(endLineLength + 1, y2 + 1);
	}
	return;
} // linesDown()


function editMe() 
{
	/*	Edit this script in PSPad
	*/
	oEdit = newEditor();
	oEdit.openFile(moduleFileName(module_name));
	return;
} // editMe()


function about() 
{
	/*	Display extension description, how to use, license, 
		open source project web address, and developer credits
	*/
	echo(
		"\n" + module_name + " -- version " + module_ver + "\n\n" +
		"_________________\n" +
		"DESCRIPTION\n\n" +
		"   PSPad Editor extension to enhance native\n" +
		"   cursor behavior.\n" +
		"_________________\n" +
		"USE\n\n" +
		"   [ CTRL+RIGHT ] and [ CTRL+LEFT ] move cursor to next right/left-context stop\n\n" +
		"   [ SHIFT+CTRL+RIGHT ] and [ SHIFT+CTRL+LEFT ] move cursor and select text through\n" +
		"   through next right/left-context stop\n\n" +
		"   [ CTRL+ALT+W ] select word at cursor and copy to clipboard\n\n" +
		"   [ CTRL+ALT+UP ] move current or selected line(s) up\n\n" +
		"   [ CTRL+ALT+DOWN ] move current or selected line(s) down\n\n" +
		"_________________\n" +
		"CREDITS\n\n" +
		"   www.sf.net/projects/ingkcpos\n\n" +
		"   MIT License\n" +
		"   Copyright (c) July 2007 - 2013 Damion Hänkejh, ingk.com\n" +
		"   www.opensource.org/licenses/mit-license.php\t\t\n\n" +
		"   Contributing developers:\n" +
		"   AndyBridges, Michal Caplygin, GriGri, Petr Matejka, Jirí Prokop\n"
	);
	return;
} // about()


function count( text, charType ) 
{
	/* Count consecutive regex:charType characters in string:text
	*/
	var n = 0;
	var c = text.charAt(n);

	while (c.match(charType)) {																// While char is regex:charType
		n++;																							// move cursor forward,
		c = text.charAt(n);																		// get next char.
	}
	return n;
} // count()


String.prototype.reverse = 
	function() 
	{
		/* Return the string reversed
		*/
		var s = "";
		var n = this.length;

		while (n > 0) {
			s += this.substring((n - 1), n);
			n--;
		}
		return s;
	} // string.prototype.reverse


function settingsFolder() 
{
	return fso.GetFile(moduleFileName(module_name)).ParentFolder.Path 
		+ "\\" + module_name;
}


function showConfig() 
{
	/*	Display extension settings
	*/
	var tempFilePath = settingsFolder() + "\\temp.dat";								// Write current values to temp file
	var htaFilePath  = settingsFolder() + "\\settings.hta";
	var dataFilePath = settingsFolder() + "\\settings.dat";
	var config = {};

	for (i = 0; i < settings_keys.length; i++) {
		config[settings_keys[i]] = this[settings_keys[i]];
	}
	saveSettingsFile(tempFilePath, config);
	shl.Run('mshta.exe "' + htaFilePath + '" "' + tempFilePath 						// Call the settings dialog [synchronously]
		+ '"', 1, true);
	sleep(50);
	if (! fso.FileExists(tempFilePath)) {													// Cancel or dialog closed - do nothing
		return;
	}
	config = loadSettingsFile(tempFilePath);
	for (i = 0; i < settings_keys.length; i++) {											// Apply and save
		if (typeof(config[settings_keys[i]]) != 'undefined') {
			this[settings_keys[i]] = config[settings_keys[i]] =						// use eval because they are regexps
				eval(config[settings_keys[i]]);
		}
	}
	saveSettingsFile(dataFilePath, config);
	return;
} // showConfig()


function loadSettingsFile( path ) 
{
	/*	Load extension settings file
	*/
	var ts       = fso.OpenTextFile(path, 1);
	var settings = {};
	var line     = "";
	var bits =   null;
	var eq   =   null;
	var key, value;
	
	while (! ts.AtEndOfStream) {
		line = ts.ReadLine().replace(/^\s+|\s+$/g, '');									// Read and trim line
		eq   = line.indexOf('=');
		if (eq != -1) {
			key   = line.substr(0, eq);
			value = line.substr(eq+1);
			settings[key] = unescape(value);
		}
	};
	
	ts.Close();
	return settings;
} // loadSettingsFile()


function saveSettingsFile( path, settings ) 
{
	/*	Save extension settings file
	*/
	var ts = fso.CreateTextFile(path, true);

	for (key in settings) {
		ts.WriteLine(key + "=" + escape(settings[key]));
	}

	ts.Close();
	return;
} // saveSettingsFile()



// Code below not in use -----------------------------------------------------


function deleteLines() 
{
	/*	Delete current or selected line(s)
		Inspired by Eclipse CTRL + D behavior
	*/
	var ed = constructEditor();
	var y1 = ed.blockBeginY();
	var y2 = ed.blockEndY();
	var endLineLength;
	var beforeBeginLineLength;

	if (ed.blockEndX() == 1 && y1 != y2) {
		y2--;
	}

	ed.caretY(y2);
	endLineLength = ed.lineText().length;
	if (y1 > 1) {
		ed.caretY(y1 - 1);
		beforeBeginLineLength = ed.lineText().length;
		ed.setBlockBegin(beforeBeginLineLength + 1, y1 - 1);
		ed.setBlockEnd(endLineLength + 1, y2);

	} 
	else {
		ed.setBlockBegin(0, y1);
		if (y2 < ed.linesCount()) {
			ed.setBlockEnd(0, y2 + 1);
		} 

		else {
			ed.setBlockEnd(endLineLength + 1, y2);
		}    
	}

	// clear text
	ed.selText("");
	// make selection
	if (y1 > 1) {
		ed.caretY(ed.caretY() + 1);
		ed.caretX(0);
	}
	return;
} // deleteLines()
