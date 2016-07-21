/*******************************************************************************
 * (c) 2007 - http://www.hofrichter.net - sven hofrichter - pspad@hofrichter.net
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * author ......... : Sven Hofrichter
 * date ........... : 2007-11-22
 * version ........ : 0.2
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * description .... : this (user-)script formats a braket-structure in a for
 *                    human readable style. Known brackets are "{" and "}".
 *                    Brackets in quotes and excaped ones will ignored by the
 *                    script. Supported/tested languages are:
 *                    - Java
 *                    - JavaScript
 *                    - PHP
 * introduction ... : open the file, that you want to change, in PSPad and
 *                    use one of the following short-cuts:
 *                    ~ <CTRL><ALT><SHIFT><F> .... formated xml-structure will
 *                                                 replace the original one in
 *                                                 current editor-tab
 * known bugs ..... : the current version of the script handles comments, but
 *                    does not work correctly in every situation on it. If you
 *                    format this script while using itself, you will see, that
 *                    the two-slashes-combination of a regulare expression in an
 *                    "else if"-statement next to line 100 disables the further
 *                    indenting of the next line. One indent is missing at the
 *                    end, but the code is well readable and interpretable by
 *                    the JScript-compiler/-interpreter.
 *                    Only the script "BracketFormat.js" loses it's functionali-
 *                    ty, if it runs on itselfs, because oft the internal varia-
 *                    bles, that are used as placeholders for special characters
 *                    or sequences.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * history:
 * 2007-09-24 - 0.1 - hofsve - initial version
 * 2007-11-22 - 0.2 - melchi/hofsve - remove empty lines disabled. Set the value
 *                                    of variable "removeEmptyLines" to true, if
 *                                    you don't want this feature.
 ******************************************************************************/
var module_name = "BracketFormat";
var module_ver = "0.2";
function contentInCurrentEditor() {
	var m_old_editor = newEditor();
	m_old_editor.assignActiveEditor();
	if( m_old_editor.selText().length>0 ) {
		m_old_editor.selText( FormatBrackets( m_old_editor.selText() ) );
	}
	else {
		m_old_editor.Text( FormatBrackets( m_old_editor.Text() ) );
	}
}
function FormatBrackets( m_text ) {
  var removeEmptyLines = false; // set this parameter to "true", if you want to
                                // remove all empty lines, otherwise "false"
	var m_default_depth = 0; // default is "tab"
	var m_chosen_depth  = null;
	try {
		// if the version of PSPad is not a newer one, the following will fail:
		m_chosen_depth = InputText( "Please enter the depth (0=Tab):", m_default_depth );
	}
	catch(e) {
		// setting up the default, if there was something happen before
		m_chosen_depth = m_default_depth;
	}
	m_indent_sign = " ";
	if( m_chosen_depth == 0 ) {
		m_chosen_depth = 1;
		m_indent_sign  = "\t";
	}
	var m_spaces = m_indent_sign;
	for( var m_curr=0; m_curr<100; m_curr++ ) {
		m_spaces += m_indent_sign;
	}

	var mRegExp = /([\n\r])/;
	mRegExp.exec(m_text);
	m_new_line = RegExp.$1;
	if( m_new_line==null || m_new_line=="" ) {
    m_new_line = '\r\n';
    var mMsg = "[ATTENTION]\nNo newline-marker found! This happens only on one-line-selections.";
        mMsg+= "\nThe formater will use the DOS-sequence for a new line '\\r\\n' (CR+LF).";
        mMsg+= "\n\nPlease use the 'Format'-menu of PSPad to handle/correct the format for the"
        mMsg+= "\nwhole file after the formater ran.";
        mMsg+= "\nYou can see the original format (DOS, UNIX or MAC) in the status-line of PSPad.";
    echo( mMsg );
  }

	// please do not change brackets in strings or escaped ones:
	m_text = m_text.replace(/\\\{/g, "\\####open_bracket####"  );
	m_text = m_text.replace(/\\\}/g, "\\####close_bracket####" );
	m_text = m_text.replace(/([\"\'][^\r\n\"\']*)\{([^\r\n\"\']*[\"\'])/g, "$1####open_bracket####$2"  );
	m_text = m_text.replace(/([\"\'][^\r\n\"\']*)\}([^\r\n\"\']*[\"\'])/g, "$1####close_bracket####$2" );

  m_text = m_text.replace(/(\/\/[^\r\n]*)\{/g, "$1####open_bracket####"  );
	m_text = m_text.replace(/(\/\/[^\r\n]*)\}/g, "$1####close_bracket####" );

	// cleanup the bracket-structure and prepare it for a clean splitting
	m_text = m_text.replace(/\}/g,m_new_line+"}"+m_new_line);
	m_text = m_text.replace(/\{/g,m_new_line+" {"+m_new_line);
	m_br_array = m_text.split( /[\r\n]+/ );
	var m_return = "";
	var m_current_depth = 0;
	var m_is_comment = false;
	// every line and every bracket is now in it's own line
	for( var i=0; i<m_br_array.length; i++ ) {
		// trim the line
		m_br_array[i] = m_br_array[i].replace(/^\s*/g,"").replace(/\s*$/g,"");
		// ignore empty lines
		if( m_br_array[i].replace(/\s+/g,"").length==0 ) {
      if( removeEmptyLines==false ) {
        m_return += m_new_line;
      }
      continue;
		}
    if( m_br_array[i].match(/^[^\'\"]+\/\*/) ) {
      m_is_comment = true;
    } else if( m_br_array[i].match(/^[^\'\"]+\*\//) ) {
  		m_return += m_new_line;
      if( m_chosen_depth>0 && m_current_depth>0 ) {
  			m_return += m_spaces.substr( 0, m_current_depth*m_chosen_depth );
  		}
      m_return += m_br_array[i];
      m_is_comment = false;
      continue;
    }
    if( m_is_comment==true ) {
      if( i>0 && m_br_array[i]!="{" && m_br_array[i]!="}" ) {
        m_return += m_new_line;
      }
  		if( m_chosen_depth>0 && m_current_depth>0 ) {
  			m_return += m_spaces.substr( 0, m_current_depth*m_chosen_depth );
  		}
      m_return += m_br_array[i];
      continue;
    }


    if( m_br_array[i] == "{" ) {
      if( m_is_comment==false ) {
        m_current_depth = m_current_depth + 1;
      }
      m_return += " { ";
			continue;
		} else if( m_br_array[i] == "}" ) {
      if( m_is_comment==false ) {
  			m_current_depth = m_current_depth - 1;
      }
		}
		if( i>0 ) {
      m_return += m_new_line;
		}
		if( m_chosen_depth>0 && m_current_depth>0 ) {
			m_return += m_spaces.substr( 0, m_current_depth*m_chosen_depth );
		}
		m_return += m_br_array[i];
	}
  m_return = m_return.replace( /####open_bracket####/g, "{" );
	m_return = m_return.replace( /####close_bracket####/g,"}" );
	return m_return;
}
function Init() {
	addMenuItem( "&Bracket Format (v"+module_ver+")", "&Format Code", "contentInCurrentEditor", "");
}
