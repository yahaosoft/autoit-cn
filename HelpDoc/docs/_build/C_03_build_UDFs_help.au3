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

	; Update the helpfile
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Gen_UDFs3.au3')

	; Holds the return value.
	Local $nReturn = 0

	; Delete all temp files ready for source code packaging
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlogUDF3.txt")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")
	FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\txt2htm\txtLibFunctions\changelog.txt")

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#endregion _Main()
