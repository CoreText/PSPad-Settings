/*------------------------------------------------------------
/ hots
/
/   Copyright (C) 2008, 2009 Alesc
/   This program is free software: you can redistribute it and/or modify
/   it under the terms of the GNU General Public License.
/
/------------------------------------------------------------*/
var module_name = "hots";
var module_ver = "0.6";

function Init()
{
addMenuItem("hots", "hots", "hots", /*PSP_ACTION_KEY_START*/"Ctrl+Alt+G"/*PSP_ACTION_KEY_END*/); // modified on 20081028124959(YYYYMMDDHH24MISS) by hots.ahk
    addMenuItem("-","hots","","");
    addMenuItem("About","hots","aboutScript","");
}

function aboutScript()
{
    echo(
        "\n" + module_name + " " + module_ver + "\n\n" +
        "_________________\n" +
        "DESCRIPTION\n\n" +
        "   PSPad Editor extension for moving to specified file, specified line number and " +
        "getting word.\n"
        );
  return;
}

function getConnPath()
{
    var connPath = "";

    var appdata = new ActiveXObject("WScript.Shell").ExpandEnvironmentStrings("%APPDATA%");
    connPath = appdata + "\\" + module_name + "\\conn";

    return connPath;
}

/*var Winamp = new ActiveXObject('ActiveWinamp.Application');
var mi = Winamp.Playlist(Winamp.Playlist.Position)
echo(mi.Title);
return;*/

/*------------------------------------------------------------
/ hots
/
/ Description:
/   Errors are written to psp_out_file.
/
/------------------------------------------------------------*/
function hots()
{
    connPath = getConnPath();
    var psp_action_file = connPath + "\\" + "psplib_action.ahk2psp";
    var psp_out_file    = connPath + "\\" + "psplib_output.psp2ahk";

    // set outputs in all modules
    hots_core.setOutput(psp_out_file);
    hots_ctag.setOutput(psp_out_file);

    // read the action
    var action = hots_core.readFile(psp_action_file);

    if (action)
    {
        var tmp_params = new Array();
        var all_args = new Array();
        var args = new Array();
        var params = "";

        // check for any function parameters
        tmp_params = action.split(/\(/);
        if (tmp_params.length > 1)
        {
            action = tmp_params[0];
            all_args = tmp_params[1].split(/\)/);
            // save params to args
            if (all_args.length > 1)
                args = all_args[0].split(/,/);
        }
        // create proper string from args
        for (var i=0; i<args.length; i++)
        {
            params = params + args[i];
            if (i < args.length-1)
                params = params + "\", \"";
        }

        // if pspad function runPSPadAction
        if (action.match("runPSPadAction") != null)
        {
            runPSPadAction(params);
            hots_core.report("Normal", "PSPad action executed.");
        }
        // if jscript or mine function
        else if (eval('typeof(' + action + ')') == 'function')
            eval(action + '("' + params + '");');
        else
        {
            hots_core.report("Error", "Function [" + action + "] not found.");
        }
    }
    else
    {
        hots_core.report("Error", "No action read from file [" + psp_action_file + "].");
    }

    return;
}
