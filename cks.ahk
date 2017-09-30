
 ; Copyright (c) 2017 ootsby
 ; 
 ; Permission is hereby granted, free of charge, to any person obtaining
 ; a copy of this software and associated documentation files (the
 ; "Software"), to deal in the Software without restriction, including
 ; without limitation the rights to use, copy, modify, merge, publish,
 ; distribute, sublicense, and/or sell copies of the Software, and to
 ; permit persons to whom the Software is furnished to do so, subject to
 ; the following conditions:
 ; 
 ; The above copyright notice and this permission notice shall be
 ; included in all copies or substantial portions of the Software.
 ; 
 ; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 ; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 ; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 ; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 ; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 ; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 ; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 

#Include %A_ScriptDir%\lib\AHKsock\AHKsock.ahk
#SingleInstance force
#NoEnv
#InstallKeybdHook
#InstallMouseHook
#MaxHotKeysPerInterval 10000

Gui Add, CheckBox, vMouseEnabled gMouseToggle x24 y8 w150 h20, Listen to mouse
Gui Add, CheckBox, vKbdEnabled gKbdToggle x24 y40 w171 h20, Listen to keyboard
Gui Add, CheckBox, vPhsEnabled gPhsToggle x24 y72 w170 h20, Listen to user input
Gui Add, CheckBox, vMimic gMimicToggle x216 y40 w135 h20, Mirror Keys
Gui Add, CheckBox, vSequenceEnabled x824 y78 w133 h20, Send In Sequence
Gui Add, CheckBox, vKeypressEmulationEnabled gKeypressEmuToggle x824 y98 w133 h20, Emulate KeyDown/Up
Gui Add, Button, gRefreshList x864 y152 w94 h33, Refresh
Gui Add, Text, x136 y160 w74 h20, Pause Key
Gui Add, Button, gPauseListen x24 y152 w94 h33, Pause
Gui Add, Edit, vPauseKey gPauseKeyChanged x256 y160 w79 h24, #p
Gui Add, Text, x430 y10 w123 h20, Output Interval
Gui Add, Text, cRed x560 y8 Hidden vOutputIntervalLowError, !
Gui Add, ComboBox, vOutputIntervalLow gIntervalsUpdated x568 y8 w79, 0.2|0.3|0.5|0.75|1|1.5|2|3|4|5|10
Gui Add, Text, cRed x664 y8 Hidden vOutputIntervalHighError, !
Gui Add, ComboBox, vOutputIntervalHigh gIntervalsUpdated x672 y8 w79, 0.2|0.3|0.5|0.75|1|1.5|2|3|4|5|10
Gui Add, Text, x430 y88 w96 h20, Keys to send
Gui Add, Edit, vKeys x568 y88 w235 h23, 1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1
Gui Add, ListView, vProgramList gProgramList x24 y240 w938 h469 Checked SortDesc xm, Name|Class|ID
Gui Add, CheckBox, vJoypadEnabled gJoypadToggle x24 y104 w150 h20, Listen to joypad
Gui Add, Text, x410 y50 w145 h20, KeyPress Length
Gui Add, Text, cRed x560 y48 Hidden vKeypressLengthLowError, !
Gui Add, ComboBox, vKeypressLengthLow gIntervalsUpdated x568 y48 w79, 0.1|0.2|0.3|0.4|0.5|0.6|0.7|0.8|0.9|1.0
Gui Add, Text, cRed x664 y48 Hidden vKeypressLengthHighError, !
Gui Add, ComboBox, vKeypressLengthHigh gIntervalsUpdated x672 y48 w79, 0.1|0.2|0.3|0.4|0.5|0.6|0.7|0.8|0.9|1.0
Gui Add, Edit, vServerPort gServerPortUpdated x520 y160 w72 h21, 27001
Gui Add, Text, x512 y128 w80 h24 +0x200, Server Port
Gui Add, CheckBox, vServerModeEnabled gServerModeUpdated x608 y160 w120 h23, Act As Server
Gui Add, Button, vConnectText gConnectButton x744 y160 w83 h24, Connect
Gui Add, Text, x368 y128 w80 h23 +0x200, Server IP
Gui Add, Edit, vServerIP gServerIPUpdated x368 y160 w120 h21, %A_IPAddress1%
Gui Add, Button, gApplyIntervals vApplyIntervals x792 y16 w80 h39 Disabled, Apply Intervals
Gui Add, Text, vAppStatus x24 y200 w935 h23 +0x200 Center, Status Line

--Gui, Add, ListView, vProgramList gProgramList w600 h300 Checked SortDesc xm, Name|Class|ID
Menu, FileMenu, Add, LoadProfile(inactive), MenuHandler
Menu, FileMenu, Add, SaveProfile(inactive), MenuHandler
Menu, HelpMenu, Add, Usage, HelpListen
Menu, HelpMenu, Add, About, AboutBox
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar

CoordMode, Mouse, Screen
if A_IsCompiled
  Menu, Tray, Icon, %A_ScriptFullPath%, -159

IniRead, SecToRefTemp, CKSSettings.ini, 1, SecToRef, 10
IniRead, RealOutputIntervalLow, CKSSettings.ini, 1, OutputIntervalLow, 0.5
IniRead, RealOutputIntervalHigh, CKSSettings.ini, 1, OutputIntervalHigh, 1.0
IniRead, RealKeypressLengthLow, CKSSettings.ini, 1, KeypressLengthLow, 0.3
IniRead, RealKeypressLengthHigh, CKSSettings.ini, 1, KeypressLengthHigh, 0.6
IniRead, KeypressEmulationEnabled, CKSSettings.ini, 1, KeypressEmulationEnabled, 0
IniRead, KeysTemp, CKSSettings.ini, 1, Keys, %A_Space%
IniRead, PauseKeyTemp, CKSSettings.ini , 1, PauseKey, #p


if( !FileExist("CKS-E_Defaults.ini")  ){
    MsgBox,, First Time Use, It looks like you're using CKS-E for the first time. Setting some defaults. Please read the help to get started."
}

GuiControl,, SecToRef, %SecToRefTemp%||
GuiControl,, OutputIntervalLow, %RealOutputIntervalLow%||
GuiControl,, OutputIntervalHigh, %RealOutputIntervalHigh%||
GuiControl,, KeypressLengthLow, %RealKeypressLengthLow%||
GuiControl,, KeypressLengthHigh, %RealKeypressLengthHigh%||
GuiControl,, KeypressLengthHigh, %RealKeypressLengthHigh%||
GuiControl,, Keys, %KeysTemp%
GuiControl,, PauseKey, %PauseKeyTemp%

;Set up an error handler (this is optional)
AHKsock_ErrorHandler("AHKsockErrors")
    
;Set up an OnExit routine
;OnExit, GuiClose

;Set default value to invalid handle
iPeerSocket := -1


idList := object()
Refresh(idList)
OldPause := PauseKeyTemp
Hotkey, %PauseKeyTemp%, PauseListen
Seq := 0
Timer := 0
NextAllowedOutputTime := 0
IsListening := False
IsConnected := False
IsConnecting := False
clientSocket := -1
windowName := "CKS-E"
Gui, Show,, %windowName%
Gui, Submit, NoHide
Return


GuiClose(){
    
    ;So that we don't go back to listening on disconnect
    bExiting := True
    
    /*! If the GUI is closed, this function will be called twice:
        - Once non-critically when the GUI event fires (GuiEscape or GuiClose) (graceful shutdown will occur), and
        - Once more critically during the OnExit sub (after the previous GUI event calls ExitApp)
        
        But if the application is exited using the Exit item in the tray's menu, graceful shutdown will be impossible
        because AHKsock_Close() will only be called once critically during the OnExit sub.
    */
    AHKsock_Close()
	FinaliseAndExit()
	ExitApp
}

MenuHandler(){
	Return
}

PauseKeyChanged(){
	Gui submit, NoHide
	if (OldPause = PauseKey)
		Return

	if (OldPause != "") {
		Hotkey, %OldPause%, Off
	}

	if (PauseKey = "" )
		Return

	Hotkey, %PauseKey%, PauseListen
	OldPause := PauseKey
	Return
}

