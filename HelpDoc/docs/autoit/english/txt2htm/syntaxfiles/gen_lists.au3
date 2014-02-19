#include '..\..\..\..\_build\include\MiscLib.au3'
#include <Array.au3>
#include <File.au3>

Global Const $ASCII_ACK = Chr(6)

CreateLists()

; ------------------------------------------------------------------------------
; Wrapper function for creating the syntax lists.
; ------------------------------------------------------------------------------
Func CreateLists()
	Local Const $FUNCTIONLIST = @ScriptDir & "\functions.txt", $FUNCTIONLIST_FULL = @ScriptDir & "\function_full.txt", _
			$KEYWORDLIST = @ScriptDir & "\keywords.txt", _
			$LIBFUNCTIONLIST = @ScriptDir & "\libfunctions.txt", $LIBFUNCTIONLIST_FULL = @ScriptDir & "\libfunctions_full.txt", _
			$MACROLIST = @ScriptDir & "\macros.txt", $MACROLIST_FULL = @ScriptDir & "\macros_full.txt"

	; Do the functions and UDF functions lists.
	DoFunctions(@ScriptDir & "\..\txtFunctions", $FUNCTIONLIST, @ScriptDir & "\function_params.txt", $FUNCTIONLIST_FULL, False)
	DoFunctions(@ScriptDir & "\..\txtlibFunctions", $LIBFUNCTIONLIST, @ScriptDir & "\libfunction_params.txt", $LIBFUNCTIONLIST_FULL, True)

	; Do the macros
	DoMacros($MACROLIST, $MACROLIST_FULL)

	; Now the keywords (static).
	Local $hFileOpen = 0
	If Not FileExists($KEYWORDLIST) Then ; In case it doesn't exist, but at the end must be removed.
		$hFileOpen = FileOpen($KEYWORDLIST, $FO_OVERWRITE)
		FileWriteLine($hFileOpen, "And")
		FileWriteLine($hFileOpen, "ByRef")
		FileWriteLine($hFileOpen, "Case")
		FileWriteLine($hFileOpen, "Const")
		FileWriteLine($hFileOpen, "ContinueCase")
		FileWriteLine($hFileOpen, "ContinueLoop")
		FileWriteLine($hFileOpen, "Default")
		FileWriteLine($hFileOpen, "Dim")
		FileWriteLine($hFileOpen, "Do")
		FileWriteLine($hFileOpen, "Else")
		FileWriteLine($hFileOpen, "ElseIf")
		FileWriteLine($hFileOpen, "EndFunc")
		FileWriteLine($hFileOpen, "EndIf")
		FileWriteLine($hFileOpen, "EndSelect")
		FileWriteLine($hFileOpen, "EndSwitch")
		FileWriteLine($hFileOpen, "EndWith")
		FileWriteLine($hFileOpen, "Enum")
		FileWriteLine($hFileOpen, "Exit")
		FileWriteLine($hFileOpen, "ExitLoop")
		FileWriteLine($hFileOpen, "False")
		FileWriteLine($hFileOpen, "For")
		FileWriteLine($hFileOpen, "Func")
		FileWriteLine($hFileOpen, "Global")
		FileWriteLine($hFileOpen, "If")
		FileWriteLine($hFileOpen, "In")
		FileWriteLine($hFileOpen, "Local")
		FileWriteLine($hFileOpen, "Next")
		FileWriteLine($hFileOpen, "Not")
		FileWriteLine($hFileOpen, "Null")
		FileWriteLine($hFileOpen, "Or")
		FileWriteLine($hFileOpen, "ReDim")
		FileWriteLine($hFileOpen, "Return")
		FileWriteLine($hFileOpen, "Select")
		FileWriteLine($hFileOpen, "Static")
		FileWriteLine($hFileOpen, "Step")
		FileWriteLine($hFileOpen, "Switch")
		FileWriteLine($hFileOpen, "Then")
		FileWriteLine($hFileOpen, "To")
		FileWriteLine($hFileOpen, "True")
		FileWriteLine($hFileOpen, "Until")
		FileWriteLine($hFileOpen, "Volatile")
		FileWriteLine($hFileOpen, "WEnd")
		FileWriteLine($hFileOpen, "While")
		FileWriteLine($hFileOpen, "With")
		FileWriteLine($hFileOpen, "#ce")
		FileWriteLine($hFileOpen, "#comments-end")
		FileWriteLine($hFileOpen, "#comments-start")
		FileWriteLine($hFileOpen, "#cs")
		FileWriteLine($hFileOpen, "#EndRegion")
		FileWriteLine($hFileOpen, "#forcedef")
		FileWriteLine($hFileOpen, "#forceref")
		FileWriteLine($hFileOpen, "#ignorefunc")
		FileWriteLine($hFileOpen, "#include")
		FileWriteLine($hFileOpen, "#include-once")
		FileWriteLine($hFileOpen, "#NoTrayIcon")
		FileWriteLine($hFileOpen, "#OnAutoItStartRegister")
		FileWriteLine($hFileOpen, "#pragma")
		FileWriteLine($hFileOpen, "#Region")
		FileWriteLine($hFileOpen, "#RequireAdmin")
		FileClose($hFileOpen)
	EndIf

	; Add extra functions
	$hFileOpen = FileOpen($FUNCTIONLIST, $FO_APPEND)
	FileWriteLine($hFileOpen, "")
	FileWriteLine($hFileOpen, "Opt")
	FileWriteLine($hFileOpen, "UDPStartup")
	FileWriteLine($hFileOpen, "UDPShutdown")
	FileClose($hFileOpen)
