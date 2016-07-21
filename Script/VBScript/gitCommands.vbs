' An assembly of Git commands for the PSPad editor
' made available for the file(s) in the current directory
' author:      FSpyckerelle 
' started:     05/03/2016 09:03:10
' last update: 08/03/2016 08:55:17

' Prerequisites 
' It is supposed that GIT is already installed and available 
' in the path environment variable, accessible from everywhere
'
' The first thing you should do when you install Git is 
' to set your user name and email address. 
' This is important because every Git commit uses this information, 
'   git config --global user.name "John Doe"
'   git config --global user.email johndoe@example.com

'   user.name=John Doe
'   user.email=johndoe@example.com

' We can also set PSPad as our default editor for Git
' default location of PSPad: '
' C:\Program Files (x86)\PSPad editor\PSPad.exe
'   git config --global core.editor "'C:/Program Files (x86)/PSPad editor/PSPad.exe' -multiInst -nosession"
' e.g. for NotePad++ this would be:
'   git config --global core.editor "'C:/Program Files (x86)/Notepad++/notepad++.exe' -multiInst -nosession"

' In a new subdirectory where your sources are located
' 1) The first command to be executed is
'   git init
'    This will create a (hidden) .git subdirectory
' 2) You can now edit the git\description file  
' 3) The first time you have to add all files, or the file you are interested in
'   git add *.vbs
' 4) if you start modifying your source files,
'    you can verify what happens with the following command
'   git status
'    It will show if there are new files or modified files that could be committed
' 5) Each time you want to commit a version it suffices to execute:
'   git -a -m "A first comment paragraph added to this version"
'    -a is shortcut for add
'    -m is the comment to be added

' See some introductionary information on Git:
' http://jurajhrib.github.io/2014/08/10/git-for-beginners/
' http://rogerdudler.github.io/git-guide/

' http://git-scm.com/
' Read the online ebook "Pro Git" by Scott Chacon and Ben Straub (APress)
' for free at http://git-scm.com/book


' TODO: 1 05/03/2016 09:59:45 see http://rogerdudler.github.io/git-guide/ for some more commands to be added
' TODO: 2 05/03/2016 09:59:58 put the comments in a seperate file
' TODO: 3 05/03/2016 10:01:12 publish git commands extension for PSPad on GitHub
' TODO: 4 05/03/2016 10:04:54 what are the shortcut keys used for Git commands in the normal win-git (or Eclipse JGit) implementations  
' TODO: 5 05/03/2016 10:21:35 add a popup window for obtaining the content of the one paragraph comment to be added to a commit 

' =============================================================================

Option Explicit

Const module_name	= "GitCommands"
Const module_ver		= "1.09"
Const module_date   = "2016-03-08"
Const module_title	= "Git Commands for PSPad 2016-03-08 V1.09"

' inspired by coding of SVN CVS script
'If True, the commands related to a remot repository (push...) are added to the menu. 
Const ADD_REMOTE_COMMANDS_TO_MENU = True
'If True, the "Edit this script" option is added to the menu. Handy when debugging.
Const ADD_EDIT_ME_TO_MENU = True

'%Input% is replaced by the value of an inputbox.


Dim cmdArgs   ' the arguments that will be passed
cmdArgs = vbNullString  

