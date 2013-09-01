;
; Builds UDFs3 help file
;

#region Includes
#include "include\CompileLib.au3"
#endregion Includes

#region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "UDFs3 help"
Global Const $g_sProjectDir = "docs\autoit"
;Global Const $g_aBuildFiles[1] = [ "UDFs3.chm" ]
;Global Const $g_aInstallFiles[1] = [ "UDFs3.chm" ]
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
	_OutputProgressWrite("Generating UDFs .htm..." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Delete files in the install dir that we are about to change
	; FileDelete('install\UDFs3.chm')

	; Update the helpfile
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Gen_UDFs3.au3')

	; Holds the return value.
	Local $nReturn = 0

	; Copy the files install
	; FileChangeDir($gBuildDir)
	; FileCopy($g_sProjectDir & "\" & $g_sProjectLang & "\UDFs3.chm", "install\UDFs3.chm", 1)

	; Delete all temp files ready for source code packaging
	; FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\UDFs3.chm")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlogUDF3.txt")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\txt2htm\txtLibFunctions\changelog.txt")

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.

	#cs
		; Create the helpfile.
		CompileDocumentation("UDFs3.hhp")
		If @error Then
		_OutputProgressWrite("Error: Unable to compile documentation." & @CRLF)
		$nReturn = 1
		Else
		; Copy the files install
		FileChangeDir($gBuildDir)
		FileCopy($g_sProjectDir & "\" & $g_sProjectLang & "\UDFs3.chm", "install\UDFs3.chm", 1)

		; Delete all temp files ready for source code packaging
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\UDFs3.chm")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlogUDF3.txt")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\txt2htm\txtLibFunctions\changelog.txt")

		; Write closing message and wait for close (if applicable).
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
		EndIf
	#ce

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#endregion _Main()
