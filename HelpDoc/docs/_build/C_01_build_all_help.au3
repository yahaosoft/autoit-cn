;
; Runs all the B_ scripts to compile all AutoIt related exes

#Region Includes
#include "include\CompileLib.au3"
#EndRegion Includes

#Region Global Variables
; The project name to display in build progress output.
Global $g_sProject = "Build All Help files"

; This array contains a list of all build script names.
Global $g_aScripts[5] = [ _
		"C_02_build_syntax_files.au3", _
		"C_03_build_UDFs_help.au3", _
		"C_04_build_autoit3_help.au3", _
		"C_06_build_autoitx_help.au3", _
		"C_07_build_examples_help.au3" _
		]
#EndRegion Global Variables

#Region Main body of code
Global $g_nExitCode = Batch_Main($g_sProject, $g_aScripts)
Exit $g_nExitCode
#EndRegion Main body of code
