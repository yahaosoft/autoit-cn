
; 产生回叫函数
$handle = DLLCallbackRegister ("_EnumWindowsProc", "int", "hwnd;lparam")     

; 调用 EnumWindows
DllCall("user32.dll", "int", "EnumWindows", "ptr", DllCallbackGetPtr($handle), "lparam", 10)

; 删除回叫函数
DllCallbackFree($handle)

; 回叫过程
Func _EnumWindowsProc($hWnd, $lParam)
	If WinGetTitle($hWnd) <> "" And BitAnd(WinGetState($hWnd), 2) Then
		$res = MsgBox(1, WinGetTitle($hWnd), "句柄=" & $hWnd & @CRLF & "参量=" & $lParam & @CRLF & "句柄(类型)=" & VarGetType($hWnd))
		If $res = 2 Then Return 0	; 单击"取消", 返回 0 停止枚举
	EndIf
	Return 1	; 返回 1 继续枚举
EndFunc
