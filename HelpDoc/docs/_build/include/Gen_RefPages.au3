;==============================================================================
; Generate the keywords.htm or functions.htm reference page from
; the specially formatted TXT files
;
; Input and output directories are read from 'txt2htm.ini'
; The directory should contain either keywords or functions; not both!
;
; 30 Jan 2004 - CyberSlug - philipgump@hotmail.com
; 18 may 2004 - JdeB - jdeb@autoitscript.com
;             - Added support for UDF files.
;             - Changed the way the link to the html file is made
; 18 Sep 2005 - jpm - jpm@autoitscript.com
;             - Added /AutoIt /UDFs command parameters
; 09 Oct 2007 - jpm - jpm@autoitscript.com
;             - Ignored $Tag... files
; 12 Mar 2013 - jpm - jpm@autoitscript.com
;             - Reorg to have same source for AutoItX generation
; Updated:  13 jul 2013 jos
;           - Changed the path for include to support building from DOCS directory
;==============================================================================

#include "OutputLib.au3"
#include <Constants.au3>

Opt("TrayIconDebug", 1)

OnAutoItExitRegister("OnQuit") ;### Debug Console
_OutputWindowCreate() ;### Debug Console

Global $ReGen_AutoIt, $ReGen_UDFs, $ReGen_AutoItX = 0
$ReGen_AutoIt = StringInStr($CmdLineRaw, "/AutoIt")
$ReGen_UDFs = StringInStr($CmdLineRaw, "/UDFs")

If FileExists(@WorkingDir & "\AutoItX.hhp") Then
	$ReGen_AutoItX = 1
Else
	If $ReGen_AutoIt = 0 And $ReGen_UDFs = 0 Then
		; reGenerate AutoIt and UDFs
		$ReGen_AutoIt = 1
		$ReGen_UDFs = 1
	EndIf
EndIf

Global Const $TXT2HTM_INI = @WorkingDir & "\txt2htm.ini"
Global $RefType ;is either "Function" or "Keyword"
Global $hOut ;handle to the output file
Global $hIn ;handle to current input file
Global $INPUT_DIR, $htmlDir
Global $OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "mainHtml", "ERR")

If $ReGen_AutoIt Then
	$RefType = "Function"
	$hOut = FileOpen($OUTPUT_DIR & "functions.htm", 2) ;overwrite mode
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
	; ### Added this to determine the link to the htm file
	$htmlDir = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
	genFile()
	;
	$RefType = "Keyword"
	$hOut = FileOpen($OUTPUT_DIR & "keywords.htm", 2) ;overwrite mode
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "keywords", "ERR")
	; ### Added this to determine the link to the htm file
	$htmlDir = IniRead($TXT2HTM_INI, "Output", "keywords", "ERR")
	genFile()
EndIf

If $ReGen_UDFs Then
	; ### Added this section for UDFS
	;
	$RefType = "User Defined Function"
	$hOut = FileOpen($OUTPUT_DIR & "libfunctions.htm", 2) ;overwrite mode
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	; ### Added this to determine the link to the htm file
	$htmlDir = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
	genFile()

	GenSubRefs()

EndIf

If $ReGen_AutoItX Then
	$RefType = "Method"
	$hOut = FileOpen($OUTPUT_DIR & "methods.htm", 2) ;overwrite mode
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "methods", "ERR")
	; ### Added this to determine the link to the htm file
	$htmlDir = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
	genFile()
EndIf

Exit

