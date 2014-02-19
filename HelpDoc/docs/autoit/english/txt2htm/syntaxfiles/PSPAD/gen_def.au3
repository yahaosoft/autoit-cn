#include-once

#include <FileConstants.au3>
#include <StringConstants.au3>
; #include "..\gen_editorfuncs.au3"

Global Const $ASCII_ACK = Chr(6), _
		$FUNCTIONLIST_FULL = '..\function_full.txt', _
		$LIBFUNCTIONLIST_FULL = '..\libfunctions_full.txt', _
		$MACROLIST_FULL = '..\macros_full.txt'

; ------------------------------------------------------------------------------
; Automatically generate the definition syntax file(s) for functions, keywords and macros.
; ------------------------------------------------------------------------------
Func GenerateDefSyntax()
	If Not FileExists($FUNCTIONLIST_FULL) Or Not FileExists($MACROLIST_FULL) Then Return False

	; Get the Functions list.
	Local $sFunctionList = GetFunctions()

	; Get the Macros list.
	Local $sMacroList = GetMacros()
	FileDelete($MACROLIST_FULL) ; Delete the macros full file as it's not longer needed.

	FileCopy(@ScriptDir & '\extra.def', @ScriptDir & '\AutoIt3.def', $FC_OVERWRITE)
	Local $hFileOpen = FileOpen(@ScriptDir & '\AutoIt3.def', $FO_APPEND)
	FileWriteLine($hFileOpen, $sFunctionList & $sMacroList)
	FileClose($hFileOpen)
EndFunc   ;==>GenerateDefSyntax

; ------------------------------------------------------------------------------
; Retrieve the functions, syntax and description.
; ------------------------------------------------------------------------------
Func GetFunctions()
	Local $sData = FileRead($FUNCTIONLIST_FULL) & $ASCII_ACK & @CRLF & FileRead($LIBFUNCTIONLIST_FULL) & @CRLF
	Local $aFunctions = StringSplit($sData, $ASCII_ACK), _
			$sFunctionList = ''
	For $i = 1 To $aFunctions[0] Step 3
		$aFunctions[$i] = StringStripWS($aFunctions[$i], $STR_STRIPALL)
		$sFunctionList &= '[' & $aFunctions[$i] & ' | ' & $aFunctions[$i + 2] & ']' & @CRLF
		$sFunctionList &= StringReplace($aFunctions[$i + 1], '( ', '( |') & @CRLF
		$sFunctionList &= ';' & @CRLF
	Next
	Return $sFunctionList
EndFunc   ;==>GetFunctions

; ------------------------------------------------------------------------------
; Retrieve the list of macros and their description.
; ------------------------------------------------------------------------------
Func GetMacros()
	Local $sData = FileRead($MACROLIST_FULL)
	Local $aMacros = StringSplit($sData, $ASCII_ACK), _
			$sMacroList = ''
	For $i = 1 To $aMacros[0] Step 2
		$aMacros[$i] = StringStripWS($aMacros[$i], $STR_STRIPALL)
		$sMacroList &= "[" & $aMacros[$i] & " | " & $aMacros[$i + 1] & "]" & @CRLF
		$sMacroList &= $aMacros[$i] & @CRLF
		$sMacroList &= ";" & @CRLF
	Next
	Return $sMacroList
EndFunc   ;==>GetMacros
