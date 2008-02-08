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
	
	; Get/Set File menu item data
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData ($hMain, 0))
	_GUICtrlMenu_SetItemData ($hMain, 0, 1234)
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData ($hMain, 0))

EndFunc   ;==>_Main

; Write a line of text to Notepad
Func Writeln($sText)
	ControlSend("Untitled - Notepad", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln