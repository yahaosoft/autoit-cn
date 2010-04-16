#include <GuiConstantsEx.au3>

Opt("GuiOnEventMode",1)

GuiCreate("Custom Msgbox", 210, 80)

$YesID  = GuiCtrlCreateButton("ÊÇ", 10, 50, 50, 20)
GUICtrlSetOnEvent(-1,"OnYes")
$NoID   = GuiCtrlCreateButton("·ñ", 80, 50, 50, 20)
GUICtrlSetOnEvent(-1,"OnNo")
$ExitID = GuiCtrlCreateButton("ÍË³ö", 150, 50, 50, 20)
GUICtrlSetOnEvent(-1,"OnExit")

GUISetOnEvent($GUI_EVENT_CLOSE,"OnExit")

GuiSetState()  ; display the GUI

While 1
   Sleep (10)
WEnd

;--------------- Functions ---------------
Func OnYes()
	MsgBox(0,"You clicked on", "Yes")
EndFunc

Func OnNo()
	MsgBox(0,"You clicked on", "No")
EndFunc

Func OnExit()
	if @Gui_CtrlId = $ExitId Then
		MsgBox(0,"You clicked on", "Exit")
	Else
		MsgBox(0,"You clicked on", "Close")
	EndIf

	Exit
EndFunc
