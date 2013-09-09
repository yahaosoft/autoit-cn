; ===================================================================
; Project: Misc Library
; Description: This file contains shared misc functions.
; Author: guinness
; ===================================================================
#include-once
#include <Array.au3>

#Obfuscator_Off
Func _AssociativeArray_Startup(ByRef $aArray, $fIsCaseSensitive = False) ; Idea from MilesAhead.
	$aArray = ObjCreate('Scripting.Dictionary')
	ObjEvent('AutoIt.Error', '__AssociativeArray_Error\\\')
	If IsObj($aArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	$aArray.CompareMode = Int(Not $fIsCaseSensitive)
EndFunc   ;==>_AssociativeArray_Startup
#Obfuscator_On

Func _ConvertAMPSymbol(ByRef $sData)
	; Convert & to &amp;.
	$sData = StringRegExpReplace($sData, '&(?!(?:amp|gt|lt);)', '&amp;')
EndFunc   ;==>_ConvertAMPSymbol

Func _MacroListToArray(ByRef $sData, ByRef $aArray, ByRef $hAssocArray)
	_ConvertAMPSymbol($sData)

	Local $aSRE = StringRegExp($sData, '(?s)</a><strong>(\@\w+)</strong></td>\R\s*<td>(.*?)</td>', 3), _
			$iUBound = UBound($aSRE)
	If $iUBound Then
		_AssociativeArray_Startup($hAssocArray, True)
		Local $aMerge[Ceiling($iUBound / 2) + 1][2]
		For $i = 0 To $iUBound - 1 Step 2
			$aMerge[0][0] += 1
			$aMerge[$aMerge[0][0]][0] = $aSRE[$i] ; Macro
			$aMerge[$aMerge[0][0]][1] = $aSRE[$i + 1] ; Description
			$hAssocArray($aMerge[$aMerge[0][0]][0]) = $aMerge[$aMerge[0][0]][1]
		Next
		; Sort the macro array in descending order.
		_ArraySort($aMerge, 0, 1)
		$aArray = $aMerge
	EndIf
EndFunc   ;==>_MacroListToArray

; ------------------------------------------------------------------------------
; Strip empty lines.
; ------------------------------------------------------------------------------
Func _StripEmptyLines(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?m)^\s*[\r\n]{2,}', @CRLF) ; Strip double empty lines. By guinness.
EndFunc   ;==>_StripEmptyLines

; ------------------------------------------------------------------------------
; Strip leading/trailing whitespace.
; ------------------------------------------------------------------------------
Func _StripWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\h+(?=[\r\n])', '') ; Trailing whitespace. By DXRW4E.
	$sData = StringRegExpReplace($sData, '[\r\n]\h+', @LF) ; Strip leading whitespace. By DXRW4E.
EndFunc   ;==>_StripWhitespace
