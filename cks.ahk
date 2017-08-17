#SingleInstance force
#NoEnv
#InstallKeybdHook
#InstallMouseHook

FileInstall, CCS.jpg,CCS.jpg, 1
Gui, Add, Picture, Section w600 h-1 gConsLogo, CCS.jpg
Gui, Add, Button, Section w450 x75 gConsLink, Visit: The Consortium Gold Forums - Best Resources for Gold Making tips, tricks and guides
Gui, Add, Checkbox, Section x10 gMouseListen vMouseEnabled, Listen to mouse
Gui, Add, Checkbox, xs gKbdListen vKbdEnabled, Listen to keyboard
Gui, Add, Checkbox, xs gPhsListen vPhsEnabled, Listen to user input
Gui, Add, Checkbox, ys vMimic Section, Mimic input 
Gui, Add, Checkbox, xs vRandEnabled, Random events
Gui, Add, Checkbox, xs vSequenceEnabled, Sequence send
Gui, add, Button, Section gRefreshList ys w60, Refresh
Gui, add, Button, gHelpListen xs w60, Help
Gui, add, Text, xs, Pause button
Gui, add, Button, Section gPauseListen ys w60 vPauseButton Default, Pause
Gui, add, Button, gCoordsListen xs w60, CoordSpy
Gui, add, edit, xs vPauseKey gEditChange w50
Gui, Add, Checkbox, ys gAutoRef vAutoEnabled Section, AutoRefresh each
Gui, add, ComboBox, ys vSecToRef w50, 1|2|3|4|5|6|7|8|9|10||
Gui, add, Text, ys, sec
Gui, add, Text, xs Section, Random interval 
Gui, add, ComboBox, ys vRandStart w50, 0.5|1|1.5|2||2.5|3|3.5|4|4.5|5
Gui, add, Text, ys, -
Gui, add, ComboBox, ys vRandEnd w50, 0.5|1|1.5|2|2.5|3||3.5|4|4.5|5
Gui, add, Text, ys, sec
Gui, add, Text, xs Section, Keys to send
Gui, add, edit, ys vKeys w150
Gui, add, ListView, vMyList gMyList w600 h300 Checked SortDesc xm, Name|Class|ID

CoordMode, Mouse, Screen
if A_IsCompiled
  Menu, Tray, Icon, %A_ScriptFullPath%, -159

IniRead, SecToRefTemp, %A_WorkingDir%\CKSSettings.ini, 1, SecToRef
IniRead, RandStartTemp, %A_WorkingDir%\CKSSettings.ini, 1, RandStart
IniRead, RandEndTemp, %A_WorkingDir%\CKSSettings.ini, 1, RandEnd
IniRead, KeysTemp, %A_WorkingDir%\CKSSettings.ini, 1, Keys
IniRead, PauseKeyTemp, %A_WorkingDir%\CKSSettings.ini , 1, PauseKey

if (PauseKeyTemp = "ERROR" or PauseKeyTemp = "") {
    PauseKeyTemp := "#p"
}

if (SecToRefTemp = "ERROR") {
    MsgBox,, Attention !, This seems to be the first time that you are using the Consortium Key Sender. Please read the help first !
    gosub, HelpListen
    
} else {
    GuiControl,, SecToRef, %SecToRefTemp%||
    GuiControl,, RandStart, %RandStartTemp%||
    GuiControl,, RandEnd, %RandEndTemp%||
    GuiControl,, Keys, %KeysTemp%
    GuiControl,, PauseKey, %PauseKeyTemp%
}

idList := object()
refresh(idList)
OldPause := PauseKeyTemp
Hotkey, %PauseKeyTemp%, PauseListen
Seq := 0
Timer := 0
Gui, show,, Consortium Key Sender
return

EditChange:
Gui submit, NoHide
if (OldPause = PauseKey)
    return

if (OldPause != "") {
    Hotkey, %OldPause%, Off
}

if (PauseKey = "" )
    return

Hotkey, %PauseKey%, PauseListen
OldPause := PauseKey
return

CoordsListen:
if (Timer) {
    Settimer WatchCursor, off
    Tooltip
    Timer:=0
} else {
    Settimer WatchCursor, 50
    Timer:=1
}
return

WatchCursor:
MouseGetPos , mouseX, mouseY
ToolTip, %mouseX% %mouseY%
return

ConsLogo:
ConsLink:
Run, http://consortium.stormspire.net/content/
return

KbdListen:
Gui submit, NoHide
while (KbdEnabled)
{
    Input, SingleKey, L1,  {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Backspace}{Capslock}{Numlock}{PrintScreen}{Pause}
    Send % SingleKey
    Gui submit, NoHide
    if (Mimic)
        sendkeys(SingleKey, Seq++, SequenceEnabled)
    else
        sendKeys(Keys, Seq++, SequenceEnabled)
}
return

PhsListen:
Gui submit, NoHide
lastInput := 100
while (PhsEnabled)
{
    if (A_TimeIdlePhysical < lastInput) 
        sendKeys(Keys, Seq++, SequenceEnabled)
    
    lastInput := sleepSpecial(RandStart, RandEnd, RandEnabled)
    Gui submit, NoHide
}
return


PauseListen:
if IsPaused
{
   Pause off
   IsPaused := false
   GuiControl,, PauseButton, Pause
}
else
   SetTimer, Pause, 10
return

Pause:
SetTimer, Pause, off
IsPaused := true
GuiControl,, PauseButton, Unpause
Pause, on
return

HelpListen:
txtVar = 
(
Welcome to the Consortium Key Sender application. Please read the following lines, as they are important.

1. Basic use: This application gives you the possibility to redirect input to your PC to multiple applications (rather than just the active one). You could, for instance, be browsing the internet, while in the background, your World of Warcraft character is prospecting/milling/etc.

2. Important notice: It is highly recommended that you should be using this application only if you got it from the consortium.stormspire.net forums. This is for your own safety, as technically the application listens to your key presses. This means that with modifications, this could be turned into a key logger. The only way to ensure that this won't happen to you is if you download this from the official forum thread at the aforementioned site. 

3. Is this legal to use with games: the best way to ensure this is to consult with the game's ToS/EULA and/or game representatives. In the case of World of Warcraft, it has been stated multiple times that as long as there is physical input from the user (and this application cannot work without this) - you should be fine. Still, please use this application at your own risk.

4. Basic setup:

    1. Open all windows/programs you want to send input to.
    2. Run the "Consortium Key Sender"
    3. Check within the application all windows you want to send input to.
    4. Select the send method.
    5. Select what keys you want to send.
    6. You are done!
    
5. Send method descriptions:

    1. Listen to mouse - Checks if the mouse location has changed over the "Random interval" specified.
    2. Listen to keyboard - Listens for any key press on the keyboard. Note: this does not play well with some text editors, especially if they are not the active (input receiving) window.
    3. Listen to user input - Checks if over the "Random interval" specified there has been any user physical input.
    
    Note: You can select all methods if you wish to, but there is generally no reason to do so. The main difference between the methods (apart from what they respond to) is that "mouse" and "user" inputs enforce an artificial delay (you wouldn't want to spam keys for every single pixel that your mouse moves through, would you), while "keyboard" acts on one-to-one basis with your key presses on the keyboard.

    
6. Additional options:

    1. Mimic input - attempts to mimic your input from the active window, to the windows selected (rather than sending pre-defined key-strokes).
    2. Random events - apart from using the "Random interval", generates additional random events (stretches on shrinks the specified interval).
    3. Sequence send - sends the list of keys in a sequance, rather than random.
    4. Pause - pauses the script. It is also hot keyed to the Windows key + P shortcut.
    5. Refresh - checks if there are any newly opened windows.
    6. CoordSpy - helps you determine your mouse coordinates in case you want to simulate a click. Press second time to remove the tracking.
    6. Pause button - specifies what will be your pause button. Modifier keys are applicable, so for instance #p = Windows Key + p; !p = Alt +p; ^p = Ctrl + p. The pause key needs to be a single key or a modifier + key. If you try to input anything different, you will get an error message.
    7. Auto refreshes each X seconds - sends a "Refresh" command each X seconds. You are not limited to the values in the combo box! Feel free to input your own, including floating numbers (e.g. 11.353).
    8. Random interval - defines the random interval for mouse events and user input events. Impute options are same as above.
    9. Keys to send - sends the specified keys. This can be one key or a list of keys or semicolon-separated list of case. In case of the latter, a random entity of the ones listed is send. Furthermore, you can send more complex commands such as "{Shift Down}34{Shift Up}" which will hold down the Shift key, press 34 and then release the Shift key, or you could send mouse clicks by using the following syntax "mclick x300 y300" - this would reproduce a click at the respective coordinates, rative to your screen. For a complete list of possible commands please refer to http://www.autohotkey.com/docs/commands/Send.htm.
    
7. Additional notes:

    1. If no options are input a default value is used. For Auto refresh - 10 sec, for Random Interval - 2:3 sec, for Keys to send - 1, for Pause button - #p.
    
8. Currently known issues:

    1. Keyboard input does not recognize Backspace.
    2. If the remembered user preference was an already default value, it gets duplicated in the combo boxes.

)
msgbox ,,Help, %txtVar%
return

AutoRef:
Gui submit, NoHide
while (AutoEnabled)
{
    refresh(idList)
    if (secToRef="") {
        SecToRef := 10000
        GuiControl,,SecToRef,10||
    } else {
        secToRef*=1000    
    }
    sleep, SecToRef
    Gui submit, NoHide
}
return

MouseListen:
MouseGetPos , xPos , yPos
Gui submit, NoHide
while (MouseEnabled)
{
    MouseGetPos , xPosNew , yPosNew
    if (xPos <> xPosNew or yPos <> yPosNew)
    {
        sendKeys(Keys, Seq++, SequenceEnabled)
        xPos := xPosNew
        yPos := yPosNew
    }
    sleepSpecial(RandStart, RandEnd, RandEnabled)
    Gui submit, NoHide
}
return

RefreshList:
refresh(idList)
return

MyList:
GuiContextMenu:  
return

close:
guiClose:
Gui submit, NoHide
IniWrite,%SecToRef%, %A_WorkingDir%\CKSSettings.ini , 1, SecToRef
IniWrite,%RandStart%, %A_WorkingDir%\CKSSettings.ini , 1, RandStart
IniWrite,%RandEnd%, %A_WorkingDir%\CKSSettings.ini , 1, RandEnd
IniWrite,%Keys%, %A_WorkingDir%\CKSSettings.ini , 1, Keys
IniWrite,%PauseKey%, %A_WorkingDir%\CKSSettings.ini , 1, PauseKey
ExitApp

refresh(idList) {
    WinGet, id, list,,, Program Manager
    Loop, %id%
    {   
        this_id := id%A_Index%
        if (idList[this_id] = 1)
            continue
        WinGetClass, this_class, ahk_id %this_id%
        WinGetTitle, this_title, ahk_id %this_id%
        if (this_title = "" or this_title = "Start")
            continue
        LV_Add("",this_title,this_class,this_id)
        idList[this_id] := 1
    }

    Loop % LV_GetCount()
    {
        LV_GetText(win_id, A_Index,3)
        IfWinNotExist, ahk_id%win_id%
        {
            LV_Delete(a_index)
            insertList.Remove(win_id)
        }
    }
    LV_ModifyCol(1,"Auto")
    LV_ModifyCol(2,"Auto")
    LV_ModifyCol(3,"Auto")
}

sleepSpecial(RandStart, RandEnd, RandEnabled)
{
    If (RandEnd < RandStart or RandEnd ="" or RandStart="") {
        RandStart := 2000
        RandEnd := 3000
        GuiControl,,RandStart,2||
        GuiControl,,RandEnd,3||
    } else {
        RandStart *=1000
        RandEnd *=1000
    }

    if (RandEnabled) {
        Random, spec, 1, 10
        if (spec = 1) {
            randEventArr := [0.1, 0.5, 0.7, 2, 3, 4, 5]
            Random, modif, 1 ,7
            RandStart *= randEventArr[modif]
            RandEnd *= randEventArr[modif]
        }
    }
    Random, rand, RandStart, RandEnd
    sleep , rand
    return rand
}

sendKeys(Keys, Sequence, SEnabled)
{   
    if (Keys = "")
        Keys := 1
    RowNumber = 0  
    Loop
    {
        RowNumber := LV_GetNext(RowNumber,"Checked")  
        if not RowNumber  
        break
        StringSplit, keyArr, Keys, `;
        if (SEnabled) {
			rand := Mod(Sequence, KeyArr0) + 1
		} else {
			Random, rand, 1 , keyArr0
		}
        LV_GetText(win_id, RowNumber,3)
        keyToSend := keyArr%rand%
		IfInString, keyToSend, mclick
		{
			Stringmid, keyToSend, keyToSend, 8
			ControlClick, %keytoSend%, ahk_id%win_id%
		} else
			ControlSend,, %keytoSend%, ahk_id%win_id%
    }
}