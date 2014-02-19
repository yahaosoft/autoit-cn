#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include <Array.au3>
#include <File.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WinAPIFiles.au3>

; Check related functions exist.
; Check $tag parameters.

Global Const $UBOUND_COLUMNS = 2

Global Const $ASCII_ACK = Chr(6)
Global Const $STR_REPLACE_ONCE = 1
Global Const $DOCSOURCE = '.\txt2htm', _
		$HTMLSOURCE = '.\html', _
		$INCLUDESOURCE = '..\..\..\install\Include', _
		$OPTIONAL = '[optional]', _
		$EXAMPLES = 'examples', _
		$LIBEXAMPLES = 'libExamples', _
		$TXTFUNCTIONS = 'txtfunctions', _
		$TXTLIBFUNCTIONS = 'txtlibfunctions', _
		$TXTKEYWORDS = 'txtKeywords'
Global Enum $ISINCLUDE_EXAMPLE_EXISTS = 1, $ISINCLUDE_EXAMPLE_NONE
Global Enum $PARAMS_VARIABLE, $PARAMS_VALUEORDESC, $PARAMS_OPTIONAL, $PARAMS_MAX
Global Enum $PARAMS_OPTIONAL_OK, $PARAMS_OPTIONAL_NOPARAMTABLE, $PARAMS_OPTIONAL_MISMATCH, $PARAMS_OPTIONAL_INFUNCNOTTABLE, $PARAMS_OPTIONAL_INTABLENOTFUNC
Global Enum $SYNTAX_INCLUDE_NO_LINE = 1, $SYNTAX_INCLUDE_NO_FILE

; Set to the directory before txtlibfunctions.
FileChangeDir("..\..\..\autoit\english")

