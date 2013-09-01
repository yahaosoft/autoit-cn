#include <File.au3>
#include "gen_def.au3"
#include "..\gen_editorfuncs.au3"

GenerateSyntax()
GenerateDefSyntax() ; Included in gen_def.au3.

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

	; Create PSPAD editor list.
	$sMacroList = '[ReservedWords]' & @CRLF
	$sKeywordList = '[KeyWords]' & @CRLF
	$sFunctionList = ''
	DoEditorSyntax(@ScriptDir & '\AutoIt3.ini', @ScriptDir & '\header.txt', $aMacros, $sMacroList, $aKeywords, $sKeywordList, $aFunctions, $sFunctionList, '=')
EndFunc   ;==>GenerateSyntax
