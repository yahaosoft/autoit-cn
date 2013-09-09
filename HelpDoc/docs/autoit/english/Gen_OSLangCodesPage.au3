; ==============================================================================
; Generate the "OSLangCodes.htm" pages
; from the "OSLang.csv"

; Output directories are read from 'txt2htm.ini'
;
; the @OSLang.htm in Keywords dir is use to append the example
;
; 15 Nov 2012 - jpm - jpm@autoitscript.com
; ==============================================================================

#include "..\..\_build\include\OutputLib.au3"
#include <Array.au3>
#include <Constants.au3>

Opt("TrayIconDebug", 1)

OnAutoItExitRegister("OnQuit") ;### Debug Console
_OutputWindowCreate() ;### Debug Console

FileChangeDir(@ScriptDir)

Global $APPENDIX_OUT_DIR = IniRead("txt2htm.ini", "Output", "Appendix", "ERR")

If $APPENDIX_OUT_DIR = "ERR" Then
	MsgBox($MB_SYSTEMMODAL, "Error", "Could not read txt2htm.ini")
	Exit
EndIf

Global $hOut = FileOpen($APPENDIX_OUT_DIR & "OSLangCodes.htm", 2) ;handle to the output file
_OutputProgressWrite("OSLangCodes.htm Creation...") ;### Debug Console

Local $sLangListFile = "OSLangCodes.csv"
Local $hList = FileOpen($sLangListFile)

Global $giLocale, $giLanguage, $giCountry, $gsLanguage

Local $asCol = StringSplit(FileReadLine($hList), ";")
Global $gsMSDNpage = $asCol[1]
Global $gsMSDNhyperlink = $asCol[2]

Local $sLine = FileReadLine($hList)
While StringLeft($sLine, 1) = ";"
	$sLine = FileReadLine($hList)
WEnd

GetHeader($sLine)

Global $gaLocale[500][3], $giNbLocale = 0, $giPrevLocale = 0
While 1
	$sLine = FileReadLine($hList)
	If @error = -1 Then ExitLoop
	GetLocale($sLine)
WEnd

; add missing Chinese entries
$gaLocale[$giNbLocale][0] = "0x0404"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
$giNbLocale += 1
$gaLocale[$giNbLocale][0] = "0x0804"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
$giNbLocale += 1

; add missing Scottish Gaelic entry
$gaLocale[$giNbLocale][0] = "0x0491"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf

; add missing Bangla Banglesh entry
$gaLocale[$giNbLocale][0] = "0x0845"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf

; add missing Tamazight Morocco entry
$gaLocale[$giNbLocale][0] = "0x105F"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf

; add missing Splitting of Serbia and Montenegro entries
$gaLocale[$giNbLocale][0] = "0x241A"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf
$gaLocale[$giNbLocale][0] = "0x281A"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf
$gaLocale[$giNbLocale][0] = "0x2C1A"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf
$gaLocale[$giNbLocale][0] = "0x301A"
$gaLocale[$giNbLocale][1] = GetLocaleName($gaLocale[$giNbLocale][0])
If Not @error Then
	$gaLocale[$giNbLocale][2] = GetLocaleInfo($gaLocale[$giNbLocale][0])
	$giNbLocale += 1
EndIf

ReDim $gaLocale[$giNbLocale][3]
_ArraySort($gaLocale)

WriteHtm()

FileClose($hList)

_OutputProgressWrite("Finished." & @CRLF) ;### Debug Console

Exit

Func OnQuit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func WriteHtm()
	putHeader()

	; put entries
	For $i = 0 To $giNbLocale - 1
		If $gaLocale[$i][0] = 0x0409 Then
			put('    <tr class="yellowbold">')
		Else
			put('    <tr>')
		EndIf
		put('      <td>' & StringTrimLeft($gaLocale[$i][0], 2) & '</td>')
		put('      <td>' & Int($gaLocale[$i][0]) & '</td>')
		put('      <td>' & $gaLocale[$i][1] & '</td>')
		put('      <td>' & $gaLocale[$i][2] & '</td>')
	Next

	putFooter()
EndFunc   ;==>WriteHtm

Func putHeader()
	put('<!DOCTYPE html>')
	put('<html>')
	put('<head>')
	put('  <title>OS Language Values-Codes</title>')
	put('  <meta charset="ISO-8859-1">')
	put('  <link href="..\css\default.css" rel="stylesheet" type="text/css">')
	put('</head>')
	put('')
	put('<body>')
	put('<h1>@KBLayout, @MUILang, @OSLang values/codes</h1>')
	put('  <p>Possible return values (strings) of <a href="../macros/SystemInfo.htm#@KBLayout">@KBLayout</a>, <a href="../macros/SystemInfo.htm#@MUILang">@MUILang</a>, <a href="../macros/SystemInfo.htm#@OSLang">@OSLang</a><br>')
	put('  <br>')
	put('  List was generated from <a href="' & $gsMSDNhyperlink & ' " class="ext">"' & $gsMSDNpage & '"</a> in MSDN.<br>')
	put('  <br')
	put('  <strong>Note:</strong> Codes that contain letters could possible have the letters in uppercase.<br>')
	put('  <br></p>')
	put(' <table>')
	put('   <tr>')
	put('      <th style="width:5%">Hex</th>')
	put('      <th style="width:5%">Dec</th>')
	put('      <th style="width:10%">Country code</th>')
	put('      <th>Meaning</th>')
	put('    </tr>')
EndFunc   ;==>putHeader

