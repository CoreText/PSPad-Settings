/******************************************************************************\
 * (c) 2007 - http://www.hofrichter.net - sven hofrichter - pspad@hofrichter.net
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * author ......... : Sven Hofrichter
 * date ........... : 2007-09-20
 * version ........ : 1.0
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * description .... : This script generates a little labyrinth of encrypted
 *                    javascript-files. It does not avoids a decryption of your
 *                    javascript-code, but it hides the file, while creating
 *                    a collection of lighweight-encrypted JS-files.
 *                    Every generated file of the script-collection contains a
 *                    reference to it's next "child". The last "child" is your
 *                    encrypted script.
 *                    Decoded example of the child-include-syntax:
 *                    <script type="text/javascript" src="<next-file>"></script>
 *
 *                    The "depth" of the labyrinth defines, how many scripts are
 *                    before the last (YOUR) script will be included into the
 *                    HTML-page.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * history:
 * 2007-01-24 - 0.1 - hofsve - initial version
 * 2007-02-02 - 0.2 - hofsve - fixed: encrypted file will be placed in correct
 *                             folder, because the script uses absolute pathes
 * 2007-02-26 - 0.3 - hofsve - fixed: NOW you can move the output in a userde-
 *                             fined folder, because the created labyrinthfiles
 *                             are reading out there own installationpath to 
 *                             correct the "installationpath" in the src-
 *                             attribute of every <script src="..." ..></script>
 * 2007-09-20 - 1.0 - hofsve - "JavaScript-Encryption cancled!" if the depth is
 *                             zero, the user chose the "cancel"-button or the
 *                             ESC-key was pressed.
 *                             Additional changes in the shortcut:
 *                             <CTRL><SHIFT><ALT><E>
 *
\******************************************************************************/
var module_name = "encryptJS";
var module_ver = "1.0";

