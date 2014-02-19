;
; Builds AutoItX Help file and copies example scripts to installer
;

#Region Includes
#include "include\CompileLib.au3"
#include "include\DocLib.au3"
#EndRegion Includes

#Region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "autoitx-docs"
Global Const $g_sProjectDir = "docs\autoitx"
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
;	None.
; Returns:
;	0 on success, non-zero on failure.
; ===================================================================
Func _Main()
	; Create the output window and initial message.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (" & $g_sProject & ") ====" & @CRLF)
	_OutputProgressWrite("Generating AutoItX.chm..." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Delete files in the install dir that we are about to change
	FileDelete('install\AutoItX\AutoItX.chm')

	; Get Setting to check if Rebuild all help files is required
	Local $sRegenAll = ""
	If _SettingGet($SETTING_REBUILDHELPFILES, False, True, Default, True) Then $sRegenAll = "/RegenAll"

	; Update the helpfile
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Generate_Helpfile.au3 ' & $sRegenAll)

	Local $nReturn = 0
	; Create the helpfile.
	CompileDocumentation("AutoItX.hhp")
	If @error Then
		_OutputProgressWrite("Error: Unable to compile documentation." & @CRLF)
		$nReturn = 1
	Else
		; Move the files install
		FileChangeDir($gBuildDir)
		FileMove($g_sProjectDir & "\" & $g_sProjectLang & "\AutoItX.chm", "install\AutoItX\AutoItX.chm", $FC_OVERWRITE)

		; Delete all temp files ready for source code packaging
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlog.txt")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")

		; Write closing message and wait for close (if applicable).
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	EndIf

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#EndRegion _Main()
