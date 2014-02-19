#include "..\gen_editorfuncs.au3"
#include '..\..\..\..\..\_build\include\MiscLib.au3'

#include <File.au3>

GenerateSyntax()

; ------------------------------------------------------------------------------
; Automatically generate the syntax file(s).
; ------------------------------------------------------------------------------
Func GenerateSyntax()
	Local $aFunctions = 0, $aKeywords = 0, $aLibFunctions = 0, $aMacros = 0, $aSendStrings = 0, _
			$sDirectiveList = '', $sFunctionList = '', $sKeywordList = '', $sLibFunctionList = '', $sMacroList = '', $sSendStrings = ''

	_FileReadToArray($KEYWORDLIST, $aKeywords)
	_FileReadToArray($MACROLIST, $aMacros)
	_FileReadToArray($FUNCTIONLIST, $aFunctions)
	_FileReadToArray($LIBFUNCTIONLIST, $aLibFunctions)
	_FileReadToArray($SENDSTRINGLIST, $aSendStrings)

	Local Const $sHeader = @ScriptDir & '\header.txt', _
			$sOutput = @ScriptDir & '\AutoIt.tmLanguage'

	; Copy the header.txt file to the output file.
	FileCopy($sHeader, $sOutput, $FC_OVERWRITE)

	Local Const $sAppend = '|'

	; Keywords
	Local $iStringLen = StringLen('#')
	For $i = 1 To $aKeywords[0]
		If StringLeft($aKeywords[$i], $iStringLen) = '#' Then
			$sDirectiveList &= $aKeywords[$i] & $sAppend
		Else
			$sKeywordList &= $aKeywords[$i] & $sAppend
		EndIf
	Next
	; Strip #ce, #comments-end, #cs, #comments-start and #include from the directive list.
	$sDirectiveList = StringRegExpReplace($sDirectiveList, '(?:#comments-(?:end|start)\||#c(?:e|s)\||#include(?!\-once)\|)', '')
	$sDirectiveList = StringReplace($sDirectiveList, '#', '')

	; Macros
	For $i = 1 To $aMacros[0]
		$sMacroList &= $aMacros[$i] & $sAppend
	Next
	$sMacroList = StringReplace($sMacroList, '@', '')

	; Functions
	For $i = 1 To $aFunctions[0]
		$sFunctionList &= $aFunctions[$i] & $sAppend
	Next

	; LibFunctions
	For $i = 1 To $aLibFunctions[0]
		$sLibFunctionList &= $aLibFunctions[$i] & $sAppend
	Next

	; SendStrings
	For $i = 1 To $aSendStrings[0]
		$sSendStrings &= $aSendStrings[$i] & $sAppend
	Next
	$sSendStrings = StringRegExpReplace($sSendStrings, '[{}]', '')

	; Convert to lowercase and strip the last dilimiter.
	$iStringLen = StringLen('|')
	$sDirectiveList = StringTrimRight(StringLower($sDirectiveList), $iStringLen)
	$sFunctionList = StringTrimRight(StringLower($sFunctionList), $iStringLen)
	$sKeywordList = StringTrimRight(StringLower($sKeywordList), $iStringLen)
	$sLibFunctionList = StringTrimRight(StringLower($sLibFunctionList), $iStringLen)
	$sMacroList = StringTrimRight(StringLower($sMacroList), $iStringLen)
	$sSendStrings = StringTrimRight(StringLower($sSendStrings), $iStringLen)

	; Create Sublime Text editor list.
	Local $sData = FileRead($sOutput)

	$sData = StringReplace($sData, '__DIRECTIVES__', $sDirectiveList)
	$sData = StringReplace($sData, '__NATIVEFUNCTIONS__', $sFunctionList)
	$sData = StringReplace($sData, '__KEYWORDS__', $sKeywordList)
	$sData = StringReplace($sData, '__UDFFUNCTIONS__', $sLibFunctionList)
	$sData = StringReplace($sData, '__MACROS__', $sMacroList)
	$sData = StringReplace($sData, '__SENDSTRINGS__', $sSendStrings)

	Local $hFileOpen = FileOpen($sOutput, $FO_OVERWRITE)
	If $hFileOpen = -1 Then Return MsgBox($MB_SYSTEMMODAL, 'Error', 'Unable to save the syntax file.')
	FileWrite($hFileOpen, $sData)
	FileClose($hFileOpen)
EndFunc   ;==>GenerateSyntax
