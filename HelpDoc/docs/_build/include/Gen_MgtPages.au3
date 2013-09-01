;==============================================================================
; Generate the "xxx Management.htm" pages
; from the "xxx TOC.hhc"

; Input and output directories are read from 'txt2htm.ini'
; The directory should contain either keywords or functions; not both!
;
; 19 Jan 2009 - jpm - jpm@autoitscript.com
;
; 12 Mar 2013 - jpm - jpm@autoitscript.com
;             - Reorg to have same source for AutoItX generation
; Updated:  13 jul 2013 jos
;           - Changed the path for include to support building from DOCS directory
;==============================================================================

#include "OutputLib.au3"
#include <Array.au3>

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
Global $hOut ;handle to the output file
Global $hIn ;handle to current input file
Global $OUTPUT_DIR
Global $RefType, $RefTypeS
Global $FTOC, $FNAME, $NAME, $NestedMgt, $ahOut[4], $anPrevFuncname_0[4], $aFuncname[500], $aIncludeAU3[100][2]

If $ReGen_AutoIt Then
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
	$FTOC = ""
	$NestedMgt = 0

	$RefType = "Function"
	$RefTypeS = "Function"
	$hIn = FileOpen("AutoIt3 TOC.hhc", 0) ;input mode
	GetFirstManagement()
	genFiles()
	FileClose($hIn)
EndIf

If $ReGen_UDFs Then
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
	$FTOC = ""
	$NestedMgt = 0
	SetIncludeAU3()

	$RefType = "User Defined Function"
	$RefTypeS = "User Defined Functions"
	$hIn = FileOpen("UDFs3 TOC.hhc", 0) ;input mode
	GetFirstManagement()
	genFiles()
	FileClose($hIn)
EndIf

If $ReGen_AutoItX Then
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
	$FTOC = ""
	$NestedMgt = 0

	$RefType = "Method"
	$RefTypeS = "Methods"
	$hIn = FileOpen("AutoItX TOC.hhc", 0) ;input mode
	GetFirstManagement()
	genFiles()
	FileClose($hIn)
EndIf

Exit

Func OnQuit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func putHeader()
	put('<!DOCTYPE html>')
	put('<html>')
	put('<head>')
	put('  <title>' & $RefType & "s" & '</title>')
	put('  <meta charset="gb2312">')
	If $ReGen_AutoItX Then
		put('  <link href="..\..\css\default.css" rel="stylesheet" type="text/css">')
	Else
		put('  <link href="..\css\default.css" rel="stylesheet" type="text/css">')
	EndIf
	put('</head>')
	put('')
	put('<body>')
	put('<h1>' & $NAME & ' ' & StringLower($RefType) & 's Reference</h1>')
	If $ReGen_AutoItX Then
		put('<p>Below is a complete list of the ' & StringLower($RefType) & 's available in AutoItX.')
	Else
		put('<p>Below is a complete list of the ' & StringLower($RefType) & 's available in AutoIt.')
	EndIf
	put('Click on a ' & StringLower($RefType) & ' name for a detailed description.</p>')
	If $RefType = "User Defined Function" Then
		put('<p>When using them you need to add a <b>#include &lt;' & GetIncludeAU3($NAME) & '.au3&gt;</b>.</p>')
	Else
		If StringInStr($NAME, "GUI") = 1 Then
			put('<p>See <a href="..\guiref\GUIConstants.htm">Gui Constants include files</a> if you need to use the related controls Constants .</p>')
		EndIf
	EndIf
	put('<p>&nbsp;</p>')
	put('')
	put('<table>')
	put('<tr>')
	put('  <th style="width:25%">' & $RefType & '</th>')
	put('  <th style="width:75%">Description</th>')
	put('</tr>')
EndFunc   ;==>putHeader

Func GetIncludeAU3($sName)
	$sName = StringReplace($sName, " Reference", "")
	For $i = 1 To $aIncludeAU3[0][0]
		If $aIncludeAU3[$i][0] = $sName Then Return $aIncludeAU3[$i][1]
	Next
	Return $sName
EndFunc   ;==>GetIncludeAU3

Func SetIncludeAU3()
	Local $INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	Local $hToc = FileOpen($INPUT_DIR & "Categories.toc", 0)
	Local $sLine, $aSplit, $sPrevMgt = ""
	$aIncludeAU3[0][0] = 0

	While 1
		$sLine = FileReadLine($hToc)
		If @error Then ExitLoop
		If StringInStr($sLine, ":") = 0 Then ContinueLoop
		$aSplit = StringSplit($sLine, "|")
		If $aSplit[$aSplit[0] - 1] = $sPrevMgt Then ContinueLoop
		$sPrevMgt = $aSplit[$aSplit[0] - 1]
		$aIncludeAU3[0][0] += 1
		$aIncludeAU3[$aIncludeAU3[0][0]][0] = StringReplace(StringReplace($sPrevMgt, " Management", ""), "&", "&amp;")
		$aSplit = StringSplit($aSplit[$aSplit[0]], ":")
		$aIncludeAU3[$aIncludeAU3[0][0]][1] = $aSplit[1]
	WEnd

	FileClose($hToc)
EndFunc   ;==>SetIncludeAU3

Func PutEntry()
	Local $funcname = GetFuncName($FNAME)
	If $funcname = "" Then Return
	$aFuncname[0] += 1
	$aFuncname[$aFuncname[0]] = $FNAME
EndFunc   ;==>PutEntry

