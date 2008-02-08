#include <GuiMenu.au3>

Opt('MustDeclareVars', 1)

_Main()

Func _Main()
	Local $hWnd, $hMain, $hFile

	; Open Notepad
	Run("Notepad.exe")
	WinWaitActive("Untitled - Notepad")
	$hWnd = WinGetHandle("Untitled - Notepad")
	$hMain = _GUICtrlMenu_GetMenu ($hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu ($hMain, 0)

	; Change Open item type
	Writeln("Open item type: 0x" & Hex(_GUICtrlMenu_GetItemType ($hFile, 1)))
	_GUICtrlMenu_SetItemType ($hFile, 1, $MFT_RADIOCHECK)
	_GUICtrlMenu_CheckRadioItem ($hFile, 0, 8, 1)
	Writeln("Open item type: 0x" & Hex(_GUICtrlMenu_GetItemType ($hFile, 1)))

EndFunc   ;==>_Main

; Write a line of text to Notepad
Func Writeln($sText)
	ControlSend("Untitled - Notepad", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln