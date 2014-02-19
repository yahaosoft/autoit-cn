#include <File.au3>
; #include "..\gen_editorfuncs.au3"

Global Const $FUNCTIONLIST = "..\functions.txt", _
		$KEYWORDLIST = "..\keywords.txt", _
		$LIBFUNCTIONLIST = "..\libfunctions.txt", _
		$MACROLIST = "..\macros.txt", _
		$SENDSTRINGLIST = "..\sendstrings.txt"

GeneratePHP()

; ------------------------------------------------------------------------------
; Automatically generate the php file.
; ------------------------------------------------------------------------------
Func GeneratePHP()
	Local $sOutput = "autoit.php"
	Local $hOutput = FileOpen($sOutput, $FO_OVERWRITE)
	If $hOutput = -1 Then Return MsgBox($MB_SYSTEMMODAL, "Error", "Unable to save the php file.")

	Local $sHeader = FileRead("header.txt")
	; Update the copyright year(s) field.
	$sHeader = StringRegExpReplace($sHeader, '(\(c\)\h+\d{4}-)\d{4}', '${1}' & @YEAR)

	; Update the AutoIt version field.
	Local $VersionNull = "0.0.0.0"
	Local $sVersion = IniRead("..\..\..\..\..\_build\config.ini", "Build", "AutoItVersion", $VersionNull) ; Retrieves the AutoIt version.
	If $sVersion = $VersionNull Then $sVersion = @AutoItVersion
	$sHeader = StringRegExpReplace($sHeader, '(AutoIt:\h+v)\V+', '${1}' & $sVersion)

	; Update the updated field.
	$sHeader = StringRegExpReplace($sHeader, '(Updated:\h+)(\d{4})/(\d{2})/(\d{2})', '${1}' & @YEAR & '/' & @MON & '/' & @MDAY)
	FileWrite($hOutput, $sHeader)

	Local $aKeywords = 0, $aComments = 0, $aPreProcessor = 0, $aPragma = 0, $aAu3Check = 0, $aRegion = 0
	_SplitKeywords($KEYWORDLIST, $aKeywords, $aComments, $aPreProcessor, $aPragma, $aAu3Check, $aRegion)
	_AppendPHPArray($hOutput, "1", $aKeywords)

	Local $aMacros = 0
	_FileReadToArray($MACROLIST, $aMacros)
	_AppendPHPArray($hOutput, "2", $aMacros)

	Local $aFunctions = 0
	_FileReadToArray($FUNCTIONLIST, $aFunctions)
	_ArraySort($aFunctions, 0, 1)
	_AppendPHPArray($hOutput, "3", $aFunctions)

	Local $aLibFunctions = 0
	_FileReadToArray($LIBFUNCTIONLIST, $aLibFunctions)
	_StripFirstChar($aLibFunctions)
	_AppendPHPArray($hOutput, "4", $aLibFunctions)

	_AppendPHPArray($hOutput, "5", $aComments)

	Local $aSciteDirectives = 0
	_FileReadToArray(@ScriptDir & "\SciTEDirectives.txt", $aSciteDirectives)
	_AppendArray($aSciteDirectives, $aRegion)
	_AppendPHPArray($hOutput, "6", $aSciteDirectives)

	Local $aSendKeys = 0
	_FileReadToArray($SENDSTRINGLIST, $aSendKeys)
	_StripFirstAndLastChar($aSendKeys)
	_AppendPHPArray($hOutput, "7", $aSendKeys)

	_AppendPHPArray($hOutput, "8", $aPreProcessor)
	_AppendPHPArray($hOutput, "9", $aPragma)
	_AppendPHPArray($hOutput, "10", $aAu3Check)

	Local $aFooters = 0
	_FileReadToArray(@ScriptDir & "\footer.txt", $aFooters)
	For $i = 1 To $aFooters[0]
		FileWriteLine($hOutput, $aFooters[$i])
	Next

	FileClose($hOutput)

EndFunc   ;==>GeneratePHP

Func _AppendPHPArray($hOutput, $iValue, ByRef $aArray)
	FileWriteLine($hOutput, _AddBlanks(8) & $iValue & " => array(")
	Local $sTemp = _AddBlanks(12)

	For $i = 1 To $aArray[0]
		_StringClip($hOutput, $aArray[$i], $sTemp)
	Next

	_StringEnd($hOutput, $sTemp)
EndFunc   ;==>_AppendPHPArray

Func _AddBlanks($iLength)
	Local $sReturn = ''
	For $i = 1 To $iLength
		$sReturn &= ' '
	Next
	Return $sReturn
EndFunc   ;==>_AddBlanks

Func _SplitKeywords($sFilePath, ByRef $aKeywords, ByRef $aComments, ByRef $aPreProcessor, ByRef $aPragma, ByRef $aAu3Check, ByRef $aRegion)
	Local $sData = FileRead($sFilePath)
	; Keywords
	$aKeywords = StringRegExp('Count' & @CRLF & $sData, '(?m)^(\w+)', 3)
	$aKeywords[0] = UBound($aKeywords) - 1
	_StripKeywordFromData($sData, $aKeywords)

	; Comments
	$aComments = StringRegExp('#cs' & @CRLF & $sData, '(?im)^#(c(?:e|s)|comments-(?:end|start))', 3)
	$aComments[0] = UBound($aComments) - 1
	_StripKeywordFromData($sData, $aComments, '#')

	; Pragma
	$aPragma = StringRegExp('#pragma' & @CRLF & $sData, '(?im)^#(pragma)', 3)
	$aPragma[0] = UBound($aPragma) - 1
	_StripKeywordFromData($sData, $aPragma, '#')

	; Au3Check
	$aAu3Check = StringRegExp('#forcedef' & @CRLF & $sData, '(?im)^#(force(?:def|ref)|ignorefunc)', 3)
	$aAu3Check[0] = UBound($aAu3Check) - 1
	_StripKeywordFromData($sData, $aAu3Check, '#')

	$aRegion = StringRegExp('#Region' & @CRLF & $sData, '(?im)^#((?:End)?Region)', 3)
	$aRegion[0] = UBound($aRegion) - 1
	_StripKeywordFromData($sData, $aRegion, '#')

	; PreProcessor
	$aPreProcessor = StringRegExp('#cs' & @CRLF & $sData, '(?m)^#([\w\-]+)', 3)
	$aPreProcessor[0] = UBound($aPreProcessor) - 1
	_StripKeywordFromData($sData, $aPreProcessor, '#')

	Return True
EndFunc   ;==>_SplitKeywords

Func _StripKeywordFromData(ByRef $sData, $aArray, $sPreAppend = '')
	For $i = 1 To $aArray[0]
		$sData = StringReplace(@CRLF & $sData & @CRLF, @CRLF & $sPreAppend & $aArray[$i] & @CRLF, @CRLF)
	Next
EndFunc   ;==>_StripKeywordFromData

Func _StringClip($hOutput, $sText, ByRef $sTempString, $iLength = 80)
	$sText = "'" & $sText & "',"
	If StringLen($sTempString & $sText) > $iLength Then
		FileWriteLine($hOutput, $sTempString)
		$sTempString = _AddBlanks(12) & $sText
	Else
		$sTempString &= $sText
	EndIf
EndFunc   ;==>_StringClip

Func _StringEnd($hOutput, ByRef Const $sTempString)
	FileWriteLine($hOutput, StringTrimRight($sTempString, 1))
	FileWriteLine($hOutput, _AddBlanks(12) & "),")
EndFunc   ;==>_StringEnd

Func _StripFirstChar(ByRef $aArray)
	For $i = 1 To $aArray[0]
		$aArray[$i] = StringTrimLeft($aArray[$i], 1)
	Next
EndFunc   ;==>_StripFirstChar

Func _StripFirstAndLastChar(ByRef $aArray)
	For $i = 1 To $aArray[0]
		$aArray[$i] = StringTrimRight(StringTrimLeft($aArray[$i], 1), 1)
	Next
EndFunc   ;==>_StripFirstAndLastChar

Func _AppendArray(ByRef $aArray1, ByRef $aArray2)
	Local $iCount = $aArray1[0]
	ReDim $aArray1[$iCount + $aArray2[0] + 1]
	For $i = 1 To $aArray2[0]
		$aArray1[$i + $iCount] = $aArray2[$i]
	Next
	$aArray1[0] += $aArray2[0]
EndFunc   ;==>_AppendArray
