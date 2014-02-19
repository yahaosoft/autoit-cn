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

FileChangeDir(@ScriptDir)

; to be used for passing the /RegenAll
Local $Cmd1 = ""
If $CmdLine[0] Then $Cmd1 = $CmdLine[1]

_OutputBuildWrite("Generate HTM files for all changed UDFs" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_txt2Htm.au3 /UDFs ' & $Cmd1)

_OutputBuildWrite("Generate Reference HTM files for UDFs" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_RefPages.au3 /UDFs')

_OutputBuildWrite("Creating the index and TOC entries for all User defined functions" & @CRLF)
Main()

_OutputBuildWrite("Generate Management HTM files for UDFs" & @CRLF)
RunWait('"' & @AutoItExe & '"' & ' ..\..\_build\include\Gen_MgtPages.au3 /UDFs')

Exit

Func OnQuit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func Main()
	;
	; **********************************************************
	; create the Index/TOC with all UDF functions
	; **********************************************************
	;

	Local $FO_TOC_HND = FileOpen("UDFs3 TOC.hhc", BitOR($FO_OVERWRITE, $FO_UTF8))
	FileWriteLine($FO_TOC_HND, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">')
	FileWriteLine($FO_TOC_HND, '<HTML>')
	FileWriteLine($FO_TOC_HND, '<HEAD>')
	FileWriteLine($FO_TOC_HND, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">')
	FileWriteLine($FO_TOC_HND, '<!-- Sitemap 1.0 -->')
	FileWriteLine($FO_TOC_HND, '</HEAD><BODY>')
	FileWriteLine($FO_TOC_HND, '<OBJECT type="text/site properties">')
	FileWriteLine($FO_TOC_HND, '<param name="Window Styles" value="0x800025">')
	FileWriteLine($FO_TOC_HND, '<param name="ImageType" value="Folder">')
	FileWriteLine($FO_TOC_HND, '</OBJECT>')
	FileWriteLine($FO_TOC_HND, '<UL>')
	FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
	FileWriteLine($FO_TOC_HND, '<param name="Name" value="User Defined Functions Reference">')
	FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions.htm">')
	FileWriteLine($FO_TOC_HND, '</OBJECT>')
	FileWriteLine($FO_TOC_HND, '<UL>')
	FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
	FileWriteLine($FO_TOC_HND, '<param name="Name" value="User Defined Function Notes">')
	FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunction_notes.htm">')
	FileWriteLine($FO_TOC_HND, '</OBJECT>')

	Local $FO_INDEX_HND = FileOpen("UDFs3 Index.hhk", BitOR($FO_OVERWRITE, $FO_UTF8))
	FileWriteLine($FO_INDEX_HND, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">')
	FileWriteLine($FO_INDEX_HND, '<HTML>')
	FileWriteLine($FO_INDEX_HND, '<HEAD>')
	FileWriteLine($FO_INDEX_HND, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">')
	FileWriteLine($FO_INDEX_HND, '<!-- Sitemap 1.0 -->')
	FileWriteLine($FO_INDEX_HND, '</HEAD><BODY>')
	FileWriteLine($FO_INDEX_HND, '<UL>')
	FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
	FileWriteLine($FO_INDEX_HND, '<param name="Name" value="User Defined Functions Reference">')
	FileWriteLine($FO_INDEX_HND, '<param name="Local" value="html\libfunctions.htm">')
	FileWriteLine($FO_INDEX_HND, '</OBJECT>')
	FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
	FileWriteLine($FO_INDEX_HND, '<param name="Name" value="User Defined Function Notes">')
	FileWriteLine($FO_INDEX_HND, '<param name="Local" value="html\libfunction_notes.htm">')
	FileWriteLine($FO_INDEX_HND, '</OBJECT>')
	FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
	FileWriteLine($FO_INDEX_HND, '<param name="Name" value="UDFs Constants include files">')
	FileWriteLine($FO_INDEX_HND, '<param name="Local" value="html\libfunction_constants.htm">')
	FileWriteLine($FO_INDEX_HND, '</OBJECT>')

	FileDelete(@ScriptDir & "\genindex.log")

	Local $HELPFILEDIR = @ScriptDir ; specify the root of the helpfiles

	Local $FI_DIR_HND = FileOpen($HELPFILEDIR & "\txt2htm\txtlibfunctions\Categories.toc")
	; Check if file opened for reading OK
	If $FI_DIR_HND = -1 Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Unable to open:" & $HELPFILEDIR & "\txt2htm\txtlibfunctions\Categories.toc")
		Exit
	EndIf

	DirCreate($HELPFILEDIR & "\html\libfunctions")

	; write the top of the page of the userfunctions page
	Local $SAVE_CATEGORY = "", $SAVE_SUBCATEGORY = "", $SAVE_SUBSUBCATEGORY = ""
	Local $FLINE, $FTOC, $FSUBTOC, $FSUBSUBTOC, $FNAME, $iSplit, $FSUBTOCPRE
	While 1
		; get filename from include subdir
		$FLINE = FileReadLine($FI_DIR_HND)
		If @error = -1 Then
			ExitLoop
		EndIf
		$FLINE = StringReplace($FLINE, "&", "&amp;")
		$FTOC = StringLeft($FLINE, StringInStr($FLINE, "|", 0, -1) - 1)
		$iSplit = StringInStr($FTOC, " Reference")
		If $iSplit Then
			$FSUBTOCPRE = StringLeft($FTOC, $iSplit)
		Else
			$FSUBTOCPRE = ""
		EndIf
		$iSplit = StringInStr($FTOC, "|")
		If $iSplit Then
			$FSUBTOC = StringTrimLeft($FTOC, $iSplit)
			$FTOC = StringLeft($FTOC, $iSplit - 1)
			$iSplit = StringInStr($FSUBTOC, "|")
			If $iSplit Then
				$FSUBSUBTOC = StringTrimLeft($FSUBTOC, $iSplit)
				$FSUBTOC = StringLeft($FSUBTOC, $iSplit - 1)
			Else
				$FSUBSUBTOC = ""
			EndIf
		Else
			$FSUBTOC = ""
			$FSUBSUBTOC = ""
		EndIf
		$FNAME = StringTrimLeft($FLINE, StringInStr($FLINE, "|", 0, -1))
		If StringInStr($FNAME, ":") Then
			$FNAME = StringSplit($FNAME, ":")
;~ 			$FAU3 = $FNAME[1]
			$FNAME = $FNAME[2]
		EndIf
		;;ShowMenu(" *** " & $FTOC & " -> " & $FNAME, 2)
		; close previous category
		If $SAVE_CATEGORY <> $FTOC Then
			; close previous category
			If $SAVE_SUBSUBCATEGORY <> "" Then
				FileWriteLine($FO_TOC_HND, "</UL>")
				$SAVE_SUBSUBCATEGORY = ""
			EndIf
			; close previous category
			If $SAVE_SUBCATEGORY <> "" Then
				FileWriteLine($FO_TOC_HND, "</UL>")
				$SAVE_SUBCATEGORY = ""
			EndIf
			If $SAVE_CATEGORY <> "" Then
				FileWriteLine($FO_TOC_HND, "</UL>")
				$SAVE_CATEGORY = ""
			EndIf
			$SAVE_CATEGORY = $FTOC
			FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
			FileWriteLine($FO_TOC_HND, '<param name="Name" value="' & $FTOC & '">')
			If StringInStr($FTOC, ' Reference') Then
				If StringInStr($FTOC, 'GUI') Then
					FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions\GUI Reference.htm">')
				Else
					FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions\WinAPIEx Reference.htm">')
				EndIf
			Else
				FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions\' & $FTOC & '.htm">')
			EndIf
			FileWriteLine($FO_TOC_HND, '</OBJECT>')
			FileWriteLine($FO_TOC_HND, "<UL>")
		EndIf
		; close previous subsub category
		If $SAVE_SUBSUBCATEGORY <> $FSUBSUBTOC And $SAVE_SUBSUBCATEGORY <> "" Then
			FileWriteLine($FO_TOC_HND, "</UL>")
			$SAVE_SUBSUBCATEGORY = ""
		EndIf
		; close previous sub category
		If $SAVE_SUBCATEGORY <> $FSUBTOC And $SAVE_SUBCATEGORY <> "" Then
			FileWriteLine($FO_TOC_HND, "</UL>")
			$SAVE_SUBCATEGORY = ""
		EndIf
		If $SAVE_SUBCATEGORY <> $FSUBTOC Then
			$SAVE_SUBCATEGORY = $FSUBTOC
			FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
			FileWriteLine($FO_TOC_HND, '<param name="Name" value="' & $FSUBTOC & '">')
			FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions\' & StringReplace($FSUBTOCPRE & $FSUBTOC, "&amp;","&") & '.htm">')
			FileWriteLine($FO_TOC_HND, '</OBJECT>')
			FileWriteLine($FO_TOC_HND, "<UL>")
		EndIf
		If $SAVE_SUBSUBCATEGORY <> $FSUBSUBTOC Then
			$SAVE_SUBSUBCATEGORY = $FSUBSUBTOC
			FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
			FileWriteLine($FO_TOC_HND, '<param name="Name" value="' & $FSUBSUBTOC & '">')
			FileWriteLine($FO_TOC_HND, '<param name="Local" value="html\libfunctions\' & StringReplace($FSUBTOCPRE & $FSUBSUBTOC, "&amp;","&") & '.htm">')
			FileWriteLine($FO_TOC_HND, '</OBJECT>')
			FileWriteLine($FO_TOC_HND, "<UL>")
		EndIf
		If Not FileExists('html\libfunctions\' & $FNAME & '.htm') Then
			_OutputBuildWrite("File not found...skipped :" & 'html\libfunctions\' & $FNAME & '.htm' & @CRLF)
			WriteLog("File not found...skipped :" & 'html\libfunctions\' & $FNAME & '.htm')
		Else
			; write TOC entry
			FileWriteLine($FO_TOC_HND, '<LI> <OBJECT type="text/sitemap">')
			FileWriteLine($FO_TOC_HND, '   <param name="Name" value="' & $FNAME & '">')
			FileWriteLine($FO_TOC_HND, '   <param name="Local" value="html\libfunctions\' & $FNAME & '.htm">')
			FileWriteLine($FO_TOC_HND, '   </OBJECT>')
			; write index entry
			FileWriteLine($FO_INDEX_HND, '<LI> <OBJECT type="text/sitemap">')
			FileWriteLine($FO_INDEX_HND, '   <param name="Name" value="' & $FNAME & '">')
			FileWriteLine($FO_INDEX_HND, '   <param name="Local" value="html\libfunctions\' & $FNAME & '.htm">')
			FileWriteLine($FO_INDEX_HND, '   </OBJECT>')
		EndIf
	WEnd
	; close off the Category FileChangeDir and end the TOC UL for the last include file
	If $SAVE_SUBCATEGORY <> "" Then FileWriteLine($FO_TOC_HND, "</UL>")
	If $SAVE_SUBSUBCATEGORY <> "" Then FileWriteLine($FO_TOC_HND, "</UL>")
	FileWriteLine($FO_TOC_HND, "</UL>")

	; end the TOC UL for UDF's
	FileWriteLine($FO_TOC_HND, "</UL>")
	FileWriteLine($FO_TOC_HND, "</UL>")
	FileWriteLine($FO_TOC_HND, '</BODY></HTML>')
	FileClose($FO_TOC_HND)
	;
	FileWriteLine($FO_INDEX_HND, '</UL>')
	FileWriteLine($FO_INDEX_HND, '</BODY></HTML>')
	FileClose($FO_INDEX_HND)

	FileClose($FI_DIR_HND)
EndFunc   ;==>Main

Func WriteLog($LMSG)
	FileWriteLine(@ScriptDir & "\genindex.log", $LMSG)
EndFunc   ;==>WriteLog