function encryptJS( m_text ) {
  var m_labyrinth_depth = 0;
  try { // if the version of PSPad is not a newer one, the following will fail:
    m_labyrinth_depth = InputText( "Please enter the depth of the labyrinth:", 5 );
  } catch(e) { // setting up the default, if there was something happen before
    m_labyrinth_depth = 0;
  }
  if( m_labyrinth_depth==0 ) {
    echo( "JavaScript-Encryption cancled!" );
    return;
  }
  // this variable sets the number of script's that will generated to make it to
  // a hard job, downloading the real js-file, with the encrypted content.

  var m_new_editor = newEditor();
  var m_log_editor = newEditor();
  var m_old_editor = newEditor();

      m_old_editor.assignActiveEditor();
      m_log_editor.AssignLog();

  var m_file = m_old_editor.fileName(); //
  var m_file_name = m_file.replace( /^.*[\\\/]([^\\\/]+)$/, '$1' );
  var m_file_dir  = m_file.replace( /^(.*[\\\/])[^\\\/]+$/, '$1' );

  var m_file_prefix = m_file_name.substring( 0, m_file_name.lastIndexOf('.') );
  var m_file_suffix = m_file_name.substring( (m_file_name.lastIndexOf('.')+1), m_file_name.length );

  var m_src  = m_file_prefix + '_encrypted.' + m_file_suffix;
  var m_path = 'var labyrinth_script_file_name = \''+m_src+'\';';
      m_path+= 'eval(String.fromCharCode(118,97,114,32,108,97,98,121,114,105,110,116,104,95,115,99,114,105,112,116,95,102,105,108,101,95,112,97,116,104,32,61,32,39,46,47,39,59,118,97,114,32,108,97,98,121,114,105,110,116,104,95,116,101,109,112,111,114,97,114,121,95,118,97,114,105,97,98,108,101,32,61,32,100,111,99,117,109,101,110,116,46,103,101,116,69,108,101,109,101,110,116,115,66,121,84,97,103,78,97,109,101,40,39,115,99,114,105,112,116,39,41,59,102,111,114,40,32,118,97,114,32,105,61,48,59,32,105,60,108,97,98,121,114,105,110,116,104,95,116,101,109,112,111,114,97,114,121,95,118,97,114,105,97,98,108,101,46,108,101,110,103,116,104,59,32,105,43,43,32,41,32,123,32,32,116,114,121,32,123,32,32,32,32,105,102,40,32,108,97,98,121,114,105,110,116,104,95,116,101,109,112,111,114,97,114,121,95,118,97,114,105,97,98,108,101,91,105,93,46,103,101,116,65,116,116,114,105,98,117,116,101,40,39,115,114,99,39,41,46,105,110,100,101,120,79,102,40,32,108,97,98,121,114,105,110,116,104,95,115,99,114,105,112,116,95,102,105,108,101,95,110,97,109,101,32,41,62,45,49,32,41,32,123,32,32,32,32,32,32,108,97,98,121,114,105,110,116,104,95,115,99,114,105,112,116,95,102,105,108,101,95,112,97,116,104,32,61,32,108,97,98,121,114,105,110,116,104,95,116,101,109,112,111,114,97,114,121,95,118,97,114,105,97,98,108,101,91,105,93,46,103,101,116,65,116,116,114,105,98,117,116,101,40,39,115,114,99,39,41,46,114,101,112,108,97,99,101,40,32,47,91,92,92,92,47,93,40,91,94,92,92,92,47,93,43,41,36,47,44,32,39,47,39,32,41,59,32,32,32,32,125,32,32,125,32,99,97,116,99,104,40,101,41,32,123,32,32,32,32,59,32,32,125,125));';

  var m_tmp = '';
  var m_enc = '';
  var m_log = '';

  m_log_editor.Text( 'Status of encrypting JavaScript-file \''+m_file+'\':\n' );
  for( var m_id=0; m_id<m_labyrinth_depth; m_id++ ) {

    m_log_editor.appendText( '- file #'+m_id+' ... ' );
    // "m_src" will get a new value, before finishing the encryption. That's why
    // we create the logging-message "finished..." before the encryption starts.
    m_log = ' finished, result: \''+m_file_dir + m_src+'\'.\n';

    m_new_editor.NewFile( m_file_dir + m_src );
    m_src = m_file_prefix + '_' + String(Math.random()).replace( /\./, '' ) + '.' + m_file_suffix;
    m_tmp = m_path + 'document.write('
          + '\'<script type=\\\"text/javascript\\\" src=\\\"\'+labyrinth_script_file_path+\'' + m_src + '\\\">'
          + '</script>\');';

    m_enc = 'eval(String.fromCharCode(' + m_tmp.charCodeAt(0);
    for( var i=1; i<m_tmp.length; i++ ) {
      m_enc += ',' + m_tmp.charCodeAt(i);
    }
    m_enc += '));';
    m_new_editor.Text( m_enc );
    m_new_editor.saveFile();
    m_new_editor.closeFile();
    m_log_editor.appendText( m_log );
  }

  m_log_editor.appendText( '- file #'+m_id+' ... ' );
  m_log = ' finished, result: \''+ m_file_dir + m_src +'\'.\n'; // m_src will get a new value, before finishing the encryption

  m_tmp = m_old_editor.Text();
  m_tmp = m_tmp.replace( /\/\/.*/g, '' );
  m_tmp = m_tmp.replace(/([\n\r]*)/g, '');
  m_tmp = m_tmp.replace( /(\/\*.*?\*\/)/g, '' );
  m_tmp = m_tmp.replace( /}\s*function\s+/g, '} function ' );
  m_enc = 'eval(String.fromCharCode(' + m_tmp.charCodeAt(0);
  for( var i=1; i<m_tmp.length; i++ ) {
    m_enc += ',' + m_tmp.charCodeAt(i);
  }
  m_enc += '));';
  m_new_editor.NewFile( m_file_dir + m_src );
  m_new_editor.Text( m_enc );
//   m_new_editor.Text( m_enc );
  m_new_editor.saveFile();
  m_new_editor.closeFile();
  m_log_editor.appendText( m_log + '\n' );
  
  // make it user-friendly:
  m_log_editor.appendText( 'Include following line into your HTML-page and replace <path> by the real relative or absolute path of the JavaScript on your server.\n' );
  m_log_editor.appendText( '  <script type=\"text/javascript\" src=\"<path>/'+m_file_prefix+'_encrypted.'+m_file_suffix+'\"></script>\n\n' );
  m_log_editor.appendText( 'IMPORTANT: Make sure that all generated files are placed in the same folder.\n' );
}

function Init(){
  addMenuItem( "JavaScript encrypt (v"+module_ver+")", "&Format Code", "encryptJS", "" );
}
