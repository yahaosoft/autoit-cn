; ===================================================================
; Project: DocLib Library
; Description: Functions for building the AutoIt documentation.
; Author: Jason Boggs <vampire DOT valik AT gmail DOT com>
; ===================================================================
#include-once

#Region Members Exported
#cs Exported Functions
CompileDocumentation($sProject, $sWorkingDir = @WorkingDir) - Compiles documentation for the specified project.
CleanUnreferenced($sInputDir, $sOutputDir, $nIgnoreMode = $IGNORE_MANAGEMENT) - Cleans unreferenced HTM files.
#ce Exported Functions
#EndRegion Members Exported

#Region Includes
#include "OutputLib.au3"
#include "UtilityLib.au3"
#include <Array.au3>
#include <File.au3>
#EndRegion Includes

#Region Global Variables
Global Enum $IGNORE_MANAGEMENT, $IGNORE_UDFS, $IGNORE_BUILTIN
#EndRegion Global Variables

#Region Library Initialization

#EndRegion Library Initialization

#Region Public Members

#Region CompileDocumentation()
; ===================================================================
; CompileDocumentation($sProject, $sWorkingDir = @WorkingDir)
;
; Compiles documentation for the specified project.
; Parameters:
;	$sProject - IN - The project file to compile.
;	$sWorkingDir - IN/OPTIONAL - The working directory to pass to the compiler.
; Returns:
;	Success - The return value of the compile command.
;	Failure - Sets @error to non-zero and returns 0.
; ===================================================================
Func CompileDocumentation($sProject, $sWorkingDir = @WorkingDir)
	; Store the command to execute.
	Local $sCmd

	; Retrieve the ProgID for HTML Help Project files.
	Local $sProgId = RegRead("HKCR\.hhp", "")

	; If a ProgID exists then get the compiler command from it.  Otherwise default to a location.
	If $sProgId Then
		$sCmd = StringReplace(StringTrimRight(RegRead("HKCR\" & $sProgId & "\shell\open\command", ""), 4), "hhw.exe", "hhc.exe")
	Else
		$sCmd = @ProgramFilesDir & "\HTML Help Workshop\HHC.exe"
	EndIf

	; Strip any quotation marks from the command string.
	$sCmd = StringReplace($sCmd, '"', "")

	; Run the command forwarding any output to the build window.
	Local $nResult = _RunWaitForwardOutput("_OutputBuildWriteLineError", '"' & $sCmd & '" "' & $sProject & '"', $sWorkingDir, @SW_HIDE)
	FileDelete(@TempDir & "\~hh*.tmp") ; file left by hhc.exe
	SetError(Not $nResult)
	Return SetError(@error, @extended, $nResult)
EndFunc   ;==>CompileDocumentation
#EndRegion CompileDocumentation()

#Region CleanUnreferenced()
; ===================================================================
; CleanUnreferenced($sInputDir, $sOutputDir, $nIgnoreMode = $IGNORE_MANAGEMENT)
;
; Cleans unreferenced HTM files.
; Parameters:
;	$sInputDir - IN - The input directory.
;	$sOutputDir - IN - The output directory.
;	$nIgnoreMode - IN/OPTIONAL - Ignore mode to use (one of $IGNORE_* constants).
; Returns:
;	The number of files cleaned.
; ===================================================================
Func CleanUnreferenced($sInputDir, $sOutputDir, $nIgnoreMode = $IGNORE_MANAGEMENT)
	_OutputBuildWrite("Scanning for old .htm files..." & @CRLF)

	If Not StringRight($sInputDir, 1) = "\" Then $sInputDir &= "\"
	If Not StringRight($sOutputDir, 1) = "\" Then $sOutputDir &= "\"

	Local $aFiles = _FileListToArray($sOutputDir, "*.htm", 1)
	_ArraySort($aFiles, 0, 1)

	Local $sInputPath, $sOutputPath, $nCleaned = 0
	For $sFile In $aFiles
		; Skip the count parameter at element 0.
		If IsNumber($sFile) Then ContinueLoop

		; Build the output path.
		$sOutputPath = $sOutputDir & $sFile

		; Determine which files to ignore and build the name of the input file depending
		; on the type of output file that is ignored.
		Switch $nIgnoreMode
			Case $IGNORE_MANAGEMENT
				If StringInStr($sFile, " Management") Then ContinueLoop ; skip generated TOC
				$sInputPath = $sInputDir & StringTrimRight($sFile, 4) & ".txt"
			Case $IGNORE_UDFS
				If StringLeft($sFile, 1) = "_" Then ContinueLoop ; skip UDF Examples
				$sInputPath = $sInputDir & StringTrimRight($sFile, 8) & ".au3"
			Case $IGNORE_BUILTIN
				If StringLeft($sFile, 1) <> "_" Then ContinueLoop ; skip AutoIt Examples
				$sInputPath = $sInputDir & StringTrimRight($sFile, 8) & ".au3"
		EndSwitch

		; Ensure the output file exists (Should never happen).
		If Not FileExists($sOutputPath) Then
			_OutputBuildWrite("Unable to find " & $sOutputPath & ", skipping." & @CRLF)
			ContinueLoop
		EndIf

		; If the input does not exist delete the output file.
		If Not FileExists($sInputPath) Then
			$nCleaned += 1
			FileDelete($sOutputPath)
			_OutputBuildWrite("Removing " & $sOutputPath & "." & @CRLF)
		EndIf
	Next

	; Return the number of files cleaned.
	Return $nCleaned
EndFunc   ;==>CleanUnreferenced
#EndRegion CleanUnreferenced()

#EndRegion Public Members

#Region Private Members


#EndRegion Private Members
