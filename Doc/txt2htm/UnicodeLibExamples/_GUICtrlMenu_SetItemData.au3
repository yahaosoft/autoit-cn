#include <GuiMenu.au3>

_Main()

Func _Main()
	Local $hWnd, $hMain

	; 打开记事本
	Run("Notepad.exe")
	WinWaitActive("[CLASS:Notepad]")
	$hWnd = WinGetHandle("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($hWnd)

	; 获取/设置文件菜单项数据
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData($hMain, 0))
	_GUICtrlMenu_SetItemData($hMain, 0, 1234)
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData($hMain, 0))

EndFunc   ;==>_Main

; 写入一行文本到记事本
Func Writeln($sText)
	ControlSend("[CLASS:Notepad]", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln
