#include "..\gen_editorfuncs.au3"
#include <File.au3>

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

	; Create TextPad editor list.
	$sKeywordList = @CRLF
	$sKeywordList &= '; /////////////' & @CRLF
	$sKeywordList &= '; 1. Keywords' & @CRLF
	$sKeywordList &= '; /////////////' & @CRLF
	$sKeywordList &= '[Keywords 1]' & @CRLF

	$sMacroList = @CRLF
	$sMacroList &= '; /////////////' & @CRLF
	$sMacroList &= '; 2. Macros' & @CRLF
	$sMacroList &= '; /////////////' & @CRLF
	$sMacroList &= '[Keywords 2]' & @CRLF

	$sFunctionList = @CRLF
	$sFunctionList &= '; /////////////' & @CRLF
	$sFunctionList &= '; 3. Functions' & @CRLF
	$sFunctionList &= '; /////////////' & @CRLF
	$sFunctionList &= '[Keywords 3]' & @CRLF
	DoEditorSyntax(@ScriptDir & '\autoit_v3.syn', @ScriptDir & '\header.txt', $aKeywords, $sKeywordList, $aMacros, $sMacroList, $aFunctions, $sFunctionList)
EndFunc   ;==>GenerateSyntax
