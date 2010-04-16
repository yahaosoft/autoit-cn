; *******************************************************
; 示例 1 - 注册自定义的错误句柄, 然后注销自定义的错误句柄.
; *******************************************************

#include <Word.au3>
; 注册自定义的错误句柄
_WordErrorHandlerRegister ("MyErrFunc")

; 注销自定义的错误句柄
_WordErrorHandlerDeregister ()

Exit

Func MyErrFunc()
	$HexNumber = Hex($oWordErrorHandler.number, 8)
	MsgBox(0, "", "We intercepted a COM Error !" & @CRLF & _
			"Number is: " & $HexNumber & @CRLF & _
			"Windescription is: " & $oWordErrorHandler.windescription)
	SetError(1) ; 函数返回时检查
EndFunc   ;==>MyErrFunc