'''Dim editor

' === history ===
' v1.00 05/03/2016 09:18:54 
'       initial version, one command only "git log" 
' v1.01 05/03/2016 09:45:50  
'       refactored for silent and verbose mode of DOS output'
' v1.02 05/03/2016 09:50:13  
'       add common git commands remarks and some TODO's
' v1.03 05/03/2016 10:05:51  
'       add "git config -l" for listing of all configuration settings
'       add "gitk" to launch the internal Graphical User Interface"
' v1.04 05/03/2016 16:43:19 
'       add edit script from within menu
'       add "git status" as git command
'       add "edit this script" to the menu
' v1.05 05/03/2016 19:29:02  
'       add "git log --graph --oneline --decorate --all" for graphical display of branches
'       add "git log --name-status --oneline -3" to see which files have changed over the last 3 commits      
' v1.06 06/03/2016 12:33:13 
'       add "git init" when you want to put a local directory under Git control
'       add "git log --stats" for gitFilesChangedStats
'       add "git log -p --oneline -2" for showing the details of the changes (of the content)
'       add "git stash" for temporarily store uncommitted work (without committing)
'       add "git tag" for tagging a release
'       add "git shortlog" to create a nice chronological changelog
'       add "git fsck" to check the internal Git database for problems or inconsistencies (e.g. dangling objects)
'       add "git gui" 
'            git gui focuses on allowing users to make changes to their repository by making new commits, amending existing ones, creating branches, performing local merges, and fetching/pushing to remote repositories.
'            git gui focuses on commit generation and single file annotation and does not show project history'       
'
'       prepared remote commands fetch and push: net yet implemented message
' v1.07 08/03/2016 08:30:15 
'       add "git symbolic-ref HEAD" to see where HEAD is pointing at
'       add editing of the exclude file ".git\info\exclude" inside PSPad (NOTE:only works ONCE for the momeent       
'
' v1.08 09/03/2016 09:10:37
'       make the treatment of the PSPad editor more stable (add the global editor object variable)
'       this does not work yet as expected       
' v1.09 10/03/2016 18:09:49
'       getting info for the commentline interactively through %Input%
'       TODO: add the line to be displayed in the inputbox as %Input:some text% instead of %input%'         
'


' The sub method "Init" is required.
' It is called automatically during initialization to create menu items
Sub Init()
' the second argument is the title of the parent menu entry (it can be empty if there is only one action)
' the third argument is the name of the sub -availabile in this script- which will be called
' the optional fourth argument is the shortcut key to be used
''// REM the first one is a simple test that echoes the command you pass it  
''  addMenuItem "_test Imputline" _ 
''              , "&GIT commands", "gitEcho"

  addMenuItem "git &Commit" _ 
              , "&GIT commands", "gitCommit"
  addMenuItem "git &Log" _ 
              , "&GIT commands", "gitLog"
  addMenuItem "git &Status" _ 
              , "&GIT commands", "gitStatus"
  addMenuItem "git changelog" _ 
              , "&GIT commands", "gitShortlog"
  addMenuItem "git Files &Changed" _ 
              , "&GIT commands", "gitFilesChanged"
  addMenuItem "git Files Changed Stats" _ 
              , "&GIT commands", "gitFilesChangedStats"
  addMenuItem "git File Contents Changed" _ 
              , "&GIT commands", "gitFileContentsChanged"
  addMenuItem "git Store uncommited work" _ 
              , "&GIT commands", "gitStash"
  addMenuItem "-", "&GIT commands", ""
  addMenuItem "git gui" _ 
              , "&GIT commands", "gitGui"
  addMenuItem "git UI" _ 
              , "&GIT commands", "gitK"
  addMenuItem "edit exclude file" _ 
              , "&GIT commands", "editGitExcludeFile"
  addMenuItem "git Check internal Git database" _ 
              , "&GIT commands", "gitFsck"

  
  addMenuItem "-", "&GIT commands", ""
  addMenuItem "git &graphical branches display" _ 
              , "&GIT commands", "gitGraphicalBranchesDisplay"
'       add "git symbolic-ref HEAD" to see where HEAD is pointing at
  addMenuItem "git display ref of HEAD" _ 
              , "&GIT commands", "gitRefHead"

  addMenuItem "git tagging a release" _ 
              , "&GIT commands", "gitTag"

  addMenuItem "-", "&GIT commands", ""
  addMenuItem "git Create local repository (git init)" _ 
              , "&GIT commands", "gitCreateLocalRepository"


  If ADD_EDIT_ME_TO_MENU Then
    addMenuItem "-", "&GIT commands", ""
    addMenuItem "Edit this script" _ 
              , "&GIT commands", "editMe"
  End If

  ' When we also want to use the remote commands of GIT - in a seperate menu'
  If ADD_REMOTE_COMMANDS_TO_MENU Then
    addMenuItem "-", "&GIT commands Remote", ""
    addMenuItem "fetch" _ 
              , "&GIT commands Remote", "remoteFetch"
    addMenuItem "push" _ 
              , "&GIT commands Remote", "remotePush"

  End If

  ' 09/03/2016 09:11:53 set the global editor variable
''''  Set editor = NewEditor()
  ' assign it to the current instance of PSPad
