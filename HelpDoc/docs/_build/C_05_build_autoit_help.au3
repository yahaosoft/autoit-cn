;
; Builds AutoIt3 main help file
;

#region Includes
#include "include\CompileLib.au3"
#include "include\DocLib.au3"
#endregion Includes

#region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "autoit-docs"
Global Const $g_sProjectDir = "docs\autoit"
;Global Const $g_aBuildFiles[1] = [ "AutoIt.chm" ]
;Global Const $g_aInstallFiles[1] = [ "AutoIt.chm" ]
#endregion Global Variables

#region Main body of code
Global $g_nExitCode = _Main()
Exit $g_nExitCode
#endregion Main body of code

#region _Main()
; ===================================================================
; _Main()
;
; The main function responsible for generating the syntax files.
; Parameters:
;	None.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func _Main()
	; Create the output window and initial message.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $g_sProject & ") ====" & @CRLF)
	_OutputProgressWrite("Generating AutoIt.chm..." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Delete files in the install dir that we are about to change
	FileDelete('install\AutoIt.chm')

	; Holds the return value.
	Local $nReturn = 0

	; Create the helpfile.
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	CompileDocumentation("AutoItM.hhp")
	If @error Then
		_OutputProgressWrite("Error: Unable to compile documentation." & @CRLF)
		$nReturn = 1
	Else
		; Copy the files install
		FileChangeDir($gBuildDir)
		FileMove($g_sProjectDir & "\" & $g_sProjectLang & "\AutoIt.chm", "install\AutoItCHS.chm", 1)

		; Delete all temp files ready for source code packaging
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlogM.txt")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")

		FileDelete("install\AutoIt.chw")

		; Write closing message and wait for close (if applicable).
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	EndIf

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#endregion _Main()
