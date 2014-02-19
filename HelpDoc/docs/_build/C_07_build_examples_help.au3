;
; Builds AutoIt3 help file
;

#Region Includes
#include "include\CompileLib.au3"
#EndRegion Includes

#Region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "AutoIt Example Help"
Global Const $g_sProjectDir = "docs\autoit"
#EndRegion Global Variables

#Region Main body of code
Global $g_nExitCode = _Main()
Exit $g_nExitCode
#EndRegion Main body of code

#Region _Main()
; ===================================================================
; _Main()
;
; The main function responsible for generating the syntax files.
; Parameters:
;	None
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func _Main()
	; Create the output window and initial message.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $g_sProject & ") ====" & @CRLF)
	_OutputProgressWrite("Copying " & $g_sProject & " files." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; clean helpfile dirs
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Clean_Examples.au3')

	; Copy the files install
	FileChangeDir($gBuildDir)

	; Helpfile examples too
	DirRemove("install\Examples\Helpfile", 1)
	DirCreate("install\Examples\Helpfile")
	FileCopy($g_sProjectDir & "\" & $g_sProjectLang & '\txt2htm\examples\*.au3', 'install\Examples\Helpfile\*.au3')
	FileCopy($g_sProjectDir & "\" & $g_sProjectLang & '\txt2htm\libExamples\*.au3', 'install\Examples\Helpfile\*.au3')
	FileCopy($g_sProjectDir & "\" & $g_sProjectLang & '\txt2htm\libExamples\Test.*', 'install\Examples\Helpfile\')
	DirCreate("install\Examples\Helpfile\Extras")
	FileCopy($g_sProjectDir & "\" & $g_sProjectLang & '\txt2htm\libExamples\Extras\*.*', 'install\Examples\Helpfile\Extras\')

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	_OutputWaitClosed()

	Return 0
EndFunc   ;==>_Main
#EndRegion _Main()