EndFunc   ;==>CreateLists

; ------------------------------------------------------------------------------
; Makes a list of the functions and their parameters. Designed for native and UDF functions.
; ------------------------------------------------------------------------------
Func DoFunctions($sFunctionPath, $sFunctionListOut, $sFunctionParamsOut, $sFunctionFullOut, $fUDFLibrary = Default)
	If $fUDFLibrary = Default Then $fUDFLibrary = False

	; Change directory to the functions text file(s)
	FileChangeDir($sFunctionPath)

	; Pipe the list of sorted file names to fileList.tmp:
	Local $sTempList = @ScriptDir & "\fileList.tmp"
	_RunCmd('dir /b /o:N > "' & $sTempList & '"')

	Local $hFileOpen = FileOpen($sTempList, $FO_READ)
	If $hFileOpen = -1 Then
		Exit MsgBox($MB_SYSTEMMODAL, "AutoIt", "Error opening temp list.")
	EndIf
	Local $sFunctionList = FileRead($hFileOpen)
	FileClose($hFileOpen)
	FileDelete($sTempList) ; Delete the temporary file.

	Local $sSREPattern = "(?m)^(\w+)"
	If $fUDFLibrary Then $sSREPattern = "(?m)^((?!_aaaStandard)_\w+)"

	Local $aSRE = StringRegExp($sFunctionList, $sSREPattern, 3), _ ; Parse the temp file for whole words at the start of a line i.e. functions.
			$sDescription = "", $sFunctionListParams = "", $sFunctionListFull = "", $sParams
	$sFunctionList = ""
	For $i = 0 To UBound($aSRE) - 1 ; Create a list of functions and function parameters.
		$sFunctionList &= $aSRE[$i] & @CRLF ; Function list.
		$sParams = GetFunctionParams($aSRE[$i] & ".txt", $sDescription, $fUDFLibrary)
		$sFunctionListParams &= $sParams & " " & $sDescription & @CRLF ; Function parameter list.
		$sFunctionListFull &= $aSRE[$i] & $ASCII_ACK & $sParams & $ASCII_ACK & $sDescription & $ASCII_ACK & @CRLF
	Next
	_StripEmptyLinesEndOfFile($sFunctionList)
	_StripEmptyLinesEndOfFile($sFunctionListParams)
	_StripEmptyLinesEndOfFileACK($sFunctionListFull)

	; Write the output
	$hFileOpen = FileOpen($sFunctionListOut, $FO_OVERWRITE)
	FileWrite($hFileOpen, $sFunctionList)
	FileClose($hFileOpen)

	; Write the output
	$hFileOpen = FileOpen($sFunctionParamsOut, $FO_OVERWRITE)
	FileWrite($hFileOpen, $sFunctionListParams)
	FileClose($hFileOpen)

	; Write the output for the full list of functions<ACK>params<ACK>description<ACK>CRLF. Chr(6) or ACK is used as a delimiter.
	$hFileOpen = FileOpen($sFunctionFullOut, $FO_OVERWRITE)
	FileWrite($hFileOpen, $sFunctionListFull)
	FileClose($hFileOpen)
