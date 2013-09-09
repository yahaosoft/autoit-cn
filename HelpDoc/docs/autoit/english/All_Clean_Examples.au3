;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author: jpm
; Email : jpm@autoitscript.com
;
; Script Function:
; Cleaning old unreferenced .htm files from examples or html dirs

#include "..\..\_build\include\OutputLib.au3"
#include <Constants.au3>

Opt("TrayIconDebug", 1)

Global $INPUT_DIR
Global $OUTPUT_DIR
Global $TEMP_LIST = "fileList.tmp"

_OutputBuildWrite("Scanning AutoIt old .htm  ..." & @CRLF)

FileChangeDir(@ScriptDir)

$INPUT_DIR = IniRead("txt2htm.ini", "Input", "examples", "ERR")
$OUTPUT_DIR = IniRead("txt2htm.ini", "Output", "examples", "ERR")
Clean("examples", 1)

$INPUT_DIR = IniRead("txt2htm.ini", "Input", "libexamples", "ERR")
$OUTPUT_DIR = IniRead("txt2htm.ini", "Output", "examples", "ERR")
Clean("libexamples", -1)

$INPUT_DIR = IniRead("txt2htm.ini", "Input", "functions", "ERR")
$OUTPUT_DIR = IniRead("txt2htm.ini", "Output", "functions", "ERR")
Clean("functions")

$INPUT_DIR = IniRead("txt2htm.ini", "Input", "keywords", "ERR")
$OUTPUT_DIR = IniRead("txt2htm.ini", "Output", "keywords", "ERR")
Clean("keywords")

$INPUT_DIR = IniRead("txt2htm.ini", "Input", "libfunctions", "ERR")
$OUTPUT_DIR = IniRead("txt2htm.ini", "Output", "libfunctions", "ERR")
;~ Clean("libfunctions")

FileDelete($TEMP_LIST)

_OutputBuildWrite("Finished" & @CRLF & @CRLF)
Exit

Func Clean($indir, $bIgnore = 0)
	#forceref $indir
	;pipe the list of sorted file names to fileList.tmp:
	_RunCmd("dir " & $OUTPUT_DIR & "*.htm /b | SORT > " & $TEMP_LIST)
	Local $hFileList = FileOpen($TEMP_LIST, $FO_READ) ;read mode
	If $hFileList = -1 Then
		MsgBox($MB_SYSTEMMODAL, "Error", $TEMP_LIST & " could not be opened and/or found.")
		Exit
	EndIf

	Local $Filename, $path, $pathin
	While 1 ;loop thru each filename contained in fileOutList.tmp
		$Filename = FileReadLine($hFileList)
		If @error = -1 Then ExitLoop ;EOF reached
		$path = $OUTPUT_DIR & $Filename
		If $Filename = "CVS" Then ContinueLoop ; Skip CVS
		If $Filename = "Changelog.txt" Then ContinueLoop ; Skip ChangeLog.txt
		If StringStripWS($path, 3) = "" Then ExitLoop

		Switch $bIgnore
			Case 1
				If StringLeft($Filename, 1) = "_" Then ContinueLoop ; skip UDF Examples
			Case -1
				If StringLeft($Filename, 1) <> "_" Then ContinueLoop ; skip AutoIt Examples
			Case 0
				If StringInStr($Filename, " Management") Then ContinueLoop ; skip generated TOC
				If StringInStr($Filename, " Reference") Then ContinueLoop ; skip generated TOC
		EndSwitch

		If Not FileExists($path) Then
			FileWriteLine(@ScriptDir & "\txt2htm_error.log", $path & " WAS not found; skipping it.")
			ContinueLoop
		EndIf

		If $bIgnore Then
			$pathin = $INPUT_DIR & StringTrimRight($Filename, 8) & ".au3" ; strip .txt.htm suffix
		Else
			$pathin = $INPUT_DIR & StringTrimRight($Filename, 4) & ".txt" ; strip .htm suffix
		EndIf

		If Not FileExists($pathin) Then
			FileDelete($path)
			_OutputBuildWrite($path & @CRLF)
		EndIf

	WEnd

	FileClose($hFileList)
EndFunc   ;==>Clean

; ------------------------------------------------------------------------------
; Run DOS/console commands
; ------------------------------------------------------------------------------
Func _RunCmd($command)
	FileWriteLine("brun.bat", $command & " > " & $TEMP_LIST)
	RunWait(@ComSpec & " /c brun.bat", "", @SW_HIDE)
	FileDelete("brun.bat")
	Return
EndFunc   ;==>_RunCmd