Func GetFuncDesc($NFname, $nline = 13)
	Local $funcdesc = FileReadLine($OUTPUT_DIR & $NFname, $nline)
	$funcdesc = StringRegExp($funcdesc, '<(?i)p .*?>(.*?)<(/(?i)p|br)>', 1)
	If @error Then
		If $nline = 13 Then Return GetFuncDesc($NFname, 14)
		Return "&nbsp;"
	EndIf
	Return $funcdesc[0]
EndFunc   ;==>GetFuncDesc

Func GetFuncName($NFname)
	Local $sLine = FileReadLine($OUTPUT_DIR & $NFname, 4)
	Local $funcname = StringRegExp($sLine, '<title>.*? +(.*?) *</title>', 1)
	If @error Then Return $sLine
	Return $funcname[0]
EndFunc   ;==>GetFuncName

Func GetFileName()
	Local $line
	$FNAME = ""
	While 1
		$line = FileReadLine($hIn)
		If @error Then Return SetError(@error, 0, 0) ; invalid TOC.hhc
		If StringInStr($line, '<param name=') Then
			; a StringRegExpReplace would be better ...
			If StringInStr($line, '"Local"') Then
				$FNAME = StringReplace($line, '<param name="Local" value="' & $OUTPUT_DIR, '', 1)
				$FNAME = StringReplace($FNAME, '">', '', 1)
				$FNAME = StringStripWS($FNAME, 3)
			Else
				$NAME = StringReplace($line, '<param name="Name" value="', '', 1)
				$NAME = StringReplace($NAME, '">', '', 1)
				$NAME = StringReplace($NAME, ' Management', '', 1)
				$NAME = StringStripWS($NAME, 3)
			EndIf

		Else
			; skip until end  object
			If StringInStr($line, '</OBJECT>') Then Return 1
			If StringInStr($line, '</UL>') Then
				$FNAME = "</UL>"
				Return 1
			EndIf
		EndIf
	WEnd
EndFunc   ;==>GetFileName

Func GetFirstManagement()
	Local $line

	; position on the top level as "Function Reference" or "User Defined Functions" or "Methods Reference"
	While 1
		$line = FileReadLine($hIn)
		If @error Then Return SetError(@error, 0, 0) ; invalid TOC.hhc
		If StringInStr($line, '<param name="Name" value="' & $RefTypeS & " Reference") Then ExitLoop
		If StringInStr($line, '<param name="Name" value="' & $RefTypeS & "参考") Then ExitLoop
	WEnd

	While @error = 0 And StringInStr($FNAME, " Management") = 0 And StringInStr($FNAME, "管理") = 0 
		GetFileName()
	WEnd

	If @error Then Return SetError(@error, 0, 0)
	$FTOC = $FNAME
	Return 1
EndFunc   ;==>GetFirstManagement

Func GetNextManagement()
	If $ReGen_UDFs Then
		While @error = 0 And StringInStr($FNAME, " Management") = 0 And StringInStr($FNAME, "管理") = 0 
			GetFileName()
		WEnd

		If @error Then Return SetError(@error, 0, 0)
		$FTOC = $FNAME
		Return 1
	EndIf

	If StringInStr($FNAME, " Management") = 0 Then GetFileName()
	If StringInStr($FNAME, "管理") = 0 Then GetFileName()
	$FTOC = $FNAME
	Return StringInStr($FNAME, " Management") Or StringInStr($NAME, " Reference") Or StringInStr($FNAME, "管理") Or StringInStr($NAME, "参考")
EndFunc   ;==>GetNextManagement

Func GetNextEntry()
	GetFileName()

	If (StringInStr($FNAME, " Management") Or StringInStr($FNAME, "管理")) And Not $ReGen_UDFs Then
		; ignore previous entry as it is a sublevel has been defined
		$FTOC = $FNAME
		genFiles()
	EndIf

	If StringInStr($FNAME, "</UL>") Then
		Return 0
	EndIf

	Return 1
EndFunc   ;==>GetNextEntry

Func genFiles()
	Do
		$hOut = FileOpen($OUTPUT_DIR & StringReplace($FTOC, "&amp;", "&"), 2)
		$NestedMgt += 1
		$ahOut[$NestedMgt] = $hOut
		$anPrevFuncname_0[$NestedMgt] = $aFuncname[0] + 1
		putHeader()
		While GetNextEntry()
			PutEntry()
		WEnd

		_ArraySort($aFuncname, 0, $anPrevFuncname_0[$NestedMgt], $aFuncname[0])
		Local $prevFuncname = "", $funcname
		For $i = $anPrevFuncname_0[$NestedMgt] To $aFuncname[0]
			$FNAME = $aFuncname[$i]
			; write CatEntries
			$funcname = GetFuncName($FNAME)
			If $prevFuncname <> $funcname Then ; avoid identical entries
				$prevFuncname = $funcname
				put('<tr>')
				put('<td><a href="' & $FNAME & '">' & $funcname & '</a></td>')
				put('<td>' & GetFuncDesc($FNAME) & '</td>')
				put('</tr>')
			EndIf
		Next

		put('</table>')
		put('')
		put('</body>')
		FileClose($hOut)
		$aFuncname[0] = $anPrevFuncname_0[$NestedMgt] - 1
		$NestedMgt -= 1
		$hOut = $ahOut[$NestedMgt]
	Until GetNextManagement() = 0

	Return
EndFunc   ;==>genFiles

;------------------------------------------------------------------------------
; Write a new line to the output file
;------------------------------------------------------------------------------
Func put($lineToWrite)
	FileWriteLine($hOut, $lineToWrite)
EndFunc   ;==>put
