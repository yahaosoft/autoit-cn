;
; Builds AutoIt3 Editor Syntax files
#Region Includes
#include "include\CompileLib.au3"
#include <FileConstants.au3>
#EndRegion Includes

#Region Global Variables
; The name of the project.
Global Const $g_sProjectLang = "english"
Global Const $g_sProject = "syntaxfiles"
Global Const $g_sProjectDir = "docs\autoit\" & $g_sProjectLang & "\txt2htm"
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
	_OutputProgressWrite("Generating syntax files." & @CRLF)

	; Set the build directory based on the rules and the INI file value.
	Local $gBuildDir = _BuildDirSet()

	; Generate macros.htm.
	FileChangeDir($gBuildDir & '\docs\autoit\english')
	_OutputBuildWrite("Creating macros.htm file" & @CRLF)
	RunWait('"' & @AutoItExe & '"' & ' Gen_Macros.au3')

	; Syntax files lists
	FileChangeDir($gBuildDir & '\docs\autoit\english\txt2htm\syntaxfiles')
	RunWait('"' & @AutoItExe & '" gen_lists.au3')

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Crimson')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit3.key", $gBuildDir & "\install\Extras\Editors\Crimson\autoit3.key", $FC_OVERWRITE + $FC_CREATEPATH)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Notepad++')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit.xml", $gBuildDir & "\install\Extras\Editors\Notepad++\autoit.xml", $FC_OVERWRITE + $FC_CREATEPATH)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\PSPad')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3') ; Includes gen_def.au3
	FileMove("AutoIt3.ini", $gBuildDir & "\install\Extras\Editors\PSPad\AutoIt3.ini", $FC_OVERWRITE + $FC_CREATEPATH)
	FileMove("AutoIt3.def", $gBuildDir & "\install\Extras\Editors\PSPad\AutoIt3.def", $FC_OVERWRITE + $FC_CREATEPATH)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Sublime Text')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("AutoIt.tmLanguage", $gBuildDir & "\install\Extras\Editors\Sublime Text\AutoIt.tmLanguage", $FC_OVERWRITE + $FC_CREATEPATH)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Textpad')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit_v3.syn", $gBuildDir & "\install\Extras\Editors\TextPad\autoit_v3.syn", $FC_OVERWRITE + $FC_CREATEPATH)

	FileChangeDir($gBuildDir & '\' & $g_sProjectDir & '\' & $g_sProject & '\Geshi')
	RunWait('"' & @AutoItExe & '" gen_syntax.au3')
	FileMove("autoit.php", $gBuildDir & "\install\Extras\Geshi\autoit.php", $FC_OVERWRITE + $FC_CREATEPATH)

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	_OutputWaitClosed()

	Return 0
EndFunc   ;==>_Main
#EndRegion _Main()
