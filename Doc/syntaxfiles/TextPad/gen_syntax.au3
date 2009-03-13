;==============================================================================
; Automatically generate syntax files
;==============================================================================

$funclist = "..\functions.txt"
$keywordlist = "..\keywords.txt"
$macrolist = "..\macros.txt"

$output = "autoit_v3.syn"


; Check that all the required files exist
If Not FileExists($funclist) OR Not FileExists($keywordlist) OR Not FileExists($macrolist) Then
	MsgBox(0, "Error", "Generate function and keyword lists before running.")
	Exit
EndIf

FileCopy("header.txt", $output, 1)

$houtput = FileOpen($output, 1)

; Keywords
FileWriteLine($houtput, "")
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '; 1. Keywords')
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '[Keywords 1]')
WriteSection($keywordlist)

; Macros
FileWriteLine($houtput, "")
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '; 2. Macros')
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '[Keywords 2]')
WriteSection($macrolist)

; Functions
FileWriteLine($houtput, "")
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '; 3. Functions')
FileWriteLine($houtput, '; /////////////')
FileWriteLine($houtput, '[Keywords 3]')
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