EndFunc   ;==>DoFunctions

; ------------------------------------------------------------------------------
; Make a list of macros
; ------------------------------------------------------------------------------
Func DoMacros($sMacroListOut, $sMacroFullOut)
	FileChangeDir(@ScriptDir)

	Local Const $sMacroPath = "..\..\html\macros"
	Local $aFileList = _FileListToArray($sMacroPath, "*.htm")
	If @error Then
		Exit MsgBox($MB_SYSTEMMODAL, "AutoIt", "Error opening macros.html.")
	EndIf

	Local $sData = ''
	; Read the macro files.
	For $i = 1 To $aFileList[0]
		$sData &= FileRead($sMacroPath & '\' & $aFileList[$i])
	Next

	Local $aMacroList = 0, $hMacroList = 0
	; Generate a 2d array of macros.
	_MacroListToArray($sData, $aMacroList, $hMacroList)

	Local $sMacroList = "", $sMacroListFull = ""
	For $i = 1 To $aMacroList[0][0]
		$sMacroList &= $aMacroList[$i][0] & @CRLF
		$sMacroListFull &= $aMacroList[$i][0] & $ASCII_ACK & $aMacroList[$i][1] & $ASCII_ACK & @CRLF
	Next
	_StripEmptyLinesEndOfFile($sMacroList)
	_StripEmptyLinesEndOfFile($sMacroList)
	_StripEmptyLinesEndOfFileACK($sMacroListFull)

	; Write the output
	Local $hFileOpen = FileOpen($sMacroListOut, $FO_OVERWRITE)
	FileWrite($hFileOpen, $sMacroList)
	FileClose($hFileOpen)

	; Write the output.
	$hFileOpen = FileOpen($sMacroFullOut, $FO_OVERWRITE)
	FileWrite($hFileOpen, $sMacroListFull)
	FileClose($hFileOpen)
EndFunc   ;==>DoMacros
#include <MsgBoxConstants.au3>
; ------------------------------------------------------------------------------
; Retrieve the ###Description### and ###Syntax### entries of a file.
; ------------------------------------------------------------------------------
Func GetFunctionParams($sFilePath, ByRef $sDescription, $fUDFLibrary = Default)
	Local Enum $eSRE_Description, $eSRE_IncludeOrSyntax, $eSRE_Syntax, $eSRE_Max
	If $fUDFLibrary = Default Then $fUDFLibrary = False

	Local $sData = FileRead($sFilePath)
	_StripEmptyLines($sData)
	_StripWhitespace($sData)

	$sDescription = ""
	Local $sLine = ""
	Local $aSRE = StringRegExp($sData, "###Description###\R(\V*)\R*###Syntax###\R(\V*)\R(\V*)", 3)
	If UBound($aSRE) = $eSRE_Max Then
		$sDescription = $aSRE[$eSRE_Description]
		_ConvertHTMLEntityToSymbols($sDescription)
		If $fUDFLibrary Then
			$sDescription &= " (Requires: " & $aSRE[$eSRE_IncludeOrSyntax] & ")"
			$sLine = $aSRE[$eSRE_Syntax]
		Else
			$sLine = $aSRE[$eSRE_IncludeOrSyntax]
		EndIf

	EndIf
	Return $sLine
EndFunc   ;==>GetFunctionParams

; ------------------------------------------------------------------------------
; Run DOS/console commands
; ------------------------------------------------------------------------------
Func _RunCmd($sCommand)
	Return RunWait(@ComSpec & " /c " & $sCommand, "", @SW_HIDE)
EndFunc   ;==>_RunCmd

; ------------------------------------------------------------------------------
; Remove blanks lines at the end of the file and append a single @CRLF.
; ------------------------------------------------------------------------------
Func _StripEmptyLinesEndOfFileACK(ByRef $sData, $sAppend = "")
	$sData = StringRegExpReplace($sData, "\x{6}\v*$", "") & $sAppend
EndFunc   ;==>_StripEmptyLinesEndOfFileACK
