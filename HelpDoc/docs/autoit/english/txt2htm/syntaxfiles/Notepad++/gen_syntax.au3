#include <File.au3>
#include "..\gen_editorfuncs.au3"

Global Const $ASCII_ACK = Chr(6), _
		$FUNCTIONLIST_FULL = '..\function_full.txt', _
		$LIBFUNCTIONLIST_FULL = '..\libfunctions_full.txt'

GenerateSyntax()

; ------------------------------------------------------------------------------
; Automatically generate the syntax file(s).
; ------------------------------------------------------------------------------
Func GenerateSyntax()
	Local $aFunctions = 0, $aLibFunctions = 0, _
			$sFunctionList = ''

	; Create Notepad++ editor list.
	$sFunctionList = GetFunctions()

	$sFunctionList = "<?xml version='1.0' encoding='UTF-8' ?>" & @CRLF & _
			"<NotepadPlus>" & @CRLF & _
			@TAB & "<AutoComplete language='AutoIt'>" & @CRLF & _
			@TAB & @TAB & "<Environment ignoreCase='yes' startFunc='(' stopFunc=')' paramSeparator=',' terminal='' />" & @CRLF & _
			$sFunctionList & _
			@TAB & "</AutoComplete>" & @CRLF & _
			"</NotepadPlus>"

	Local $hFileOpen = FileOpen(@ScriptDir & '\autoit.xml', $FO_OVERWRITE)
	FileWriteLine($hFileOpen, $sFunctionList)
	FileClose($hFileOpen)
EndFunc   ;==>GenerateSyntax

; ------------------------------------------------------------------------------
; Retrieve the functions, syntax and description.
; ------------------------------------------------------------------------------
Func GetFunctions()
	Local $sData = FileRead($FUNCTIONLIST_FULL ) & $ASCII_ACK & @CRLF & FileRead($LIBFUNCTIONLIST_FULL) & @CRLF
	Local $aFunctions = StringSplit($sData, $ASCII_ACK), $aSplit = 0, _
			$sDescription = '', $sFunctionList = ''

	For $i = 1 To $aFunctions[0] Step 3
		$aFunctions[$i] = StringStripWS($aFunctions[$i], $STR_STRIPALL)
		$sFunctionList &= @TAB & @TAB & "<KeyWord name='" & $aFunctions[$i] & "' func='yes' >" & @CRLF
		$sFunctionList &= @TAB & @TAB & @TAB & "<Overload retVal='' descr='" & $aFunctions[$i + 2] & "' >" & @CRLF

		$sDescription = $aFunctions[$i + 1]
		$aSplit = StringRegExp($sDescription, '\w+\h*\((.*?)\h*\)', 3)
		If UBound($aSplit) Then $sDescription = $aSplit[0]
		$sDescription = StringReplace($sDescription, '&', '&amp;')
		$sDescription = StringReplace($sDescription, '`', '&apos;')
		$sDescription = StringReplace($sDescription, '>', '&gt;')
		$sDescription = StringReplace($sDescription, '<', '&lt;')
		$sDescription = StringReplace($sDescription, '"', '&quot;')

		$aSplit = StringSplit($sDescription, ',')
		For $j = 1 To $aSplit[0]
			$sFunctionList &= @TAB & @TAB & @TAB & @TAB & "<Param name='" & StringStripWS($aSplit[$j], $STR_STRIPLEADING) & "' />" & @CRLF
		Next

		$sFunctionList &= @TAB & @TAB & @TAB & '</Overload>' & @CRLF
		$sFunctionList &= @TAB & @TAB & '</KeyWord>' & @CRLF
	Next
	Return $sFunctionList
EndFunc   ;==>GetFunctions
