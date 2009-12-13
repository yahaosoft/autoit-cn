; *******************************************************
; 例 1 - 检查_IEErrorNotify的当前状态, 如果是开启的则关闭, 如果是关闭的则开启
; *******************************************************
;
#include <IE.au3>
If _IEErrorNotify () Then
	MsgBox(0, "_IEErrorNotify的状态", "通知功能打开, 现在关闭了")
	_IEErrorNotify (False)
Else
	MsgBox(0, "_IEErrorNotify的状态", "通知功能关闭, 现在打开了")
	_IEErrorNotify (True)
EndIf