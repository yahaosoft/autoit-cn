;==============================================================================
; Automatically generate syntax files
;==============================================================================

$funclist = "..\functions.txt"
$keywordlist = "..\keywords.txt"
$macrolist = "..\macros.txt"

$output = "AutoIt3.ini"

; Check that all the required files exist
If Not FileExists($funclist) OR Not FileExists($keywordlist) OR Not FileExists($macrolist) Then
	MsgBox(0, "Error", "Generate function and keyword lists before running.")
	Exit
EndIf

FileCopy("header.txt", $output, 1)

$houtput = FileOpen($output, 1)

; Keywords
FileWriteLine($houtput, "[KeyWords]")
WriteSection($keywordlist)

; Functions
WriteSection($funclist)

; Macros
FileWriteLine($houtput, "[ReservedWords]")
WriteSection($macrolist)


FileClose($houtput)
Exit


Func WriteSection($filename)

Local $line, $hfile

	$hfile = FileOpen($filename, 0)

	$line = FileReadLine($hfile)
	While Not @error
		FileWriteLine($houtput, $line & "=")
		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

EndFunc
