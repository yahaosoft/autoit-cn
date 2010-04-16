; *******************************************************
; 例 1 - 注册然后注销一个自定义和默认的IE.au3错误处理程序
; *******************************************************
;
#include <IE.au3>
; 注册自定义错误处理程序
_IEErrorHandlerRegister ("MyErrFunc")
; 进行一些操作
; 注销自定义错误处理程序
_IEErrorHandlerDeregister ()
; 进行另一些操作
; 注册默认IE.au3 COM错误处理程序
_IEErrorHandlerRegister ()
; 进行更多操作

Exit

Func MyErrFunc()
	; 重要: 错误对象变量必须命名为$oIEErrorHandler
	$ErrorScriptline = $oIEErrorHandler.scriptline
	$ErrorNumber = $oIEErrorHandler.number
	$ErrorNumberHex = Hex($oIEErrorHandler.number, 8)
	$ErrorDescription = StringStripWS($oIEErrorHandler.description, 2)
	$ErrorWinDescription = StringStripWS($oIEErrorHandler.WinDescription, 2)
	$ErrorSource = $oIEErrorHandler.Source
	$ErrorHelpFile = $oIEErrorHandler.HelpFile
	$ErrorHelpContext = $oIEErrorHandler.HelpContext
	$ErrorLastDllError = $oIEErrorHandler.LastDllError
	$ErrorOutput = ""
	$ErrorOutput &= "--> COM错误发生在" & @ScriptName & @CR
	$ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
	$ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
	$ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
	$ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
	$ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
	$ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
	$ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
	$ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
	$ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
	MsgBox(0,"COM错误", $ErrorOutput)
	SetError(1)
	Return
EndFunc  ;==>MyErrFunc