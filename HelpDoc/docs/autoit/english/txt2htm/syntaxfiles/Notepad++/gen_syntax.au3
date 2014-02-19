#include "..\..\..\..\..\_build\include\MiscLib.au3"
#include "..\gen_editorfuncs.au3"
#include <File.au3>

Global Const $ASCII_ACK = Chr(6), _
		$FUNCTIONLIST_FULL = '..\function_full.txt', _
		$LIBFUNCTIONLIST_FULL = '..\libfunctions_full.txt'

GenerateSyntax()

; ------------------------------------------------------------------------------
; Automatically generate the syntax file(s).
; ------------------------------------------------------------------------------
Func GenerateSyntax()
	Local $aFunctions = 0, $aLibFunctions = 0

	; Create Notepad++ keyword & macro list.
	Local $sKeywordAndMacroList = GetKeywordsAndMacros()

	; Create Notepad++ editor list.
	Local $sFunctionList = GetFunctions()

	$sFunctionList = "<?xml version='1.0' encoding='Windows-1252' ?>" & @CRLF & _
			"<NotepadPlus>" & @CRLF & _
			@TAB & "<AutoComplete language='AutoIt'>" & @CRLF & _
			@TAB & @TAB & "<Environment ignoreCase='yes' startFunc='(' stopFunc=')' paramSeparator=',' terminal='' />" & @CRLF & _
			$sKeywordAndMacroList & _
			$sFunctionList & _
			@TAB & "</AutoComplete>" & @CRLF & _
			"</NotepadPlus>"

	Local $hFileOpen = FileOpen(@ScriptDir & '\autoit.xml', $FO_OVERWRITE)
	FileWriteLine($hFileOpen, $sFunctionList)
	FileClose($hFileOpen)
EndFunc   ;==>GenerateSyntax

; ------------------------------------------------------------------------------
; Retrieve the keywords and macros.
; ------------------------------------------------------------------------------
Func GetKeywordsAndMacros()
	Local $sData = FileRead($KEYWORDLIST) & FileRead($MACROLIST)
	Local $aKeywordsAndMacros = StringSplit($sData, @CRLF, $STR_ENTIRESPLIT)
	Local $sKeywordAndMacroList = ''
	For $i = 1 To $aKeywordsAndMacros[0]
		$sKeywordAndMacroList &= @TAB & @TAB & "<KeyWord name='" & $aKeywordsAndMacros[$i] & "' />" & @CRLF
	Next
	Return $sKeywordAndMacroList
EndFunc   ;==>GetKeywordsAndMacros

; ------------------------------------------------------------------------------
; Retrieve the functions, syntax and description.
; ------------------------------------------------------------------------------
Func GetFunctions()
	Local $sData = FileRead($FUNCTIONLIST_FULL) & $ASCII_ACK & @CRLF & FileRead($LIBFUNCTIONLIST_FULL) & @CRLF
	Local $aFunctions = StringSplit($sData, $ASCII_ACK), $aSplit = 0, _
			$sDescription = '', $sFunctionName = '', $sFunctionList = '', $sParamList = ''

	For $i = 1 To $aFunctions[0] Step 3
		$sFunctionName = $aFunctions[$i]

		$sParamList = StringStripWS($aFunctions[$i + 1], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
		_ConvertSymbolsToHTMLEntity($sParamList)
		$aSplit = StringRegExp($sParamList, '\w+\h*\((.*?)\h*\)', 3)
		If UBound($aSplit) Then $sParamList = $aSplit[0]

		$sDescription = $aFunctions[$i + 2]
		_ConvertSymbolsToHTMLEntity($sDescription)
		$sDescription = InsertLineBreak($sDescription)
		; Quick workaround.
		; $sDescription = StringReplace($sDescription,  ' &#x0a; ', '&#x0a;')
		$sDescription = StringStripWS($sDescription, $STR_STRIPSPACES)

		$sFunctionName = StringStripWS($sFunctionName, $STR_STRIPALL)
		$sFunctionList &= @TAB & @TAB & "<KeyWord name='" & $sFunctionName & "' func='yes' >" & @CRLF
		$sFunctionList &= @TAB & @TAB & @TAB & "<Overload retVal='' descr='" & $sDescription & "' " & ($sParamList ? "" : "/") & ">" & @CRLF

		If $sParamList Then
			$aSplit = StringSplit($sParamList, ',')
			For $j = 1 To $aSplit[0]
				$sFunctionList &= @TAB & @TAB & @TAB & @TAB & "<Param name='" & StringStripWS($aSplit[$j], $STR_STRIPLEADING) & "' />" & @CRLF
			Next
			$sFunctionList &= @TAB & @TAB & @TAB & '</Overload>' & @CRLF
		EndIf

		$sFunctionList &= @TAB & @TAB & '</KeyWord>' & @CRLF
	Next
	Return $sFunctionList
EndFunc   ;==>GetFunctions

; ------------------------------------------------------------------------------
; Insert breaks every 100 characters.
; ------------------------------------------------------------------------------
Func InsertLineBreak($sData) ; Add escape breaks. Idea by jaberwocky6669 and guinness.
	Local Const $iBreak_Point = 100
	Local Const $iLength = StringLen($sData)
	If $iLength < $iBreak_Point Then Return $sData

	Local $fIsBreakPoint = False, _
			$iStart = $iBreak_Point, _
			$sChr = '', $sLine = ''
	Local Const $NP_NL = " &#x0a; ", _
			$STR_SPACE = Chr(32)
	For $i = 1 To $iLength
		$sChr = StringMid($sData, $i, 1)

		If $i = $iStart Or $fIsBreakPoint Then
			If $sChr = $STR_SPACE Then
				$fIsBreakPoint = False
				$iStart += $iBreak_Point
				$sChr &= $NP_NL
			Else
				$fIsBreakPoint = True
				$iStart += 1
			EndIf
		EndIf
		$sLine &= $sChr
	Next
	Return $sLine
EndFunc   ;==>InsertLineBreak