CoordsListen(){
	if (Timer) {
		Settimer WatchCursor, off
		Tooltip
		Timer:=0
	} else {
		Settimer WatchCursor, 50
		Timer:=1
	}
	Return
}

WatchCursor(){
	MouseGetPos , mouseX, mouseY
	ToolTip, %mouseX% %mouseY%
	Return
}

KbdToggle(){
	Global KbdEnabled
	
	Gui, Submit, NoHide
	
	if( KbdEnabled ){
		SetTimer, KbdListen, -0
	}
	Return
}

KeypressEmuToggle(){
	Gui, Submit, NoHide
}

MimicToggle(){
	Gui, Submit, NoHide
}

KbdListen(){
	Global
	
	while (KbdEnabled)
	{
		Input, SingleKey, L1 V,  {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Backspace}{Capslock}{Numlock}{PrintScreen}{Pause}
		
		if (Mimic)
			sendkeys(SingleKey, Seq++, SequenceEnabled)
		else
			sendKeys(Keys, Seq++, SequenceEnabled)
	}
	Return
}

PhsToggle(){
	Global PhsEnabled
	
	Gui, Submit, NoHide
	
	if( PhsEnabled ){
		SetTimer, PhsListen, -0
	}
	Return
}

PhsListen(){
	Global PhsEnabled
	
	DetectPeriod := 50
	
	while (PhsEnabled)
	{
		if (A_TimeIdlePhysical < DetectPeriod){ 
			doSend()
		}
		Sleep, DetectPeriod
	}
	Return
}

PauseListen(){
	Global
	if IsPaused
	{
	   Pause off
	   IsPaused := false
	   GuiControl,, PauseButton, Pause
	}
	else
	   SetTimer, OnPause, 10
	Return
}

OnPause(){
	Global
	SetTimer, OnPause, off
	IsPaused := true
	GuiControl,, PauseButton, Unpause
	Pause, on
	Return
}

AboutBox(){
	txtVar := "CKS-E is a tool for duplicating or remapping user input and sending it to one or more applications on your PC. For example, CKS-E could allow you to send a key to perform repetitive crafting actions on an MMO character when you move your mouse while photo-editing or for each key you press while you type a report. CKS-E is based on the Consortium Key Sender by Pliaksi as originally published on the Consortium Gold Forums."
	msgbox ,,Help, %txtVar%
	Return
}

HelpListen(){
	txtVar := "Fill in usage info here"
	msgbox ,,Help, %txtVar%
	Return
}

AutoRef(){
	
	Global idList, AutoEnabled, SecToRef
	
	while (AutoEnabled){
		Refresh(idList)
		if (secToRef="") {
			SecToRef := 10000
			GuiControl,,SecToRef,10||
		} else {
			secToRef*=1000    
		}
		sleep, SecToRef
	}
	Return
}

JoyPadToggle(){
}

MouseToggle(){
	Global MouseEnabled
	
	Gui, Submit, NoHide
	
	if( MouseEnabled ){
		SetTimer, MouseListen, -0
	}
	Return
}

OnMouseInput(){
	Global IsPaused, MouseEnabled
	
	if( !IsPaused and MouseEnabled ){
		doSend()
	}
	Return
}

$~WheelUp::
	OnMouseInput()
Return

$~WheelDown::
	OnMouseInput()
Return

MouseListen(){
	Global MouseEnabled
	
	MouseGetPos, xPos, yPos
	
	while( MouseEnabled ){
	
		MouseGetPos, xPosNew, yPosNew
		
		if (xPos <> xPosNew or yPos <> yPosNew){
			xPos := xPosNew
			yPos := yPosNew
			OnMouseInput()
		}else{
			Sleep, 50
		}
	}
}

RefreshList(){
	Global idList
	Refresh(idList)
	Return
}

ProgramList(){
}

GuiContextMenu(){  
}

