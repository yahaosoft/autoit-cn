; ===================================================================
; Project: Misc Library
; Description: This file contains shared misc functions.
; Author: guinness
; ===================================================================
#include-once
#include <Array.au3>

; ------------------------------------------------------------------------------
; Associative array.
; ------------------------------------------------------------------------------
#Obfuscator_Off
Func _AssociativeArray_Startup(ByRef $aArray, $fIsCaseSensitive = False) ; Idea from MilesAhead.
	Local $fReturn = False
	$aArray = ObjCreate('Scripting.Dictionary')
	ObjEvent('AutoIt.Error', '__AssociativeArray_Error')
	If IsObj($aArray) Then
		$aArray.CompareMode = Int(Not $fIsCaseSensitive)
		$fReturn = True
	EndIf
	Return $fReturn
EndFunc   ;==>_AssociativeArray_Startup
#Obfuscator_On

; ------------------------------------------------------------------------------
; Convert & to &amp;.
; ------------------------------------------------------------------------------
Func _ConvertAMPSymbol(ByRef $sData)
	$sData = StringRegExpReplace($sData, '&(?!(?:amp|apos|gt|lt|nbsp|quot);)', '&amp;')
EndFunc   ;==>_ConvertAMPSymbol

; ------------------------------------------------------------------------------
; Escape symbols to HTML entities.
; ------------------------------------------------------------------------------
Func _ConvertSymbolsToHTMLEntity(ByRef $sData)
	_ConvertAMPSymbol($sData)
	$sData = StringReplace($sData, "'", '&apos;')
	$sData = StringReplace($sData, '>', '&gt;')
	$sData = StringReplace($sData, '<', '&lt;')
	$sData = StringReplace($sData, '"', '&quot;')
EndFunc   ;==>_ConvertSymbolsToHTMLEntity

; ------------------------------------------------------------------------------
; Escape HTML entities to symbols.
; ------------------------------------------------------------------------------
Func _ConvertHTMLEntityToSymbols(ByRef $sData)
	$sData = StringReplace($sData, '&amp;', '&')
	$sData = StringReplace($sData, '&apos;', "'")
	$sData = StringReplace($sData, '&gt;', '>')
	$sData = StringReplace($sData, '&lt;', '<')
	$sData = StringReplace($sData, '&quot;', '"')
EndFunc   ;==>_ConvertHTMLEntityToSymbols

; ------------------------------------------------------------------------------
; Convert @LF or @CR to @CRLF.
; ------------------------------------------------------------------------------
Func _ConvertEOLToCRLF(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\R', @CRLF) ; By Ascend4nt.
EndFunc   ;==>_ConvertEOLToCRLF

; ------------------------------------------------------------------------------
; Macro HTML data to a 2d array.
; ------------------------------------------------------------------------------
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
			$hAssocArray.Item($aMerge[$aMerge[0][0]][0]) = $aMerge[$aMerge[0][0]][1]
		Next
		; Sort the macro array in descending order.
		_ArraySort($aMerge, 0, 1)
		$aArray = $aMerge
	EndIf
EndFunc   ;==>_MacroListToArray

; ------------------------------------------------------------------------------
; Sort include lines.
; ------------------------------------------------------------------------------
Func _SortIncludes(ByRef $sData)
	If Not StringInStr($sData, '#include') Then Return False

	Local $aSRE = StringRegExp($sData, '(?m)^(#include\h["''<].*?["''>])\R', 3)
	If UBound($aSRE) Then
		Local Const $ASCII_ACK = Chr(6), _
				$STR_REPLACE_ONCE = 1
		For $i = 0 To UBound($aSRE) - 1
			$sData = StringReplace($sData, $aSRE[$i], $ASCII_ACK, $STR_REPLACE_ONCE, $STR_CASESENSE)
		Next
		_ArraySort($aSRE)
		For $i = 0 To UBound($aSRE) - 1
			$sData = StringReplace($sData, $ASCII_ACK, $aSRE[$i], $STR_REPLACE_ONCE, $STR_CASESENSE)
		Next
	EndIf
	Return True
EndFunc   ;==>_SortIncludes

; ------------------------------------------------------------------------------
; Strip empty lines.
; ------------------------------------------------------------------------------
Func _StripEmptyLines(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?m:^\h*\R)', @CRLF) ; Strip double empty lines. By guinness.
EndFunc   ;==>_StripEmptyLines

; ------------------------------------------------------------------------------
; Remove blanks lines at the start of a file.
; ------------------------------------------------------------------------------
Func _StripEmptyLinesDouble(ByRef $sData)
	$sData = StringRegExpReplace($sData, '(?m)^\s*[\r\n]{2,}', @CRLF)
EndFunc   ;==>_StripEmptyLinesDouble

; ------------------------------------------------------------------------------
; Remove blanks lines at the end of the file. Option to append e.g. CRLF.
; ------------------------------------------------------------------------------
Func _StripEmptyLinesEndOfFile(ByRef $sData, $sAppend = '')
	$sData = StringRegExpReplace($sData, '\v+$', '') & $sAppend
EndFunc   ;==>_StripEmptyLinesEndOfFile

; ------------------------------------------------------------------------------
; Remove blanks lines at the start of a file. Option to append e.g. CRLF.
; ------------------------------------------------------------------------------
Func _StripEmptyLinesStartOfFile(ByRef $sData, $sAppend = '')
	$sData = StringRegExpReplace($sData, '^\v+', '') & $sAppend
EndFunc   ;==>_StripEmptyLinesStartOfFile

; ------------------------------------------------------------------------------
; Strip leading/trailing whitespace.
; ------------------------------------------------------------------------------
Func _StripWhitespace(ByRef $sData)
	_StripTrailingWhitespace($sData)
	_StripLeadingWhitespace($sData)
EndFunc   ;==>_StripWhitespace

; ------------------------------------------------------------------------------
; Strip leading whitespace.
; ------------------------------------------------------------------------------
Func _StripLeadingWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\R\h+', @CRLF) ; By DXRW4E.
EndFunc   ;==>_StripLeadingWhitespace

; ------------------------------------------------------------------------------
; Strip trailing whitespace.
; ------------------------------------------------------------------------------
Func _StripTrailingWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\h+(?=\R)', '') ; By DXRW4E.
EndFunc   ;==>_StripTrailingWhitespace
