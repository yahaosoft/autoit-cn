; *******************************************************
; 例 1 - 注册然后注销一个自定义错误句柄
; *******************************************************
;
#include <IE.au3>
; 注册自定义错误处理程序
_IEErrorHandlerRegister ("MyErrFunc")
; 进行一些操作
; 注销自定义错误处理程序
_IEErrorHandlerDeregister ()
; 进行另一些操作

Exit

Func MyErrFunc()
	$HexNumber = Hex($oIEErrorHandler.number, 8)
	MsgBox(0, "", "我们拦截了一个COM错误!" & @CRLF & _
			"错误码是: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oIEErrorHandler.windescription) 
	SetError(1) ; 为函数返回检查的一些事件
EndFunc   ;==>MyErrFunc