''''  editor.assignActiveEditor()
End sub

'NOTE: cmdArgs can contain multiple commands by separating them with && like this: cmdArgs = "cd\php && php.exe"

' ******************************
' *** The basic GIT commands ***
' ******************************
' gitStatus shows if something has changed in your sources that was already added and that could be committed
Sub gitEcho()
    Dim strCommand
  cmdArgs = "echo"
  strCommand = cmdArgs & " %Input%"
  strCommand = WithInput (strCommand, "Give me something I should echo", "A simple echo Input exmaple")
  executeRunCmd(strCommand)   
End Sub

' gitCommit
Sub gitCommit()
    Dim strCommand
  cmdArgs = "git commit"
  strCommand = "git commit -a -m ""%Input%"""
  strCommand = WithInput(strCommand, "Give your comment", "Git commit with one comment")    
  executeRunCmd(strCommand)   
End Sub

' gitLog
Sub gitLog()
  'The normal command
  ' cmdArgs = "git log"
  'The comment on one line 
  ' cmdArgs = "git log --pretty=oneline"
  '                           oneline, short, medium, full, fuller, email, raw
  ' but with oneline or short, you do not see the dates of the commits

  ' Shorten the commit object
  ' cmdArgs = "git log --pretty=oneline --abbrev-commit"
  ' which is the same as "git log --oneline"
  cmdArgs = "git log --oneline"
    
  
  ' cmdArgs = "git log master --not --remotes=*/master"
  '    Shows all commits that are in local master but not in any remote repository master branches.
  ' cmdArgs = "git log -p -m --first-parent"
  '    Shows the history including change diffs, but only from the “main branch” perspective, skipping commits that come from merged branches, and showing full diffs of changes introduced by the merges. This makes sense only when following a strict policy of merging all topic branches when staying on a single integration branch.

  ' cmdArgs = "git log --branches --not --remotes=origin"
  '    Shows all commits that are in any of local branches but not in any of remote-tracking branches for origin (what you have that origin doesn’t).
  ' cmdArgs = "git log master --not --remotes=*/master"
  '    Shows all commits that are in local master but not in any remote repository master branches.

  ' cmdArgs = "git log -3"
  '    Limits the number of commits to show to 3
  
  'for date:' 
  ' git log --date=relative   ' 7 hours ago
  ' git log --date=rfc        ' Sat, 5 Mar 2016 09:15:54 +0100  (default = like the normal setting)
  ' git log --date=iso        ' 2016-03-05 09:15:54 +0100
  ' git log --date=short      ' 2016-03-05
  
  '( --pretty or --format)
  ' --format=<format>
  '    Pretty-print the contents of the commit logs in a given format, where <format> can be one of oneline, short, medium, full, fuller, email, raw and format:<string>. See the "PRETTY FORMATS" section for some additional details for each format. When omitted, the format defaults to medium. '
  ' oneline, short, medium, full, fuller, email, raw
  executeRunCmd(cmdArgs)   
End sub

' gitStatus shows if something has changed in your sources that was already added and that could be committed
Sub gitStatus()
  cmdArgs = "git status"
  executeRunCmd(cmdArgs)   
End Sub

' gitShortlog to create a nice chronological changelog (but without date indacations
Sub gitShortlog()
  cmdArgs = "git shortlog"
  executeRunCmd(cmdArgs)   
End Sub

' gitFilesChanged to see which files have changed over the last 3 commits, --oneline is to shorten the display
Sub gitFilesChanged()
  cmdArgs = "git log --name-status --oneline -3" 
  executeRunCmd(cmdArgs)   
End Sub

' gitFilesChangedStats to see graphically which files have changed over the last 3 commits
Sub gitFilesChangedStats()
  cmdArgs = "git log --stats --oneline -3" 
  executeRunCmd(cmdArgs)   
End Sub

' gitFileContentsChanged shows the details of the contents which have changed
' done ignore whitespaces and whitelines
Sub gitFileContentsChanged()
  cmdArgs = "git log -p -w --oneline -2"
  '                     -w is to ignore whitespaces
  '                                  -2 only this and the previous version
  '
  executeRunCmd(cmdArgs)   
End Sub

' gitStash to temporarily store uncommitted work (without committing)
Sub gitStash()
  cmdArgs = "git stash" 
  executeRunCmd(cmdArgs)   
End Sub

' .git\info\exclude
Sub editGitExcludeFile()
    'NOTE: check why you can only execute this ONCE in a session
    'it complans that it cannot find the newEditor reference the second time
  'newEditor.openFile (".git\info\exclude")
  'editor.openFile(".git\info\exclude")
    Dim myEditor
    Set myEditor = newEditor
    ''set myEditor = getNewEditor()      ' deprecated no longer used in PSPad

    Dim blnResult
    'blnResult = myEditor.assignActiveEditor()
    'msgbox("Result of launching myEditor.assignActiveEditor() = " & blnResult)
    msgbox("Result of editorsCount() = " & editorsCount())
    'blnResult = myEditor.openFile moduleFileName ".git\info\exclude"
    myEditor.openFile(".git\info\exclude")
    'myEditor.openFile moduleFileName(".git\info\exclude")
    ' newEditor.openFile ".git\info\exclude"
    ''Set myEditor = Nothing
    msgbox("Result of launching myEditor.openFile ('.git\info\exclude') = " & blnResult)
  If False Then
    ''NeverExecuteThis ' undefined sub so will not do anything
  End If
  newEditor.assignActiveEditor()          ' to try to reset it to the previous one
End Sub



' **********************************************
' *** Branching and Tagging related commands ***
' **********************************************
' see for a good introduction e.g. 
' http://nvie.com/posts/a-successful-git-branching-model/

'gitGraphicalBranchesDisplay
Sub gitGraphicalBranchesDisplay()
  cmdArgs = "git log --graph --oneline --decorate --all"
  executeRunCmd(cmdArgs)   
End Sub


'gitrefHead to see where HEAD is pointing at
' on Windows this is equivalent to the command
'    type .git\HEAD
Sub gitRefHead() 
  cmdArgs = "git symbolic-ref HEAD"
  executeRunCmd(cmdArgs)   
End Sub

'gitTag for tagging a release
Sub gitTag() 
  cmdArgs = "git tag"
  executeRunCmd(cmdArgs)   
End Sub



' **************************************
' *** General documentation commands ***
' **************************************
' gitCreateLocalRepository is the "git init" when some source already exists and you want to create a local git repository
Sub gitCreateLocalRepository()
  ' TODO should we add some checks already to see if a local git already existed?
  cmdArgs = "git init" 
  executeRunCmd(cmdArgs)   
End Sub

'gitGui launches the external GUI
' focuses on allowing users to make changes to their repository by making new commits, amending existing ones, 
' creating branches, performing local merges, 
' and fetching/pushing to remote repositories.
' focuses on commit generation and single file annotation and does not show project history'       
 
sub gitGui()
  cmdArgs = "git gui" 
  executeRunCmd(cmdArgs)   
end sub

'gitK launches the internal GUI of GIT 
sub gitK()
  cmdArgs = "gitk" 
  executeRunCmd(cmdArgs)   
end sub

'gitFsck checks the internal Git database for problems or inconsistencies (dangling objects) 
sub gitFsck()
  cmdArgs = "git fsck" 
  executeRunCmd(cmdArgs)   
end sub


' **********************************
' *** Remote repository commands ***
' **********************************
'gitFsck checks the internal Git database for problems or inconsistencies (dangling objects) 
sub remoteFetch()
    Dim intMsgBoxSelection 
    intMsgBoxSelection = MsgBox ("Not implemented yet " & vbCrLf & "in version " & module_ver & vbCrLf & "of " & module_date, vbExclamation, "gitCommands Remote" )

    If intMsgBoxSelection = vbYes Then Exit Sub
  
  'cmdArgs = "git fetch" 
  'executeRunCmd(cmdArgs)   
end sub

'gitFsck checks the internal Git database for problems or inconsistencies (dangling objects) 
sub remotePush()
    Dim intMsgBoxSelection 
    intMsgBoxSelection = MsgBox ("Not implemented yet " & vbCrLf & "in version " & module_ver & vbCrLf & "of " & module_date, vbExclamation, "gitCommands Remote" )

    If intMsgBoxSelection = vbYes Then Exit Sub

  'cmdArgs = "git push" 
  'executeRunCmd(cmdArgs)   
end sub


' =============================================================================

' ************************
' *** Helper functions ***
' ************************
' this is from the CSV addin
' $URL: https://opensvn.csie.org/TinyCollection/PSPad/trunk/code/svncmd.vbs $
' $Author: DonQuichote $
' $Date: 2006-09-28 19:58:13 +0200 (Thu, 28 Sep 2006) $
' $Revision: 35 $
Sub editMe()
  newEditor.openFile moduleFileName(module_name)
  If False Then
    NeverExecuteThis ' undefined sub so will not do anything
  End If
End Sub


' 10/03/2016 17:54:52 why would we need more than one sustitution for %input%
Function WithInput(Byval strCommand, ByVal strInputCaption, ByVal strWindowTitle )
  Dim strSought          'what are we looking for: here %Input%
  strSought = "%Input%"
  Dim numPos
  numPos = InStr(1, strCommand, "%Input%")

  ''dim strReplaceBy
  ''strReplaceBy = InputBox("Comment:", strInputCaption)
  While numPos>0
    'strCommand = Substitute(strCommand, "%Input%", InputBox("Comment:", strInputCaption))
    strCommand = Left(strCommand, numPos - 1) _
               & InputBox(strInputCaption & " :", strWindowTitle) _
               & Mid(strCommand, numPos + Len("%Input%"))    
    ' Check if there are further occurences of %Input% to be replaced
    numPos = InStr(1, strCommand, "%Input%")
  Wend
  WithInput = strCommand
End Function


' executeRunCmd will execute the cmdArgs in a visible DOS box and keep it open
Sub executeRunCmd(byval cmdArgs)
   'NOTE: cmdArgs can contain multiple commands by separating them with && like this: cmdArgs = "cd\php && php.exe"
  Dim wshShell
  Set wshShell = CreateObject("WScript.Shell")

  wshShell.Run "cmd.exe /K " & cmdArgs, 1, False
   'NOTE:                               1 = show DOS window
   '                                    0 = hide DOS window
   '                    /K =  keep DOS window open when application terminates
   '                    /C = close DOS window when application terminates  
               
  Set wshShell = Nothing
End Sub

' executeRunCmdSilently will execute the cmdArgs in a hidden DOS box and executes it in the background (not forked or spawned for the moment 05/03/2016 10:20:41)
Sub executeRunCmdSilently(byval cmdArgs)
   'NOTE: cmdArgs can contain multiple commands by separating them with && like this: cmdArgs = "cd\php && php.exe"
   
  Dim wshShell
  Set wshShell = CreateObject("WScript.Shell")

  wshShell.Run "cmd.exe /C " & cmdArgs, 0, False   
   'NOTE:                               1 = show DOS window
   '                                    0 = hide DOS window
   '                    /K =  keep DOS window open when application terminates
   '                    /C = close DOS window when application terminates  
               
  Set wshShell = Nothing
End Sub
