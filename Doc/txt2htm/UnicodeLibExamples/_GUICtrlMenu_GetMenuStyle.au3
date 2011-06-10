#include <GuiMenu.au3>

_Main()

Func _Main()
	Local $hWnd, $hMain, $hFile

	; 打开记事本
	Run("Notepad.exe")
	WinWaitActive("[CLASS:Notepad]")
	$hWnd = WinGetHandle("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)

	; 获取/设置文件菜单样式
	Writeln("File menu style: 0x" & Hex(_GUICtrlMenu_GetMenuStyle($hFile)))
	_GUICtrlMenu_SetMenuStyle($hFile, $MNS_NOCHECK)
	Writeln("File menu style: 0x" & Hex(_GUICtrlMenu_GetMenuStyle($hFile)))

EndFunc   ;==>_Main

; 写入一行文本到记事本
Func Writeln($sText)
	ControlSend("[CLASS:Notepad]", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln
