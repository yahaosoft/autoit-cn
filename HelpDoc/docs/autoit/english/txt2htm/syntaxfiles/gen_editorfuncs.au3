#include-once
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

Global Const $FUNCTIONLIST = "..\functions.txt", _
		$KEYWORDLIST = "..\keywords.txt", _
		$LIBFUNCTIONLIST = "..\libfunctions.txt", _
		$MACROLIST = "..\macros.txt", _
		$SENDSTRINGLIST = "..\sendstrings.txt"

; ------------------------------------------------------------------------------
; Combine two function arrays into one. Array count is in the zeroth index.
; ------------------------------------------------------------------------------
Func CombineFunctionArray(ByRef $aArray, ByRef $aCombineArray)
	If IsArray($aArray) Then
		ReDim $aArray[$aArray[0] + $aCombineArray[0] + 1]
	EndIf
	If IsArray($aCombineArray) Then
	For $i = 1 To $aCombineArray[0]
		$aArray[0] += 1
		$aArray[$aArray[0]] = $aCombineArray[$i]
	Next
	EndIf
	$aCombineArray = 0
EndFunc   ;==>CombineFunctionArray

; ------------------------------------------------------------------------------
; Create the editor syntax stylesheet.
; ------------------------------------------------------------------------------
Func DoEditorSyntax($sOutput, $sHeader, ByRef $aKeywords, ByRef $sKeywordList, ByRef $aMacros, ByRef $sMacroList, ByRef $aFunctions, ByRef $sFunctionList, $sAppend = "=")
	; Copy the header.txt file to the output file.
	FileCopy($sHeader, $sOutput, $FC_OVERWRITE)

	; Keywords
	If IsArray($aKeywords) Then
	For $i = 1 To $aKeywords[0]
		$sKeywordList &= $aKeywords[$i] & $sAppend & @CRLF
	Next
	EndIf

	; Macros
	If IsArray($aMacros) Then
	For $i = 1 To $aMacros[0]
		$sMacroList &= $aMacros[$i] & $sAppend & @CRLF
	Next
	EndIf

	; Functions
	If IsArray($aFunctions) Then
	For $i = 1 To $aFunctions[0]
		$sFunctionList &= $aFunctions[$i] & $sAppend & @CRLF
	Next
	EndIf

	Local $hFileOpen = FileOpen($sOutput, $FO_APPEND)
	If $hFileOpen = -1 Then Return MsgBox($MB_SYSTEMMODAL, "Error", "Unable to save the syntax file.")
	FileWrite($hFileOpen, $sKeywordList & $sMacroList & $sFunctionList)
	FileClose($hFileOpen)
EndFunc   ;==>DoEditorSyntax