Func putFooter()
	put('  </table>')
	put('')
	Local $KEYWORDS_OUT_DIR = IniRead("txt2htm.ini", "Output", "keywords", "ERR")
	Local $hIn = FileOpen($KEYWORDS_OUT_DIR & "@OSLang.htm")
	Local $sLine
	Do
		$sLine = FileReadLine($hIn)
	Until StringInStr($sLine, "Example</h2>")

	Do
		put($sLine)
		$sLine = FileReadLine($hIn)
	Until @error
EndFunc   ;==>putFooter

Func GetHeader($sLine)
	Local $asCol = StringSplit($sLine, ";")

	For $i = 1 To $asCol[0]
		If $asCol[$i] = "Locale identifier" Then
			$giLocale = $i
		ElseIf $asCol[$i] = "Primary language" Then
			$giLanguage = $i
		ElseIf $asCol[$i] = "Sublanguage" Then
			$giCountry = $i
		EndIf
	Next

	Return
EndFunc   ;==>GetHeader

Func GetLocale($sLine)
	$sLine = StringReplace($sLine, '; see note', '! see note')
	$sLine = StringReplace($sLine, '"', '')

	Local $asCell = StringSplit($sLine, ";")

	$gaLocale[$giNbLocale][0] = StringReplace($asCell[$giLocale], "0c", "0C")
	If $asCell[$giLanguage] <> "" Then
		$gsLanguage = StringRegExpReplace($asCell[$giLanguage], ' \(([^\)]*?)\)', '')
		If StringInStr($gsLanguage, "!") Then
			$gsLanguage = StringSplit($gsLanguage, "!")
			$gsLanguage = $gsLanguage[1]
		EndIf
	EndIf

	$gaLocale[$giNbLocale][1] = GetLocaleName($asCell[$giLocale])
	If $gaLocale[$giNbLocale][1] <> "" And $gaLocale[$giNbLocale][0] <> $giPrevLocale Then
		$giPrevLocale = $gaLocale[$giNbLocale][0]

		Local $sCountry = StringRegExpReplace($asCell[$giCountry], ' \(([^\)]*?)\)', '')
		Local $sSubLanguage = ""
		If StringInStr($sCountry, "!") Then
			$sCountry = StringSplit($sCountry, "!")
			$sCountry = $sCountry[1]
		EndIf
		If StringInStr($sCountry, ",") Then
			$sCountry = StringSplit($sCountry, ",")
			$sCountry[2] = StringStripWS($sCountry[2], 3)
			If $sCountry[2] = "Norway" Or $sCountry[2] = "Finland" Or $sCountry[2] = "Sweden" Then
				$sCountry[0] = $sCountry[2]
				$sCountry[2] = $sCountry[1]
				$sCountry[1] = $sCountry[0]
			ElseIf $sCountry[2] = "Canadian Syllabics" Then
				$sCountry[2] = "Canadian_Syllabics"
			ElseIf $sCountry[0] = 3 Then
				$sCountry[2] = StringStripWS($sCountry[3], 3)
			EndIf
			If StringInStr($sCountry[2], " ") Or $sCountry[2] = "PRC" Or $sCountry[2] = "FYROM" Then $sCountry[2] = ""
			If $sCountry[2] <> "" Then $sSubLanguage = " (" & $sCountry[2] & ")"
			$sCountry = $sCountry[1]
		EndIf
		If $sCountry = "PRC" Then $sCountry = "China"
		$gaLocale[$giNbLocale][2] = $gsLanguage & $sSubLanguage & ' - ' & $sCountry

		$giNbLocale += 1
	EndIf
	Return
EndFunc   ;==>GetLocale

Func GetLocaleName($iLCID)
	Local $sLocalName = LCIDToLocaleName($iLCID)
	Local $iReverseLCID = LocaleNameToLCID($sLocalName)
	If $iLCID = $iReverseLCID Then Return $sLocalName

	; special case for Chinese not supported by LCIDToLocaleName
	If $iLCID = 0x0004 Then Return "zh-CHS"
	If $iLCID = 0x7C04 Then Return "zh-CHT"

	Return SetError(1, 0, "")
EndFunc   ;==>GetLocaleName

Func LCIDToLocaleName($iLCID)
	Local $aRet = DllCall("Kernel32.dll", "int", "LCIDToLocaleName", "int", $iLCID, "wstr", "", "int", 85, "dword", 0)
	Return $aRet[2]
EndFunc   ;==>LCIDToLocaleName

Func LocaleNameToLCID($sStr)
	Local $aRet = DllCall("Kernel32.dll", "int", "LocaleNameToLCID", "wstr", $sStr, "dword", 0)
	Return $aRet[0]
EndFunc   ;==>LocaleNameToLCID

Func GetLocaleInfo($iLCID)
	Local $iLanguageIndex = 114
	If StringInStr("WIN_2008R2 WIN_2008 WIN_VISTA WIN_2003 WIN_XP WIN_XPe", @OSVersion) Then $iLanguageIndex = 2

	Local $aTemp = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'ulong', $iLCID, 'dword', $iLanguageIndex, 'wstr', '', 'int', 2048)
	$aTemp[3] = StringReplace($aTemp[3], ")", "")
	If StringInStr($aTemp[3], ",") Then
		$aTemp[3] = StringReplace($aTemp[3], ",", ") -")
	Else
		$aTemp[3] = StringReplace($aTemp[3], "(", "- ")
	EndIf

	Return $aTemp[3]
EndFunc   ;==>GetLocaleInfo
; ------------------------------------------------------------------------------
; Write a new line to the output file
; ------------------------------------------------------------------------------
Func put($lineToWrite)
	FileWriteLine($hOut, $lineToWrite)
EndFunc   ;==>put
