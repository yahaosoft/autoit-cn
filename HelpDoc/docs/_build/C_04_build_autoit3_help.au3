;
; Builds AutoIt3 help file
;

#region Includes
#include "include\CompileLib.au3"
#include "include\DocLib.au3"
#include "include\MiscLib.au3"
#endregion Includes

#region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "autoit3 help"
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
	_OutputProgressWrite("Generating AutoIt3.chm..." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Delete files in the install dir that we are about to change
	FileDelete('install\AutoIt3.chm')

	; Update the helpfile
	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)
	RunWait('"' & @AutoItExe & '" All_Gen_AutoIt3.au3')

	; Holds the return value.
	Local $nReturn = 0

	; Workaround for merging into one chm file. By guinness.
	Local $hBackupTOC = MergeHelpFiles('AutoIt3 TOC.hhc', 'UDFs3 TOC.hhc')
	Local $hBackupHHK = MergeHelpFiles('AutoIt3 Index.hhk', 'UDFs3 Index.hhk')

	; Create the helpfile.
	CompileDocumentation("AutoIt3.hhp")
	If @error Then
		_OutputProgressWrite("Error: Unable to compile documentation." & @CRLF)
		$nReturn = 1
	Else
		; Copy the files install
		FileChangeDir($gBuildDir)
		FileMove($g_sProjectDir & "\" & $g_sProjectLang & "\AutoIt3.chm", "install\AutoItCHS.chm", $FC_OVERWRITE) ; Move AutoIt3.chm to the install folder as AutoIt.chm.

		; Delete all temp files ready for source code packaging
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\Debug.log")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\_errorlog3.txt")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\fileList.tmp")
		FileDelete($g_sProjectDir & "\" & $g_sProjectLang & "\genindex.log")

		; Write closing message and wait for close (if applicable).
		_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	EndIf

	FileChangeDir($gBuildDir & "\" & $g_sProjectDir & "\" & $g_sProjectLang)

	; Move the backed up files back again, thus no files have to be applied to the ignore list.
	UnMergeHelpFiles($hBackupTOC)
	UnMergeHelpFiles($hBackupHHK)

	_OutputWaitClosed($nReturn)

	Return $nReturn
EndFunc   ;==>_Main
#endregion _Main()

; Merge AutoIt3 and UDFs3 related files into one.
Func MergeHelpFiles($sParent, $sChild)
	Local $sParentBackup = StringRegExpReplace($sParent, '(\.\w+)', '_Backup\1') ; Backup the file.
	If FileCopy($sParent, $sParentBackup, $FC_OVERWRITE) = 0 Then Return False

	Local $aSRE = StringRegExp(FileRead($sChild), _
			'(?s)<UL>.+</UL>', 3)
	If @error = 0 Then
		$aSRE[0] = StringReplace($aSRE[0], '\', '\\')
		Local $sAutoIt3TOC = StringRegExpReplace(FileRead($sParent), _
				'(*BSR_ANYCRLF)(</UL>\R)(?=</BODY></HTML>)', '\1' & $aSRE[0] & @CRLF)
		_StripEmptyLines($sAutoIt3TOC)
		_StripWhitespace($sAutoIt3TOC)
		If FileDelete($sParent) Then FileWrite($sParent, $sAutoIt3TOC)
		Local Const $hTimer = TimerInit()
		Do
			Sleep(20)
		Until FileExists($sParent) Or TimerDiff($hTimer) > 2000
	EndIf
	Return $sParentBackup
EndFunc   ;==>MergeHelpFiles

; Revert a backup file.
Func UnMergeHelpFiles($sParentBackup)
	Local $sParent = StringReplace($sParentBackup, '_Backup', '') ; Revert the backup the file.
	Return FileMove($sParentBackup, $sParent, $FC_OVERWRITE)
EndFunc   ;==>UnMergeHelpFiles
