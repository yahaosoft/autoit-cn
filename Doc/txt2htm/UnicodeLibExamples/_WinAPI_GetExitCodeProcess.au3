#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)

Global $PID, $hProcess

; _WinAPI_CreateProcess() 将是最好的解决方式
$PID = Run('cmd.exe /k')
If Not $PID Then
	Exit
EndIf

; 注意, 马上打开进程
If _WinAPI_GetVersion() >= 6.0 Then
	$hProcess = _WinAPI_OpenProcess(0x1000, 0, $PID) ; PROCESS_QUERY_LIMITED_INFORMATION
Else
	$hProcess = _WinAPI_OpenProcess(0x0400, 0, $PID) ; PROCESS_QUERY_INFORMATION
EndIf
If Not $hProcess Then
	Exit
EndIf

; 等待直到进程退出, 尝试输入 "exit 6"
While ProcessExists($PID)
	Sleep(100)
WEnd

ConsoleWrite('Exit code: ' & _WinAPI_GetExitCodeProcess($hProcess) & @CR)

_WinAPI_CloseHandle($hProcess)
