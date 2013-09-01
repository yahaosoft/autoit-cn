#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir") & "\icons\filetype1.ico"

	GUICreate("My GUI new icon") ; will create a dialog box that when displayed is centered

	GUISetIcon($sFile) ; will change icon

	GUISetState(); will display an empty dialog box

	; Run the GUI until the dialog is closed
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete()
EndFunc   ;==>Example