Global $PFOP_PATHS = _GetFullPath($DOCSOURCE) & @LF
$PFOP_PATHS &= _GetFullPath($DOCSOURCE & '\' & $TXTFUNCTIONS) & @LF
$PFOP_PATHS &= _GetFullPath($DOCSOURCE & '\' & $TXTLIBFUNCTIONS) & @LF
$PFOP_PATHS &= _GetFullPath($DOCSOURCE & '\' & $TXTKEYWORDS) & @LF
$PFOP_PATHS &= _GetFullPath($HTMLSOURCE) & @LF

TextTidy(True) ; Native
TextTidy(False) ; UDFs.
KeywordsTidy() ; Keywords.

Func TextTidy($fIsNative)
	Local $sSection_After = '', $sSection_Before = '', $sSection_Editable = ''
	Local $sData = '', $sDataOriginal = '', $sInclude_After = '', $sInclude_Before = '', $sInfo = ''
	Local $sHelpFileTxtPath = _GetFullPath(($fIsNative ? $DOCSOURCE & '\' & $TXTFUNCTIONS : $DOCSOURCE & '\' & $TXTLIBFUNCTIONS))

	Local $aFilePathTxtList = _FileListToArray($sHelpFileTxtPath, '*.txt', 1, True), _
			$aFuncParams = 0, _
			$aLinksErrors = 0, _
			$aParamsTable = 0, _
			$fIsTag = False, _
			$sVariablesNotFound = ''
	For $i = 1 To $aFilePathTxtList[0]
		$fIsTag = StringRegExp(_WinAPI_PathStripPath($aFilePathTxtList[$i]), '^\$tag') = 1
		$sData = FileRead($aFilePathTxtList[$i])
		$sDataOriginal = $sData
		$sInfo = ''

		If _Section_Tidy($sData) Then
			$sInfo &= '! Section whitespace and end of line characters formatted.' & @CRLF
		EndIf

		If Not _Example_IsInclude($aFilePathTxtList[$i], $sData, ($fIsNative ? $DOCSOURCE & '\' & $EXAMPLES : $DOCSOURCE & '\' & $LIBEXAMPLES)) Then ; Check include line before processing. $LIBEXAMPLES should be changed to $EXAMPLES when checking native functions.
			Switch @extended
				Case $ISINCLUDE_EXAMPLE_EXISTS
					$sInfo &= '! An example exists but is missing the include line. Please add the appropriate line to the TXT doc.' & @CRLF
				Case $ISINCLUDE_EXAMPLE_NONE
					$sInfo &= '! An example is missing though has been specified it should exist in the TXT doc. Line has been removed.' & @CRLF
			EndSwitch
		EndIf

		$aLinksErrors = _URLLinks_FormatAndCheck($sData, $fIsNative) ; Native = True, UDF = False
		If @error Then
			If @extended Then
				$sInfo &= '! Incorrect formatting of links.' & @CRLF
			EndIf
			If UBound($aLinksErrors) Then
				$sInfo &= '! Link errors. The following links are incorrect:' & @CRLF
				For $iLinks = 0 To UBound($aLinksErrors) - 1
					$sInfo &= @TAB & $aLinksErrors[$iLinks] & @CRLF
				Next
			EndIf
		EndIf

		If Not _IsTablesEnd($sData) Then
			$sInfo &= '! @@End@@ is missing.' & @CRLF
		EndIf

		If _Tables_Tidy($sData) Then
			$sInfo &= '! Incorrect formatting of @@ tables.' & @CRLF
		EndIf

		If _Tags_Tidy($sData) Then
			$sInfo &= '! Incorrect formatting of HTML tags.' & @CRLF
		EndIf

		; Description - Add period to end of line.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Description###\R)(\V*)(\R.*)') Then
			_DescriptionDot($sSection_Editable, $fIsNative)
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! ' & ($fIsNative ? 'Added' : 'Removed') & ' period (.) from the end of the description.' & @CRLF
			EndIf
		EndIf

		; Syntax - Format include line.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Syntax###\R)(\V*)(\R.*)') Then
			If _Syntax_Include($sSection_Editable, $sInclude_Before, $sInclude_After, $fIsNative) Then ; Native = True, UDF = False
				If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
					$sInfo &= '! Include line formatted from <' & $sInclude_Before & '> to <' & $sInclude_After & '>.' & @CRLF
				EndIf
			Else
				Switch @error
					Case $SYNTAX_INCLUDE_NO_LINE
						; Nothing to report right now, as this error is for $tag... structures.
					Case $SYNTAX_INCLUDE_NO_FILE
						$sInfo &= '! Include line is referencing an include that doesn''t exist.' & @CRLF
				EndSwitch
			EndIf
		EndIf

		; Syntax - Format function line.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Syntax###\R#include\V*\R)(\V*)(\R.*)') Then
			_Syntax_FunctionAndParamsTidy($sSection_Editable, $aFuncParams, $fIsNative) ; Native = True, UDF = False
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! Syntax function parameter line was incorrectly formatted.' & @CRLF
			EndIf
			#cs
				Local $sVar = ''
				For $iFunction = 0 To UBound($vDummyValue) - 1
				$sVar = StringRegExp($vDummyValue[$iFunction][0], '\$(\w*)', 3) ; Get the variable name minus $.
				If Not UBound($sVar) Then
				ContinueLoop
				EndIf
				$sVar = $sVar[0]
				If StringRegExp($sData, '(?<!\$)\b' & $sVar & '\b') Then
				If Not StringRegExp($sVar, '^[a-z]') Then ContinueLoop
				If $sVar = 'lParam' Or $sVar = 'wParam' Or $sVar = 'hWnd' Then
				; ConsoleWrite($sVar & ', ' & $aFilePathTxtList[$i] & @CRLF)
				; ContinueLoop
				EndIf
				; $sData = StringRegExpReplace($sData, '(?<!\$)\b' & $sVar & '\b', '\$' & $sVar)
				; ConsoleWrite($sVar & ', ' & $aFilePathTxtList[$i] & @CRLF)
				EndIf
				Next
			#ce
		EndIf

		; Parameters - Check if parameters are declared correctly.
		If Not $fIsTag And _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Parameters###\R@@ParamTable@@\R)(.*?)(\R@@End@@.*)') Then
			If Not _Parameters_OptionalCheck($sSection_Editable, $aFuncParams, $aParamsTable, $sVariablesNotFound, $fIsNative) Then
				Switch @error
					Case $PARAMS_OPTIONAL_MISMATCH
						$sInfo &= '! The number of parameters in the parameter table don''t match those in the function declaration.' & @CRLF
					Case Else
						For $iFunction = 0 To UBound($aFuncParams) - 1
							Switch $aFuncParams[$iFunction][$PARAMS_OPTIONAL]
								Case $PARAMS_OPTIONAL_MISMATCH
									$sInfo &= '! ' & $aFuncParams[$iFunction][$PARAMS_VARIABLE] & ' Not found In the parameter table.' & @CRLF
								Case $PARAMS_OPTIONAL_INFUNCNOTTABLE
									$sInfo &= '! ' & $aFuncParams[$iFunction][$PARAMS_VARIABLE] & ' is optional, but missing ' & $OPTIONAL & ' In the parameter table.' & @CRLF
								Case $PARAMS_OPTIONAL_INTABLENOTFUNC
									$sInfo &= '! ' & $aFuncParams[$iFunction][$PARAMS_VARIABLE] & ' is optional, but missing the Default parameter value.' & @CRLF
							EndSwitch
						Next
				EndSwitch
				If $sVariablesNotFound Then
					$sInfo &= '! The following parameters were in the parameter table, but missing in the function syntax. - ' & $sVariablesNotFound & @CRLF
					$sVariablesNotFound = ''
				EndIf
			EndIf
		Else
			_GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Parameters###\R)(.*?)(\R\R###.*)') ; When no parameters are present.
			_IsNone($sSection_Editable, $fIsNative)
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! Parameter section with no parameter(s) edited from None to None. ( + period).' & @CRLF
			EndIf
		EndIf

		; Return - Format None line.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###ReturnValue###\R)(\V*)(\R.*)') Then
			If $sSection_Editable = '' Then $sSection_Editable = 'None.' & @CRLF
			_IsNone($sSection_Editable, $fIsNative)
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! Return section with no parameter(s) edited from None to None. ( + period).' & @CRLF
			EndIf
		EndIf

		; Related - Sort related functions.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Related###\R)(\V*)(\R.*)') Then
			_Related_FunctionSort($sSection_Editable, $fIsNative) ; Native = True, UDF = False
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! Related section formatted and sorted.' & @CRLF
			EndIf
		EndIf

		; Remarks - If there are no remarks ensure None is formatted to None. ( + period).
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Remarks###\R)(\V*)(\R.*)') Then
			_IsNone($sSection_Editable, $fIsNative)
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! Remarks section with no remark(s) edited from None to None. ( + period).' & @CRLF
			EndIf
		EndIf

		If $sInfo Then
			$sInfo = $aFilePathTxtList[$i] & @CRLF & $sInfo & @CRLF
			ConsoleWrite($sInfo)
		EndIf

		_SetFileData($aFilePathTxtList[$i], $aFilePathTxtList[$i], $sDataOriginal, $sData)
	Next
EndFunc   ;==>TextTidy

Func KeywordsTidy()
	Local Const $fIsNative = True ; Because it's similar to the native TXT docs.
	Local $sSection_After = '', $sSection_Before = '', $sSection_Editable = ''
	Local $sData = '', $sDataOriginal = '', $sInfo = ''
	Local $sHelpFileTxtPath = _GetFullPath($DOCSOURCE & '\' & $TXTKEYWORDS)
	Local $aFilePathTxtList = _FileListToArray($sHelpFileTxtPath, '*.txt', 1, True), _
			$aLinksErrors = 0
	For $i = 1 To $aFilePathTxtList[0]
		$sData = FileRead($aFilePathTxtList[$i])
		$sDataOriginal = $sData
		$sInfo = ''
		If _Section_Tidy($sData) Then
			$sInfo &= '! Section whitespace and end of line characters formatted.' & @CRLF
		EndIf

		If Not _Example_IsInclude($aFilePathTxtList[$i], $sData, $DOCSOURCE & '\' & $EXAMPLES) Then ; Check include line before processing.
			Switch @extended
				Case $ISINCLUDE_EXAMPLE_EXISTS
					$sInfo &= '! An example exists but is missing the include line. Please add the appropriate line to the TXT doc.' & @CRLF
				Case $ISINCLUDE_EXAMPLE_NONE
					$sInfo &= '! An example is missing though has been specified it should exist in the TXT doc. Line has been removed.' & @CRLF
			EndSwitch
		EndIf

		$aLinksErrors = _URLLinks_FormatAndCheck($sData, $fIsNative) ; Native = True, UDF = False
		If @error Then
			If @extended Then
				$sInfo &= '! Incorrect formatting of links.' & @CRLF
			EndIf
			If UBound($aLinksErrors) Then
				$sInfo &= '! Link errors. The following links are incorrect:' & @CRLF
				For $iLinks = 0 To UBound($aLinksErrors) - 1
					$sInfo &= @TAB & $aLinksErrors[$iLinks] & @CRLF
				Next
			EndIf
		EndIf

		If Not _IsTablesEnd($sData) Then
			$sInfo &= '! @@End@@ is missing.' & @CRLF
		EndIf

		If _Macros_Tidy($sData) Then
			$sInfo &= '! Incorrect formatting of TXT doc macros.' & @CRLF
		Endif

		If _Tables_Tidy($sData) Then
			$sInfo &= '! Incorrect formatting of @@ tables.' & @CRLF
		EndIf

		If _Tags_Tidy($sData) Then
			$sInfo &= '! Incorrect formatting of HTML tags.' & @CRLF
		EndIf

		; Description - Add period to end of line.
		If _GetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After, '(?is)(^.+###Description###\R)(\V*)(\R.*)') Then
			_DescriptionDot($sSection_Editable, $fIsNative)
			If _SetSection($sData, $sSection_Before, $sSection_Editable, $sSection_After) Then
				$sInfo &= '! ' & ($fIsNative ? 'Added' : 'Removed') & ' period (.) from the end of the description.' & @CRLF
			EndIf
		EndIf

		If $sInfo Then
			$sInfo = $aFilePathTxtList[$i] & @CRLF & $sInfo & @CRLF
			ConsoleWrite($sInfo)
		EndIf

		_SetFileData($aFilePathTxtList[$i], $aFilePathTxtList[$i], $sDataOriginal, $sData)
	Next
EndFunc   ;==>KeywordsTidy

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

Func _ConvertEOLToCRLF(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\R', @CRLF)
EndFunc   ;==>_ConvertEOLToCRLF

Func _DescriptionDot(ByRef $sData, $fIsNative = Default)
	If $fIsNative = Default Then $fIsNative = True
	Local Const $fIsDot = StringRight($sData, 1) == '.'
	If $fIsNative Then
		If Not $fIsDot Then $sData &= '.' ; Native functions.
	Else
		If $fIsDot Then $sData = StringTrimRight($sData, 1) ; UDF functions.
	EndIf
	Return ($fIsNative ? $fIsDot = False : $fIsDot = True)
EndFunc   ;==>_DescriptionDot

Func _Example_IsInclude($sFilePath, ByRef $sData, $sExampleDir) ; Check and remove (if applicable) the include script line.
	; Check if an Au3 script exists one folder up and in the libExamples folder.
	Local $fExampleExists = FileExists(_GetExamplePath($sFilePath, $sExampleDir)) = 1, _
			$fReturn = StringRegExp($sData, '\R###Example###\R\h*@@IncludeExample@@'), _
			$iExtended = 0
	If $fReturn Then ; Include section exists.
		If $fExampleExists Then
			; Tidy the include line by removing any preceeding spaces.
			$sData = StringRegExpReplace($sData, '(\R###Example###\R)\h*(@@IncludeExample@@)\h*', '\1\2')
		Else
			; Remove the line from the TXT file if no example is found OR could report it..
			$sData = StringRegExpReplace($sData, '(\R###Example###\R\h*@@IncludeExample@@)\h*\R', '')
			$iExtended = $ISINCLUDE_EXAMPLE_NONE ; @extended - Removed the line from the TXT doc.
		EndIf
	Else
		If $fExampleExists Then
			$iExtended = $ISINCLUDE_EXAMPLE_EXISTS ; @extended - Example exists but no line is included in the TXT doc.
		Else
			$fExampleExists = True
			$fReturn = True
		EndIf
	EndIf
	Return SetExtended($iExtended, $fReturn And $fExampleExists)
EndFunc   ;==>_Example_IsInclude

Func _GetExamplePath($sFilePath, $sExampleDir)
	Local Const $sFuncName = _WinAPI_PathRemoveExtension(_WinAPI_PathStripPath($sFilePath))
	Return _GetFullPath(_WinAPI_PathRemoveFileSpec($sFilePath) & '\..\..\' & $sExampleDir & '\' & $sFuncName & '.au3')
EndFunc   ;==>_GetExamplePath

Func _GetFullPath($sRelativePath, $sBasePath = @WorkingDir)
	Local Const $fSetWorkingDir = Not ($sBasePath = @WorkingDir), $sWorkingDir = @WorkingDir
	If $fSetWorkingDir Then FileChangeDir($sBasePath) ; Change the working directory of the current process to the base path as _WinAPI_GetFullPathName() merges the name of the current drive and directory with the specified file name.
	$sRelativePath = _WinAPI_GetFullPathName($sRelativePath)
	If $fSetWorkingDir Then FileChangeDir($sWorkingDir) ; Reset the working directory to the previous path.
	Return $sRelativePath
EndFunc   ;==>_GetFullPath

Func _GetSection(ByRef $sData, ByRef $sSection_Before, ByRef $sSection_Editable, ByRef $sSection_After, $sPattern)
	Local Const $SRE_MAX = 3
	Local $aSRE = StringRegExp($sData, $sPattern, 3)
	Local $fReturn = UBound($aSRE) = $SRE_MAX
	If $fReturn Then
		$sSection_Before = $aSRE[0]
		$sSection_Editable = $aSRE[1]
		$sSection_After = $aSRE[2]
	Else
		$sSection_Before = $sData
		$sSection_Editable = ''
		$sSection_After = ''
	EndIf
	Return $fReturn
EndFunc   ;==>_GetSection

Func _IsNone(ByRef $sData, $fIsNative = Default)
	If $fIsNative = Default Then $fIsNative = True
	If $sData And StringRegExp($sData, '(?i)^\h*\bNone\b\.?\h*$') Then
		$sData = 'None.'
	Else
		; If $sData = '' Then $sData = 'None.' & @CRLF
	EndIf
EndFunc   ;==>_IsNone

Func _IsTablesEnd(ByRef $sData)
	Local $fReturn = True
	StringRegExpReplace($sData, '(?im)^(?:@@(?:ControlCommand|Param|Return|Standard)Table(?:1)?@@\R)', '')
	Local Const $iCount = @extended
	If $iCount Then
		StringRegExpReplace($sData, '(?im)^(?:@@End@@\R)', '')
		$fReturn = @extended = $iCount
	EndIf
	Return $fReturn
EndFunc   ;==>_IsTablesEnd

Func _Macros_Tidy(ByRef $sData)
	Local $sDataOriginal = $sData
	$sData = StringReplace($sData, '@@IncludeExample@@', '@@IncludeExample@@')
	$sData = StringReplace($sData, '@@MsdnLink@@', '@@MsdnLink@@')
	$sData = StringReplace($sData, '@@End@@', '@@End@@')
	$sData = StringReplace($sData, '@@ControlCommandTable@@', '@@ControlCommandTable@@')
	$sData = StringReplace($sData, '@@ParamTable@@', '@@ParamTable@@')
	$sData = StringReplace($sData, '@@ReturnTable@@', '@@ReturnTable@@')
	$sData = StringReplace($sData, '@@StandardTable@@', '@@StandardTable@@')
	$sData = StringReplace($sData, '@@StandardTable1@@', '@@StandardTable1@@')
	Return Not ($sData == $sDataOriginal)
EndFunc   ;==>_Tags_Tidy

Func _Parameters_OptionalCheck(ByRef $sData, ByRef $aFuncParams, ByRef $aParamsTable, ByRef $sVariablesNotFound, $fIsNative = Default)
	If $fIsNative = Default Then $fIsNative = True
	If $fIsNative Then Return False
	$aParamsTable = 0
	$sVariablesNotFound = ''
	Local $fReturn = False
	Local $aParams = StringRegExp($sData, '(?ms)(^\$\w+)(\R.*?(?=\R\$|$))', 3)
	If @error Then Return SetError($PARAMS_OPTIONAL_NOPARAMTABLE, 0, $fReturn)
	; If Not (UBound($aFuncParams) = (UBound($aParams) / 2)) Then Return SetError($PARAMS_OPTIONAL_MISMATCH, 0, $fReturn)

	Local $hVarIndex = 0, $hVarIsOptional = 0
	_AssociativeArray_Startup($hVarIsOptional, False)
	_AssociativeArray_Startup($hVarIndex, False)
	For $i = 0 To UBound($aFuncParams) - 1 ; Create associative arrays for the array index value and variable value.
		If Not $hVarIsOptional.Exists($aFuncParams[$i][$PARAMS_VARIABLE]) Then $hVarIsOptional.Item($aFuncParams[$i][$PARAMS_VARIABLE]) = StringStripWS($aFuncParams[$i][$PARAMS_VALUEORDESC], $STR_STRIPALL)
		If Not $hVarIndex.Exists($aFuncParams[$i][$PARAMS_VARIABLE]) Then $hVarIndex.Item($aFuncParams[$i][$PARAMS_VARIABLE]) = $i
		$aFuncParams[$hVarIndex.Item($aFuncParams[$i][$PARAMS_VARIABLE])][$PARAMS_OPTIONAL] = $PARAMS_OPTIONAL_MISMATCH
	Next

	Local Const $OPTIONAL_START = 1
	Local $fIsOptional = False, _
			$sDescription = '', $sVariable = ''
	For $i = 0 To UBound($aParams) - 1 Step 2
		$sVariable = StringStripWS($aParams[$i + $PARAMS_VARIABLE], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
		$sDescription = StringStripWS($aParams[$i + $PARAMS_VALUEORDESC], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))

		If Not $hVarIsOptional.Exists($sVariable) Then
			$sVariablesNotFound &= $sVariable & ','
			ContinueLoop ; Variable in the parameter table doesn't exist in the syntax function.
		EndIf

		; Check if the parameter is actually optional or not.
		$fIsOptional = StringInStr($sDescription, $OPTIONAL, $STR_CASESENSE, 1) = $OPTIONAL_START
		If $fIsOptional And Not ($hVarIsOptional.Item($sVariable) == '') Then
			$aFuncParams[$hVarIndex.Item($sVariable)][$PARAMS_OPTIONAL] = $PARAMS_OPTIONAL_OK
		Else ; If optional table and function syntax mismatch.
			If $fIsOptional And $hVarIsOptional.Item($sVariable) == '' Then
				$aFuncParams[$hVarIndex.Item($sVariable)][$PARAMS_OPTIONAL] = $PARAMS_OPTIONAL_INTABLENOTFUNC
				$fReturn = False
			ElseIf Not $fIsOptional And Not ($hVarIsOptional.Item($sVariable) == '') Then
				$aFuncParams[$hVarIndex.Item($sVariable)][$PARAMS_OPTIONAL] = $PARAMS_OPTIONAL_INFUNCNOTTABLE
				$fReturn = False
			Else
				$aFuncParams[$hVarIndex.Item($sVariable)][$PARAMS_OPTIONAL] = $PARAMS_OPTIONAL_OK
			EndIf
		EndIf
	Next
	$aParamsTable = $aParams
	$aParams = 0
	$sVariablesNotFound = StringTrimRight($sVariablesNotFound, StringLen(','))
	Return $fReturn
EndFunc   ;==>_Parameters_OptionalCheck

Func _Related_FunctionSort(ByRef $sData, $fIsNative = Default)
	Local $sDataOriginal = $sData
	If $fIsNative = Default Then $fIsNative = True
	If Not StringStripWS($sData, $STR_STRIPALL) Then
		$sData = $fIsNative ? $sData : 'None.'
		Return Not ($sDataOriginal = $sData)
	EndIf
	If Not $fIsNative And StringRegExp($sData, '(?i)^\h*\bNone\b\.?\h*$') Then
		$sData = 'None.'
		Return Not ($sDataOriginal = $sData)
	EndIf

	Local $aFuncs = 0
	If $fIsNative Then
		$aFuncs = StringSplit($sData, ',', $STR_NOCOUNT) ; For native functions only.
		For $i = 0 To UBound($aFuncs) - 1
			$aFuncs[$i] = StringStripWS($aFuncs[$i], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
		Next
	Else
		$aFuncs = StringRegExp($sData, '(\$?\w+)', 3)
	EndIf
	_ArraySort($aFuncs)
	$aFuncs = _ArrayUnique($aFuncs)
	$sData = ''
	For $i = 1 To $aFuncs[0]
		If $fIsNative Then
			; Do nothing.
		Else
			; For native functions only where a prefix of a dot is required.
			If Not (StringLeft($aFuncs[$i], 1) == '.') And Not (StringLeft($aFuncs[$i], 1) == '_') And Not (StringLeft($aFuncs[$i], 1) == '$') Then
				$aFuncs[$i] = '.' & $aFuncs[$i]
			EndIf
		EndIf
		$sData &= $aFuncs[$i] & ', '
	Next
	If $sData Then $sData = StringTrimRight($sData, StringLen(', '))
	Return True
EndFunc   ;==>_Related_FunctionSort

Func _Section_Tidy(ByRef $sData) ; Tidy TXT files.
	Local $sDataOriginal = $sData
	_ConvertEOLToCRLF($sData)
	_StripTrailingWhitespace($sData)

	; Adding correct number of spaces between the sections.
	Local $aFileRead = StringSplit($sData, @CRLF, BitOR($STR_ENTIRESPLIT, $STR_NOCOUNT))
	For $i = 0 To UBound($aFileRead) - 1
		; Check if the line is a header and mark with $ASCII_ACK.
		Switch StringStripWS($aFileRead[$i], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
			Case '###Function###', '###Keyword###', '###User Defined Function###', '###Macro###', '###Operator###', _
					'###Description###', _
					'###Syntax###', _
					'###Parameters###', _
					'###ReturnValue###', _
					'###Remarks###', _
					'###Related###', _
					'###Example###', _
					'###Fields###', '###See Also###', '###Structure Name###'
				$aFileRead[$i] = $ASCII_ACK & StringStripWS($aFileRead[$i], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
			Case Else
				; Nothing Else.
		EndSwitch
	Next

	$sData = _ArrayToString($aFileRead, @CRLF)

	Local $sAppend = '', $sSection = ''
	; Strip @CRLF from sections and append the appropriate number of @CRLFs.
	$aFileRead = StringRegExp($sData, '(?s)(\x{6}.*?(?=\x{6}))', 3)

	For $i = 0 To UBound($aFileRead) - 1
		$sSection = $aFileRead[$i]
		_StripACK($sSection)
		If StringRegExp($sSection, '(?i)^###(Function|Keyword|User Defined Function|Macro|Operator|Description|Fields|Parameters|Structure Name)###') Then
			$sAppend = @CRLF & @CRLF
		Else
			$sAppend = @CRLF & @CRLF & @CRLF
		EndIf
		$sSection = $aFileRead[$i]

		; Remove empty lines after the section header.
		$aFileRead[$i] = StringRegExpReplace($aFileRead[$i], '(\x{6}###.*?###\R)\R*', '\1')

		; Remove empty lines at the end of the section.
		_StripEndOfLines($aFileRead[$i])
		$aFileRead[$i] &= $sAppend
		$sData = StringReplace($sData, $sSection, $aFileRead[$i], 1)
	Next
	$sAppend = ''
	$sSection = ''

	; Strip $ASCII_ACK.
	_StripACK($sData)

	; Remove empty lines at the end of a file.
	_StripEndOfLines($sData)

	; Append @CRLF.
	$sData &= @CRLF

	Return Not ($sData == $sDataOriginal)
EndFunc   ;==>_Section_Tidy

Func _SetSection(ByRef $sData, ByRef $sSection_Before, ByRef $sSection_Editable, ByRef $sSection_After)
	Local $fReturn = $sData == $sSection_Before & $sSection_Editable & $sSection_After ? False : True
	$sData = $sSection_Before & $sSection_Editable & $sSection_After
	$sSection_Before = ''
	$sSection_Editable = ''
	$sSection_After = ''
	Return $fReturn
EndFunc   ;==>_SetSection

Func _SetFileData($sFilePathOld, $sFilePathNew, $sDataOriginal, ByRef $sDataNew)
	Local $fReturn = False
	If Not ($sDataOriginal == $sDataNew) Then
		Local Const $iFileEncoding = FileGetEncoding($sFilePathOld)
		Local Const $hFileOpen = FileOpen($sFilePathNew, BitOR($FO_OVERWRITE, $iFileEncoding))
		If $hFileOpen > -1 Then
			$fReturn = FileWrite($hFileOpen, $sDataNew) = 1
			FileClose($hFileOpen)
		EndIf
	EndIf
	Return $fReturn
EndFunc   ;==>_SetFileData

Func _StripACK(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\x{6}', '')
EndFunc   ;==>_StripACK

Func _StripEndOfLines(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\v+$', '')
EndFunc   ;==>_StripEndOfLines

Func _StripTrailingWhitespace(ByRef $sData)
	$sData = StringRegExpReplace($sData, '\h+(?=\R)', '') ; Trailing whitespace. By DXRW4E.
EndFunc   ;==>_StripTrailingWhitespace

Func _Syntax_FunctionAndParamsTidy(ByRef $sData, ByRef $aFuncParams, $fIsNative = Default) ; $aFuncParams to be used when checking [optional].
	$aFuncParams = 0
	If $fIsNative = Default Then $fIsNative = True
	If $fIsNative Then Return False
	; If not "FuncName (" then return False.
	If Not StringRegExp($sData, '^\h*\w+\h*\(') Then Return False
	; Get function name.
	Local Const $aFuncName = StringRegExp($sData, '^\w+', 3)
	If @error Then Return False
	Local Const $sFuncName = $aFuncName[0]

	; Store string literals temporarily.
	Local $aStrings = StringRegExp($sData, '(([''"])\V*?\2)', 3)
	For $i = 0 To UBound($aStrings) - 1 Step 2
		$sData = StringReplace($sData, $aStrings[$i], $ASCII_ACK, $STR_REPLACE_ONCE, $STR_CASESENSE)
	Next

	Local $sParams = StringRegExpReplace($sData, '(?:^\w*\h*\(\h*\[?|\h*\]*\h*\)\h*$)', '') ; Strip FuncName ( [ ... AND/OR .... ]]]] )
	Local $iBracket = 0, $iIndex = 0, $iParam = $PARAMS_VARIABLE

	StringReplace($sParams, ',', ',')
	Local $aParams[@extended + 1][$PARAMS_MAX]

	Local $iBrackets = 0, _
			$sChr = '', $sParamString = ''
	For $i = 1 To StringLen($sParams)
		$sChr = StringMid($sParams, $i, 1)
		Switch $sChr
			Case '('
				$iBracket += 1
			Case ')'
				$iBracket -= 1
			Case ','
				If Not $iBracket Then
					$aParams[$iIndex][$iParam] = StringRegExpReplace($aParams[$iIndex][$iParam], '\h*\[$', '')
					$iIndex += 1
					$iParam = $PARAMS_VARIABLE
					ContinueLoop
				EndIf
			Case '='
				If $iParam = $PARAMS_VARIABLE Then
					$iParam = $PARAMS_VALUEORDESC
					$sChr = ''
				EndIf
		EndSwitch
		$aParams[$iIndex][$iParam] &= $sChr
	Next

	$iBrackets = 0
	For $i = 0 To $iIndex ; Tidy up param array.
		$aParams[$i][$PARAMS_VARIABLE] = StringStripWS($aParams[$i][$PARAMS_VARIABLE], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
		$aParams[$i][$PARAMS_VALUEORDESC] = StringStripWS($aParams[$i][$PARAMS_VALUEORDESC], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))

		If $i = 0 And $aParams[$i][$PARAMS_VALUEORDESC] Then $sParamString &= '['
		$sParamString &= ((Not ($i = 0) And $aParams[$i][$PARAMS_VALUEORDESC]) ? ' [, ' : ', ') & $aParams[$i][$PARAMS_VARIABLE] & ($aParams[$i][$PARAMS_VALUEORDESC] ? ' = ' & $aParams[$i][$PARAMS_VALUEORDESC] : '')
		If $aParams[$i][$PARAMS_VALUEORDESC] Then $iBrackets += 1
	Next
	$aFuncParams = $aParams

	; Strip first comma or bracket.
	$sParamString = StringStripWS($sParamString, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
	If StringLeft($sParamString, StringLen('[, ')) == '[, ' Then $sParamString = '[' & StringTrimLeft($sParamString, StringLen('[, '))
	If StringLeft($sParamString, StringLen(', ')) = ', ' Then $sParamString = StringTrimLeft($sParamString, StringLen(', '))
	$sParamString = $sParamString & ($iBrackets ? _StringRepeat(']', $iBrackets) : '')
	If $sParamString = ',' Then $sParamString = ''

	For $i = 0 To UBound($aFuncParams) - 1
		$aFuncParams[$i][$PARAMS_VARIABLE] = StringRegExpReplace($aFuncParams[$i][$PARAMS_VARIABLE], '.*(\$\w*).*', '\1')
	Next

	; Re-build string literals using stored array.
	For $i = 0 To UBound($aStrings) - 1 Step 2
		$sParamString = StringReplace($sParamString, $ASCII_ACK, $aStrings[$i], $STR_REPLACE_ONCE, $STR_CASESENSE)
		For $j = 0 To UBound($aFuncParams) - 1
			For $k = 0 To UBound($aFuncParams, $UBOUND_COLUMNS) - 1
				$aFuncParams[$j][$k] = StringReplace($aFuncParams[$j][$k], $ASCII_ACK, $aStrings[$i], $STR_REPLACE_ONCE, $STR_CASESENSE)
				If @extended Then ExitLoop 2
			Next
		Next
	Next

	$sData = $sFuncName & ' ( ' & $sParamString & ' )'
	Return True
EndFunc   ;==>_Syntax_FunctionAndParamsTidy

Func _Syntax_Include(ByRef $sData, ByRef $sInclude_Before, ByRef $sInclude_After, $fIsNative = Default, $sBaseDir = @WorkingDir)
	$sInclude_After = ''
	$sInclude_Before = ''

	If $fIsNative = Default Then $fIsNative = True
	If $fIsNative Then Return False
	Local Static $hIncludes = 0

	If Not IsObj($hIncludes) Then
		_AssociativeArray_Startup($hIncludes)
		Local $aIncludes = _FileListToArray(_GetFullPath($INCLUDESOURCE, $sBaseDir), '*.au3', 1, True)
		If UBound($aIncludes) Then
			Local $sFilePath = ''
			For $i = 1 To $aIncludes[0]
				$sFilePath = _WinAPI_PathStripPath($aIncludes[$i])
				$hIncludes.Item($sFilePath) = $sFilePath
			Next
		EndIf
		$aIncludes = -1
	EndIf
	Local Const $aSRE = StringRegExp($sData, '(?i)#include\h*["''<](.*?)["''>]\s*', 3)
	If @error Then Return SetError($SYNTAX_INCLUDE_NO_LINE, 0, False)

	$sInclude_Before = StringStripWS($aSRE[0], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
	If Not $hIncludes.Exists($sInclude_Before) Then
		$sInclude_Before = ''
		Return SetError($SYNTAX_INCLUDE_NO_FILE, 0, False)
	EndIf

	$sInclude_After = $hIncludes.Item($sInclude_Before)
	$sData = '#include <' & $sInclude_After & '>'
	Return True
EndFunc   ;==>_Syntax_Include

Func _Tables_Tidy(ByRef $sData)
	Local $iExtended = 0
	$sData = StringRegExpReplace($sData, '(?i)((@@(?:ControlCommand|Param|Return|Standard)Table(?:1)?@@))\R{2,}', '\1' & @CRLF)
	$iExtended += @extended
	$sData = StringRegExpReplace($sData, '(?i)\R{2,}(@@End@@)', @CRLF & '\1')
	$iExtended += @extended
	Return $iExtended > 0
EndFunc   ;==>_Tables_Tidy

Func _Tags_Tidy(ByRef $sData)
	Local $iExtended = 0
	$sData = StringReplace($sData, '<i>', '<em>', 0, $STR_CASESENSE)
	$iExtended += @extended
	$sData = StringReplace($sData, '</i>', '</em>', 0, $STR_CASESENSE)
	$iExtended += @extended
	$sData = StringReplace($sData, '<b>', '<strong>', 0, $STR_CASESENSE)
	$iExtended += @extended
	$sData = StringReplace($sData, '</b>', '</strong>', 0, $STR_CASESENSE)
	$iExtended += @extended
	Return $iExtended > 0
EndFunc   ;==>_Tags_Tidy

Func _URLLinks_FormatAndCheck(ByRef $sData, $fIsNative = Default)
	If $fIsNative = Default Then $fIsNative = True
	Local $aLinks = StringRegExp($sData, 'href=(["''])(.*?)\1', 3), _
			$sHTML = '', $sTXT = '', $sURL = ''

	Local $hLinksErrors = 0, _
			$iExtended = 0
	_AssociativeArray_Startup($hLinksErrors, True)
	For $i = 0 To UBound($aLinks) - 1 Step 2
		$sURL = $aLinks[$i + 1]
		If $sURL Then
			$sURL = StringReplace($sURL, '\', '/')
			$iExtended += @extended
			$sData = StringReplace($sData, $sURL, $sURL, 1, $STR_CASESENSE) ; Format links to use forward slash(s) instead of back slash(s).
			If Not _WinAPI_UrlIs($sURL) And Not StringInStr($sURL, 'Management.htm') Then
				$sHTML = $sURL

				$sHTML = StringRegExpReplace($sHTML, '#.*$', '') ; IDs.
				$sHTML = StringReplace($sHTML, '../', '')
				$sHTML = StringReplace($sHTML, 'libfunctions/', '')
				$sHTML = StringReplace($sHTML, 'functions/', '')
				$sHTML = StringReplace($sHTML, 'keywords/', '')

				$sTXT = StringRegExpReplace($sHTML, '\.htm(?:l)?$', '.txt')

				$sHTML = _WinAPI_PathFindOnPath($sHTML, $PFOP_PATHS)
				$sTXT = _WinAPI_PathFindOnPath($sTXT, $PFOP_PATHS)

				If Not FileExists($sTXT) And Not FileExists($sHTML) Then
					$hLinksErrors.Item($sURL) = $sURL
				EndIf
			EndIf
		EndIf
	Next
	Local Const $aLinksErrors = $hLinksErrors.Items()
	Return SetError(UBound($aLinksErrors) + $iExtended, $iExtended, $aLinksErrors)
EndFunc   ;==>_URLLinks_FormatAndCheck
