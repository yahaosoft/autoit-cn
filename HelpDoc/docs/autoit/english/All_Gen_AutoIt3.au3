; JPM;#RequireAdmin
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author: Jos van der Zande
; Email : jdeb@autoitscript.com
;
; Script Function:
; Store this script in the Helpfile directory where the project file is stored.
; It assumes that the Include directory is a subdir of directory defined in the registry key: "HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt","Installdir"
; It will read all *.au3 files in this include directory and create the \html\libfunctions.htm.
; It wil also create one description file per ???.au3 it finds. this will be stored in \html\libfunctions\????.htm.
; All descriptions which are specified in the ???.AU3 are copied into this description htm file and
; references are created to these in the \html\libfunctions.htm.
; ******************************************************
; Read all Include functions and generate helpfile
; ******************************************************
; remove old file that contains a list of userfunctions
; Generate the index File

#include "..\..\_build\include\OutputLib.au3"
#include <Constants.au3>

Opt("TrayIconDebug", 1)

OnAutoItExitRegister("OnQuit") ;### Debug Console
_OutputWindowCreate() ;### Debug Console

Global $L_MSG = ""

FileChangeDir(@ScriptDir)

_OutputBuildWrite("Generate HTM files for all changed Functions/Keywords" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_txt2Htm.au3 /AutoIt')

_OutputBuildWrite("Generate Reference HTM files for Functions/Keywords" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_RefPages.au3 /AutoIt')

_OutputBuildWrite("Creating the index entries for all builtin functions/keywords" & @CRLF)
Main()

_OutputBuildWrite("Generate Management HTM files for Functions" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_MgtPages.au3 /AutoIt')

_OutputBuildWrite("Generate OSLangCodes HTM file" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' Gen_OSLangCodesPage.au3')

_OutputBuildWrite("Converting autoit_changelog.txt to history.htm file" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' Gen_ChangeLog.au3')

Func OnQuit()
	; _OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func Main()
	Local $FI_TOC_HND = FileOpen("AutoIt3 TOC.hhc", 0)
	Local $FO_INDEX_HND = FileOpen("AutoIt3 Index.hhk", 2)
	; Check if file opened for reading OK
	If $FI_TOC_HND = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	; start
	FileWriteLine($FO_INDEX_HND, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">')
	FileWriteLine($FO_INDEX_HND, '<HTML>')
	FileWriteLine($FO_INDEX_HND, '<HEAD>')
	FileWriteLine($FO_INDEX_HND, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">')
	FileWriteLine($FO_INDEX_HND, '<!-- Sitemap 1.0 -->')
	FileWriteLine($FO_INDEX_HND, '</HEAD><BODY>')
	FileWriteLine($FO_INDEX_HND, '<UL>')
	; jump to last record processed
	Local $LINE, $MACROSECTION, $TNAME, $FN, $FI_TOC_HNDI, $LINEI
	Local $NAME = ""
	While 1
		$LINE = FileReadLine($FI_TOC_HND)
		If @error = -1 Then
			ExitLoop
		EndIf
		Select
			Case StringInStr(StringLower($LINE), '<li>') > 0
				$NAME = ""
			Case StringInStr(StringLower($LINE), '<param name="name"') > 0
				$NAME = StringReplace($LINE, Chr(09), "")
				If StringInStr($LINE, ' Macros"') > 0 Then
					$MACROSECTION = 1
				Else
					$MACROSECTION = 0
				EndIf
			Case StringInStr(StringLower($LINE), '<param name="local"') > 0
				FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
				FileWriteLine($FO_INDEX_HND, '   ' & $NAME)
				FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
				FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
				; create entries in index for #include as include
				If StringInStr($NAME, 'value="#') > 0 And StringInStr($NAME, '...') = 0 Then
					FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
					FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($NAME, "#", ""))
					FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
					FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
				EndIf
				; gen entry in index for each FuncName on a line like Func XXX()
				If StringInStr($NAME, "()") > 0 Then
					$TNAME = StringStripWS(StringReplace(StringLeft($NAME, StringInStr($NAME, "()") - 1), "Func ", ""), 2) & '">'
					FileWriteLine($FO_INDEX_HND, '	<LI> <OBJECT type="text/sitemap">')
					FileWriteLine($FO_INDEX_HND, '   ' & $TNAME)
					FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
					FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
				EndIf
				; gen entry in index for each keyword on a line like If...Else...EndIf
				If StringInStr($NAME, "...") > 0 Then
					While StringInStr($NAME, "...") > 0
						$TNAME = StringLeft($NAME, StringInStr($NAME, "...") - 1) & '">'
						$NAME = StringLeft($NAME, StringInStr($NAME, 'value="') + 6) & StringTrimLeft($NAME, StringInStr($NAME, "...") + 2)
						FileWriteLine($FO_INDEX_HND, '	<LI> <OBJECT type="text/sitemap">')
						FileWriteLine($FO_INDEX_HND, '   ' & $TNAME)
						FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
						FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
						; create entries in index for #include as include
						If StringInStr($TNAME, 'value="#') > 0 Then
							FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
							FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($TNAME, "#", ""))
							FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
							FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
						EndIf
					WEnd
					FileWriteLine($FO_INDEX_HND, '	<LI> <OBJECT type="text/sitemap">')
					FileWriteLine($FO_INDEX_HND, '   ' & $NAME)
					FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
					FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
					; create entries in index for #include as include
					If StringInStr($NAME, 'value="#') > 0 Then
						FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
						FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($NAME, "#", ""))
						FileWriteLine($FO_INDEX_HND, '   ' & StringReplace($LINE, Chr(09), ""))
						FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
					EndIf
				EndIf
				; Skip link to sub-sections for the Project file
				If StringInStr($LINE, "#") = 0 Then
					$FN = StringTrimRight(StringTrimLeft($LINE, StringInStr(StringLower($LINE), 'value="') + 6), 2)
					; Read the HTM file for all @ MAcros and generate index entry for them
					If $MACROSECTION = 1 Then
						; open the HTM file for Input
						$FI_TOC_HNDI = FileOpen($FN, 0)
						If $FI_TOC_HNDI = -1 Then
							MsgBox(0, "Error", "Unable to open: " & $FN)
						EndIf
						While 1
							$LINEI = FileReadLine($FI_TOC_HNDI)
							If @error = -1 Then
								ExitLoop
							EndIf
							; Check for '>@' or '> @'
							Local $aName = StringRegExp($LINEI, "<td>.*?>(@\w+)<.*?</td>", 1)
							If UBound($aName) Then
								$NAME = $aName[0]
								; MsgBox(0,$name,$name)
								FileWriteLine($FO_INDEX_HND, '	<LI> <OBJECT type="text/sitemap">')
								FileWriteLine($FO_INDEX_HND, '   <param name="Name" value="' & $NAME & '">')
								FileWriteLine($FO_INDEX_HND, '   <param name="Local" value="' & $FN & '#' & $NAME & '">')
								FileWriteLine($FO_INDEX_HND, '		</OBJECT>')
							EndIf
						WEnd
						FileClose($FI_TOC_HNDI)
					EndIf
				EndIf
		EndSelect
	WEnd
	;end
	FileWriteLine($FO_INDEX_HND, '</UL>')
	FileWriteLine($FO_INDEX_HND, '</BODY></HTML>')
	;
	FileClose($FI_TOC_HND)
	FileClose($FO_INDEX_HND)
EndFunc   ;==>Main
;
Func Debug($MESSAGE)
	MsgBox($MB_SYSTEMMODAL, 'debug', $MESSAGE)
EndFunc   ;==>Debug
;
Func WriteLog($LMSG)
	FileWriteLine(@ScriptDir & "\genindex.log", $LMSG)
EndFunc   ;==>WriteLog