IsCheckboxStyle(style)
{
	static types := [ "Button"        ;BS_PUSHBUTTON
                  , "Button"        ;BS_DEFPUSHBUTTON
                  , "Checkbox"      ;BS_CHECKBOX
                  , "Checkbox"      ;BS_AUTOCHECKBOX
                  , "Radio"         ;BS_RADIOBUTTON
                  , "Checkbox"      ;BS_3STATE
                  , "Checkbox"      ;BS_AUTO3STATE
                  , "Groupbox"      ;BS_GROUPBOX
                  , "NotUsed"       ;BS_USERBUTTON
                  , "Radio"         ;BS_AUTORADIOBUTTON
                  , "Button"        ;BS_PUSHBOX
                  , "AppSpecific"   ;BS_OWNERDRAW
                  , "SplitButton"   ;BS_SPLITBUTTON    (vista+)
                  , "SplitButton"   ;BS_DEFSPLITBUTTON (vista+)
                  , "CommandLink"   ;BS_COMMANDLINK    (vista+)
                  , "CommandLink"]  ;BS_DEFCOMMANDLINK (vista+)

	If( types[1+(style & 0xF)] = "Checkbox" )
		Return True
	
	Return False	
}

SaveConfig()
{
	Global
	HWND := WinExist(windowName)
	WinGet, ctlList, ControlList, ahk_id %HWND%
	Loop, Parse, ctlList,`n 
	{
		isCheckbox := False
		
		If( inStr(a_LoopField,"Button") ){
			ControlGet, styleFlags, Style, , %a_LoopField%
			isCheckBox := IsCheckboxStyle(styleFlags)
		}
		
		If( inStr(a_LoopField,"Edit") or isCheckbox ){
			
			GuiControlGet, varName, Name, %a_LoopField%
							
			GuiControlGet, controlValue, , %varName%
			IniWrite, %controlValue%, test.ini , 1, %varName%
			
		}
	}
}

Close(){
	FinaliseAndExit()
}

FinaliseAndExit(){
	Global
	Gui submit, NoHide
	SaveConfig()
	IniWrite, %SecToRef%, CKSSettings.ini , 1, SecToRef
	IniWrite, %RealOutputIntervalLow%, CKSSettings.ini , 1, OutputIntervalLow
	IniWrite, %RealOutputIntervalHigh%, CKSSettings.ini , 1, OutputIntervalHigh
	IniWrite, %RealKeypressLengthLow%, CKSSettings.ini , 1, KeypressLengthLow
	IniWrite, %RealKeypressLengthHigh%, CKSSettings.ini , 1, KeypressLengthHigh
	IniWrite, %Keys%, CKSSettings.ini , 1, Keys
	IniWrite, %PauseKey%, CKSSettings.ini , 1, PauseKey
	ExitApp
}

doSend(){
	Global Keys, Seq, SequenceEnabled, RealOutputIntervalLow, RealOutputIntervalHigh, RandEnabled, NextAllowedOutputTime
	
	If( A_TickCount >= NextAllowedOutputTime ){
		sendKeys(Keys, Seq++, SequenceEnabled)
		sleepSpecial(RealOutputIntervalLow, RealOutputIntervalHigh, RandEnabled)
	}
}

Refresh(idList) {
	
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

sleepSpecial(OutputIntervalLow, OutputIntervalHigh, RandEnabled){
	
	Global NextAllowedOutputTime
	
    If (OutputIntervalHigh < OutputIntervalLow or OutputIntervalHigh ="" or OutputIntervalLow="") {
        OutputIntervalLow := 2000
        OutputIntervalHigh := 3000
        GuiControl,,OutputIntervalLow,2||
        GuiControl,,OutputIntervalHigh,3||
    } else {
        OutputIntervalLow *=1000
        OutputIntervalHigh *=1000
    }

    Random, rand, OutputIntervalLow, OutputIntervalHigh
    NextAllowedOutputTime := A_TickCount + rand
    Return rand
}

sendKeys(Keys, Sequence, SEnabled){
	Global IsConnected,clientSocket, RealKeypressLengthHigh, RealKeypressLengthLow, KeypressEmulationEnabled
	
	If( IsConnected ){
		dummyData := 1
		err := AHKsock_ForceSend(clientSocket, &dummyData, 1)
		if( err ){
			GuiControl,, AppStatus, Error sending keys - code = %err%
		}else{
			FormatTime, TimeString, T12, Time
			GuiControl,, AppStatus, Client sent key command at %TimeString%
		}
	}
	
    if (Keys = "")
        Keys := 1
    RowNumber := 0  
	
	StringSplit, KeyArr, Keys, `;

	if (SEnabled) {
		rand := Mod(Sequence, KeyArr0) + 1
	} else {
		Random, rand, 1 , KeyArr0
	}

    keyToSend := keyArr%rand%	
	
	; Send key to all checked applications
    Loop{
        RowNumber := LV_GetNext(RowNumber,"Checked")  
        if not RowNumber  
        break
        
        LV_GetText(win_id, RowNumber,3)

		IfInString, keyToSend, mclick
		{
			Stringmid, keyToSend, keyToSend, 8
			ControlClick, %keytoSend%, ahk_id%win_id%
		} else{
			If( KeypressEmulationEnabled ){
				ControlSend,, {%keytoSend% down}, ahk_id%win_id%
			}Else{
				ControlSend,, {%keytoSend%}, ahk_id%win_id%
			}
		}
	}
	
	; If keypress emulation is enabled then sleep and then send the key up even to each checked application
	If( KeypressEmulationEnabled ){
		Random, rand, RealKeypressLengthLow*1000, RealKeypressLengthHigh*1000
		Sleep, rand
		Loop{
			RowNumber := LV_GetNext(RowNumber,"Checked")  
			if not RowNumber  
				break
			ControlSend,, {%keytoSend% up}, ahk_id%win_id%
		}
	}
}

HandleAsServer(sEvent, iSocket = 0, sName = 0, sAddr = 0, sPort = 0, ByRef bData = 0, bDataLength = 0) {
    Global

	If (sEvent = "ACCEPTED") {
		GuiControl,, AppStatus, Client connected from %sAddr%...
        OutputDebug, % "A client with IP " sAddr " connected!"
		return
	}
	
	If( sEvent = "RECEIVED"){
		FormatTime, TimeString, T12, Time
		GuiControl,, AppStatus, Received press request. Firing keys at %TimeString%
		doSend()
		return
	}
	
	GuiControl,, AppStatus, Server received event %sEvent%... ;Update status
}

HandleAsClient(sEvent, iSocket = 0, sName = 0, sAddr = 0, sPort = 0, ByRef bData = 0, bDataLength = 0) {
	Global
	
	If (sEvent = "CONNECTED") {
		IsConnecting := False
		If (iSocket = -1) {
			GuiControl ,, ConnectText, Connect
			GuiControl,, AppStatus, Client connect failed...
		}Else{
			GuiControl,, AppStatus, Client connect success... socket = %iSocket%  
			IsConnected := True
		}
		clientSocket := iSocket
		
		return
	}

	If (sEvent = "DISCONNECTED") {
		clientSocket := -1
		IsConnected := False
		GuiControl,, AppStatus, Client disconnected...
		return
	}
	If( sEvent = "SEND"){
		return
	}
	GuiControl,, AppStatus, Client received event %sEvent%...     
}

DisableServerOptions(){
}

EnableServerOptions(){
}

ConnectButton(){
	GuiControlGet, ConnectText
	If( ConnectText = "Connect" or ConnectText = "Disconnect" ){
		Connect()
	}else{
		Listen()
	}
}

Connect(){
	Global
	
	If( !IsConnected && !IsConnecting ){
		GuiControl,, AppStatus, Trying to connect to %serverIP%... ;Update status
    	If( err := AHKsock_Connect(serverIP, serverPort, "HandleAsClient") ){
			GuiControl,, AppStatus, AHKsock_Connect() failed with return value = %err% and ErrorLevel = %ErrorLevel%
			OutputDebug, % "AHKsock_Connect() failed with return value = " err " and ErrorLevel = " ErrorLevel
			EnableServerOptions()
			GuiControl ,, ConnectText, Connect
		}else{
			DisableServerOptions()
			GuiControl ,, ConnectText, Disconnect
			IsConnecting := True
		}
	}else{
		AHKsock_Close(clientSocket)
		IsConnected := False
		IsConnecting := False
		clientSocket := -1
		GuiControl,, AppStatus, Disconnected ;Update status
	}	
}

