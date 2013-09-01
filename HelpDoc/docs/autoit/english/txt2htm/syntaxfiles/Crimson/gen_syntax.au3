#include <File.au3>
#include "..\gen_editorfuncs.au3"

GenerateSyntax()

; ------------------------------------------------------------------------------
; Automatically generate the syntax file(s).
; ------------------------------------------------------------------------------
Func GenerateSyntax()
	Local $aFunctions = 0, $aKeywords = 0, $aLibFunctions = 0, $aMacros = 0, _
			$sFunctionList = '', $sKeywordList = '', $sMacroList = ''

	_FileReadToArray($KEYWORDLIST, $aKeywords)
	_FileReadToArray($MACROLIST, $aMacros)
	_FileReadToArray($FUNCTIONLIST, $aFunctions)
	_FileReadToArray($LIBFUNCTIONLIST, $aLibFunctions)
	CombineFunctionArray($aFunctions, $aLibFunctions)

	; Create Crimson editor list.
	$sKeywordList = @CRLF
	$sKeywordList &= '[KEYWORDS0:GLOBAL]' & @CRLF
	$sKeywordList &= '# AutoIt Keyword/Statement Reference' & @CRLF

	$sMacroList = @CRLF
	$sMacroList &= '[KEYWORDS3:GLOBAL]' & @CRLF
	$sMacroList &= '# AutoIt Macro Variables' & @CRLF

	$sFunctionList = @CRLF
	$sFunctionList &= '[KEYWORDS6:GLOBAL]' & @CRLF
	$sFunctionList &= '# AutoIt "Function Reference"' & @CRLF
	DoEditorSyntax(@ScriptDir & '\autoit3.key', @ScriptDir & '\header.txt', $aKeywords, $sKeywordList, $aMacros, $sMacroList, $aFunctions, $sFunctionList)
EndFunc   ;==>GenerateSyntax