Func OnQuit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func genFile()
	put('<!DOCTYPE html>')
	put('<html>')
	put('<head>')
	put('  <title>' & $RefType & "s" & '</title>')
	put('  <meta charset="gb2312">')
	If $ReGen_AutoItX Then
		put('  <link href="../css/default.css" rel="stylesheet" type="text/css">')
	Else
		put('  <link href="css/default.css" rel="stylesheet" type="text/css">')
	EndIf
	put('</head>')
	put('<body>')
	put('<h1>' & $RefType & ' Reference</h1>')
	If $ReGen_AutoItX Then
		put('<p>Below is a complete list of the ' & StringLower($RefType) & 's available in AutoItX.')
	Else
		put('<p>Below is a complete list of the ' & StringLower($RefType) & 's available in AutoIt.')
	EndIf
	put('Click on a ' & StringLower($RefType) & ' name for a detailed description.</p>')
	put('<p>&nbsp;</p>')
	put('')
	put('<table>')
	put('<tr>')
	put('  <th style="width:25%">' & $RefType & '</th>')
	put('  <th style="width:75%">Description</th>')
	put('</tr>')

	Local $TEMP_LIST = @WorkingDir & "\fileList.tmp"

	;pipe the list of sorted file names to fileList.tmp:
	_RunCmd('dir ' & $INPUT_DIR & '*.txt /b | SORT > "' & $TEMP_LIST & '"')

	Local $hList = FileOpen($TEMP_LIST, 0) ;readmode
	If $hList = -1 Then
		MsgBox($MB_SYSTEMMODAL, "Error", $TEMP_LIST & " cannot be read")
		Exit
	EndIf

	Local $filename, $path, $line
	;Loop thru each line of fileList.tmp to get the next file
	;### Added this to determine the link to the htm file
	$htmlDir = StringReplace($htmlDir, '\', '/')

	While $hIn <> -1
		$filename = FileReadLine($hList)
		If @error Then ExitLoop
		If $filename = "CVS" Then ContinueLoop
		If StringInStr($filename, "$Tag") Then ContinueLoop
		$path = $INPUT_DIR & $filename
		$hIn = FileOpen($path, 0) ;read mode

		; Loop thru each line in the current input file
		$line = FileReadLine($hIn)
		While Not @error
			If StringInStr($line, "###" & $RefType & "###") Then
				put('<tr>')
				$line = StringStripWS(FileReadLine($hIn), 3)
				;Get 1st non-blank line; (assume it's the keyword/function name)
				While $line = ""
					$line = StringStripWS(FileReadLine($hIn), 3)
				WEnd
				$filename = StringReplace($filename, ".txt", ".htm")
				; ### Change 2 line to determine the link to the htm file
				;$filename = StringLower($RefType) & 's\' & $filename
				;$filename = @@WorkingDir & '\' & $htmlDir & $filename
				$filename = StringTrimLeft($htmlDir, StringLen($OUTPUT_DIR)) & $filename
				put('  <td><a href="' & $filename & '">' & $line & '</a></td>')

				$line = FileReadLine($hIn)
				While Not @error
					If StringInStr($line, "###Description###") Then
						$line = StringStripWS(FileReadLine($hIn), 3)
						;Get 1st non-blank line; (assume it's the description)
						While $line = ""
							$line = StringStripWS(FileReadLine($hIn), 3)
						WEnd
						put('  <td>' & $line & '</td>')
					EndIf
					$line = FileReadLine($hIn)
				WEnd
				put('</tr>')

				ExitLoop
			EndIf
			$line = FileReadLine($hIn)
		WEnd

		FileClose($hIn)
	WEnd

	put('</table>')
	put('')
	put('</body>')
	put('</html>')

	FileClose($hList)
	FileClose($hOut)
	Return
EndFunc   ;==>genFile

Func GenSubRefs()
	Local $CATALOG_TOC = $INPUT_DIR & "Categories.toc"

	Local $hList = FileOpen($CATALOG_TOC, 0) ;readmode
	If $hList = -1 Then
		MsgBox($MB_SYSTEMMODAL, "Error", $CATALOG_TOC & " cannot be read")
		Exit
	EndIf

	Local $sLine = "", $aField, $RefType = "", $sSubMgt = ""
	$hOut = -1
	While 1
		If $sLine = "" Then $sLine = FileReadLine($hList)
		If @error Then ExitLoop

		$aField = StringSplit($sLine, '|')
		$sLine = ""
		If $aField[0] >= 3 Then
			If $RefType <> $aField[1] Then
				PutFooter()
				$RefType = $aField[1]
				If StringInStr($RefType, "WinAPIEx") Then
					$hOut = FileOpen($OUTPUT_DIR & "libfunctions\WinAPIEx Reference.htm", 2) ;overwrite mode
				Else
					$hOut = FileOpen($OUTPUT_DIR & "libfunctions\GUI Reference.htm", 2) ;overwrite mode
				EndIf
				PutHeader($RefType)
			EndIf

			If $hOut <> -1 Then
				If $aField[2] <> $sSubMgt Then
					$sSubMgt = $aField[2]
					put('      <li><a href="' & $sSubMgt & '.htm">' & $sSubMgt & '</a></li>')
				EndIf

				If $aField[0] >= 4 Then
					Local $hSav = $hOut
					$hOut = FileOpen($htmlDir & $aField[2] & ".htm", 2) ;overwrite mode
					$sLine = GenSubSubRef($hList, $aField[2], $aField[3])
					FileClose($hOut)
					$hOut = $hSav
				EndIf
			EndIf
		EndIf
	WEnd
	PutFooter()

	FileClose($hList)
	Return
EndFunc   ;==>GenSubRefs

Func PutHeader($sRefType)
	put('<!DOCTYPE html>')
	put('<html>')
	put('<head>')
	put('  <title>' & $sRefType & '</title>')
	put('  <meta charset="ISO-8859-1">')
	put('  <link href="../css/default.css" rel="stylesheet" type="text/css">')
	put('</head>')
	put('')
	put('<body>')
	put('<h1>' & $sRefType & '</h1>')
	put('<ul>')
EndFunc   ;==>PutHeader

Func PutFooter()
	If $hOut = -1 Then Return
	put('</ul>')
	put('')
	put('</body>')
	put('</html>')
	FileClose($hOut)
	$hOut = -1
EndFunc   ;==>PutFooter

Func GenSubSubRef($hList, $sRefType, $sSubMgt)
	PutHeader($sRefType)
	put('      <li><a href="' & $sSubMgt & '.htm">' & $sSubMgt & '</a></li>')

	Local $sLine, $aField
	While 1
		$sLine = FileReadLine($hList)
		If @error Then ExitLoop
		If StringInStr($sLine, $sRefType) Then
			$aField = StringSplit($sLine, '|')
			If $aField[3] <> $sSubMgt Then
				$sSubMgt = $aField[3]
				put('      <li><a href="' & $sSubMgt & '.htm">' & $sSubMgt & '</a></li>')
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd

	PutFooter()

	Return $sLine
EndFunc   ;==>GenSubSubRef

;------------------------------------------------------------------------------
; Write a new line to the output file
;------------------------------------------------------------------------------
Func put($lineToWrite)
	FileWriteLine($hOut, $lineToWrite)
EndFunc   ;==>put

;------------------------------------------------------------------------------
; Run DOS/console commands ... works also in win9x
;------------------------------------------------------------------------------
Func _RunCmd($command)
	FileWriteLine("brun.bat", $command)
	RunWait(@ComSpec & " /c brun.bat", "", @SW_HIDE)
	FileDelete("brun.bat")
	Return
EndFunc   ;==>_RunCmd