Listen(){
	Global
	if( !IsListening ){
		If( err := AHKsock_Listen(serverPort, "HandleAsServer") ){
			OutputDebug, % "AHKsock_Listen() failed with return value = " err " and ErrorLevel = " ErrorLevel
			GuiControl,, AppStatus, Listen failed with return value = %err%... ;Update status
			EnableServerOptions()
			GuiControl ,, ConnectText, Listen
		}else{
			DisableServerOptions()
			GuiControl ,, ConnectText, StopListening
			GuiControl,, AppStatus, Listening for connection on %serverPort%... ;Update status
			IsListening := True
		}
	}else{
		GuiControl,, AppStatus, Stopped Listening... ;Update status
		EnableServerOptions()
		GuiControl ,, ConnectText, Listen
		AHKsock_Listen(serverPort)
		IsListening := False
	}
}

AHKsockErrors(iError, iSocket) {
	Global
    GuiControl,, AppStatus, Client - Error %iError% with error code = %ErrorLevel%
}

ServerModeUpdated(){
	Global
	Gui submit, NoHide
	if( ServerModeEnabled ){
		GuiControl ,, Connect, &Listen
	}else{
		GuiControl ,, Connect, &Connect
	}
}

ServerPortUpdated(){
	Gui Submit, NoHide
}

ServerIPUpdated(){
	Gui Submit, NoHide
}


ApplyIntervals(){
	Global
	Gui submit, NoHide
	
	GuiControlGet, RealKeypressLengthLow, ,KeypressLengthLow
	GuiControlGet, RealKeypressLengthHigh, ,KeypressLengthHigh
	GuiControlGet, RealOutputIntervalLow, ,OutputIntervalLow
	GuiControlGet, RealOutputIntervalHigh, ,OutputIntervalHigh
	
	GuiControl, Disable, ApplyIntervals 
}


IntervalsUpdated(){
	Global
	Gui submit, NoHide
	
	GuiControlGet, KPIL,,KeypressLengthLow
	GuiControlGet, KPIH,,KeypressLengthHigh
	GuiControlGet, OIL,,OutputIntervalLow
	GuiControlGet, OIH,,OutputIntervalHigh
	
	KPILError := False
	KPIHError := False
	OILError := False
	OIHError := False
	
	; It took hours to discover that these checks weren't working because the "Is" keyword doesn't work in if statements
	; with brackets. I'm never touching this half-arsed bumblefuck hack-job of a language again once this is done.
	
	If KPIL Is Not Number
		KPILError := True
	
	If KPIH Is Not Number
		KPIHError := True
	
	
	If( Not(KPILError Or KPIHError) And KPIL > KPIH ){
		KPIHError := True
		KPILError := True
	}
	
	If OIL Is Not Number
		OILError := True
	
	If OIH Is Not Number
		OIHError := True
	

	If( Not(OILError Or OIHError) And OIL > OIH ){
		OILError := True
		OIHError := True
	}
	
	if( OILError ){ 
		GuiControl Show, OutputIntervalLowError
	}else{
		GuiControl Hide, OutputIntervalLowError
	}
	if( OIHError ){
		GuiControl Show, OutputIntervalHighError
	}else{
		GuiControl Hide, OutputIntervalHighError
	}
	if( KPILError ){
		GuiControl Show, KeypressLengthLowError
	}else{
		GuiControl Hide, KeypressLengthLowError
	}
	if( KPIHError ){
		GuiControl Show, KeypressLengthHighError
	}else{
		GuiControl Hide, KeypressLengthHighError
	}
	
	If( KPIHError Or KPILError Or OILError Or OIHError ){
		GuiControl, Disable, ApplyIntervals 
	}Else{
		GuiControl, Enable, ApplyIntervals 
	}
}