; *******************************************************
; 示例 1 - 注册一个自定义的和默认的 Word.au3 错误句柄, 然后注销
; *******************************************************
;
#include <Word.au3>
; 注册自定义的错误句柄
_WordErrorHandlerRegister ("MyErrFunc")
; 注销自定义的错误句柄
_WordErrorHandlerDeregister ()

; 注册默认的 IE.au3 COM 错误句柄
_WordErrorHandlerRegister ()


Exit

Func MyErrFunc()
	;重要：错误对象变量必须命名为 $oWordErrorHandler
	$ErrorScriptline = $oWordErrorHandler.scriptline
	$ErrorNumber = $oWordErrorHandler.number
	$ErrorNumberHex = Hex($oWordErrorHandler.number, 8)
	$ErrorDescription = StringStripWS($oWordErrorHandler.description, 2)
	$ErrorWinDescription = StringStripWS($oWordErrorHandler.WinDescription, 2)
	$ErrorSource = $oWordErrorHandler.Source
	$ErrorHelpFile = $oWordErrorHandler.HelpFile
	$ErrorHelpContext = $oWordErrorHandler.HelpContext
	$ErrorLastDllError = $oWordErrorHandler.LastDllError
	$ErrorOutput = ""
	$ErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
	$ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
	$ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
	$ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
	$ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
	$ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
	$ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
	$ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
	$ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
	MsgBox(0, "COM Error", $ErrorOutput)
	SetError(1)
	Return
EndFunc   ;==>MyErrFunc