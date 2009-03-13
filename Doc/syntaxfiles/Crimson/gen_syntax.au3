;==============================================================================
; Automatically generate syntax files
;==============================================================================

$funclist = "..\functions.txt"
$keywordlist = "..\keywords.txt"
$macrolist = "..\macros.txt"

$output = "autoit3.key"


; Check that all the required files exist
If Not FileExists($funclist) OR Not FileExists($keywordlist) OR Not FileExists($macrolist) Then
	MsgBox(0, "Error", "Generate function and keyword lists before running.")
	Exit
EndIf

FileCopy("header.txt", $output, 1)

$houtput = FileOpen($output, 1)

; Keywords
FileWriteLine($houtput, "")
FileWriteLine($houtput, '[KEYWORDS0:GLOBAL]')
FileWriteLine($houtput, '# Autoit Keyword/Statement Reference')
WriteSection($keywordlist)

; Macros
FileWriteLine($houtput, "")
FileWriteLine($houtput, '[KEYWORDS3:GLOBAL]')
FileWriteLine($houtput, '# Autoit Macro Variables')
WriteSection($macrolist)

; Functions
FileWriteLine($houtput, "")
FileWriteLine($houtput, '[KEYWORDS6:GLOBAL]')
FileWriteLine($houtput, '# Autoit "Function Reference"')
WriteSection($funclist)

FileClose($houtput)
Exit


Func WriteSection($filename)

Local $line, $hfile

	$hfile = FileOpen($filename, 0)

	$line = FileReadLine($hfile)
	While Not @error
		FileWriteLine($houtput, $line)
		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

EndFunc
