;  AutoIt:  3.0.91 with "smart boolean comparison" and FileChangeDir
; Platform:  Tested on "American" Windows XP sp1
;  Author:  CyberSlug - philipgump@yahoo.com
;    Date:  31 Jan 2004
; Updated:  02 Feb 2004 jpm
;           - conditional generation time based
; Updated:  28 Feb 2004 jpm
;           - StandardTable and ParamTable
;   Added:  18 may 2004 jos
;           - support for UDF files.
;   Added:  31 Dec 2004 jos
;           - Commandline option "/RegenAll" to update all in stead of just the changes
;           - Changed the MakeRelatedLinks so it checks all sources.
;             This makes it possible to make references to in functions to keywords
;             and in UDF's to internal functions
;   Added:  03 Jan 2005 jos
;           - Button to open function examples.
;   Added:  14 Jan 2005 jos
;           - Conversion of Au3 examples to Colored HTM versions by using SciTE.
;   Fixed:  06 Apr 2005 jpm
;           - suppress mixing source Au3 examples and Colored HTM conversions files
;           - closing of SciTE process used to colored examples
;			- colored example for new help page file not generated if SciTE already open
;   Added:  18 Sep 2005 jpm
;           - /AutoIT /UDFs command parameter for selective regeneration
;           - split AutoIt and UDF examples
;   Added:  19 May 2006 jpm
;           - ReturnTable valign=top on 1st column
;   Added:  04 Dec 2006 jpm
;           - use generated au3.api and au3.keyword.properties for right coloring
;   Fixed:  09 Mar 2007 jpm
;           - au3.api and au3.keyword.properties not properly copied
; Changed:  09 May 2007 Jos
;			- Added keyword mainHtmlweb = "Web\" to txt2htm.ini
;			  When this keyword is BLANK the generation of these files is skipped.
;			- Updated All_txt2htm.au3 to generate the Web HTM files.
;			Also:
;			reload the SciTE config without the need to close SciTE using the SciTE Director interface.
;			use the SciTE Director interface to Export the Examples to Htm avoid the need to load/use the external program.
;			Minimise SciTE during Export process to avoid the flashing screen and think its a bit faster.
; Changed:  29 Sep 2007  Jos
;			Made changes to accommodate the structure definitions.
;   Added:  11 Oct 2007 jpm
;           - search MSDN : @@IncludeMsdnLink@@
;   Added:  29 Oct 2007 Jos
;           - @ScriptDir & "\txt2htm_error.log" which will contain the generated errors/warnings
;           to allow easy verification and review of the errors.
; Updated:  09 Jan 2012 jpm
;           - StandardTable and StandardTable1 support new default.css
; Updated:  10 Jan 2012 jpm
;           - @LF to @CRLF to be able to generate ANSI/PC files
; Updated:  10 Jan 2012 Jos
;           - dynamic reloading of au3.keywords.properties to have right coloring
; Updated:  23 Jul 2012 jpm
;           - ReturnTable 2nd column concatenation
;           - ReturnTable without border
; Updated:  01 Nov 2012 Mat
;           - direct Msdn link instead a query page result.
;   Added:  11 Nov 2012 jpm
;           - Copyto clipboard button in example area
; Updated:  20 Jan 2013 Mat
;           - Added ability to use multiple example files using the format FunctionName[n].au3
; Updated:  12 Mar 2013 jpm
;           - Reorg to have same source for AutoItX generation
; Updated:  13 jul 2013 jos
;           - Changed the path for include to support building from DOCS directory
;==============================================================================
; Generate HTM files (which comprise the help file source docs)
; from specially formatted TXT files.
;==============================================================================

;Script is designed to optionally take command-line arguments.
;If args, they should be the text files you wish to convert to htm.
;  However, the working directory is used as output.
;If no args, script uses data from the 'txt2htm.ini' file....
;  The zero-arg method gives nice splashscreen logging!

#include "OutputLib.au3"
#include "SciTELib.au3"
#include <Constants.au3>
#include <File.au3>
#include <SendMessage.au3>

Opt("TrayIconDebug", 1)

OnAutoItExitRegister("OnQuit") ; ### Debug Console
_OutputWindowCreate() ; ### Debug Console

Global $ReGen_All = StringInStr($CmdLineRaw, "/RegenAll") > 0
Global $ReGen_AutoIt = StringInStr($CmdLineRaw, "/AutoIt") > 0
Global $ReGen_UDFs = StringInStr($CmdLineRaw, "/UDFs") > 0
Global $ReGen_AutoItX = False

If FileExists(@WorkingDir & "\AutoItX.hhp") Then
	$ReGen_AutoItX = True
Else
	If Not $ReGen_AutoIt And Not $ReGen_UDFs Then
		; Re-Generate AutoIt and UDFs
		$ReGen_AutoIt = True
		$ReGen_UDFs = True
	EndIf
EndIf

Global Const $TXT2HTM_INI = @WorkingDir & "\txt2htm.ini"
Global $CROSS_DIR = "", _
		$CROSSLINK = "", _
		$INPUT_DIR = "", _
		$OUTPUT_DIR = "", _
		$TEMP_LIST = "fileList.tmp", _
		$EXAMPLE_DIR = "", _
		$EXAMPLE_EXT = ""

Global $g_aArrayInput = 0 ; Array containing each line of the txt-file to convert
Global $g_sFilePath = "" ; Name of the file being converted

; Clear previous log
FileDelete(@WorkingDir & "\txt2htm_error.log")

_OutputBuildWrite("txt2htm Conversion" & @CRLF)

Global $RefType_Main = ""

; TestingOnly()
; OnAutoItExitUnRegister("OnQuit") ; ### Debug Console
; Exit

Global $EXAMPLE_DIRO = IniRead($TXT2HTM_INI, "Output", "Examples", "ERR")
DirCreate($EXAMPLE_DIRO)

If Not $ReGen_AutoItX Then SciTECreate()

If $ReGen_AutoIt Then
	$RefType_Main = "Function"
	$EXAMPLE_EXT = ".au3"
	$CROSS_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	$CROSSLINK = IniRead($TXT2HTM_INI, "CrossLink", "AutoIt", "ERR")
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$EXAMPLE_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "Examples", "ERR")
	_OutputBuildWrite("Scanning Functions..." & @CRLF)
	ReBuild()
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "keywords", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "keywords", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	_OutputBuildWrite("Scanning Keywords..." & @CRLF)
	ReBuild()
EndIf

If $ReGen_UDFs Then
	$RefType_Main = "Function"
	$EXAMPLE_EXT = ".au3"
	$CROSS_DIR = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
	$CROSSLINK = IniRead($TXT2HTM_INI, "CrossLink", "UDFs", "ERR")
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$EXAMPLE_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "LibExamples", "ERR")
	_OutputBuildWrite("Scanning UDF's..." & @CRLF)
	ReBuild()
EndIf

If $ReGen_AutoItX Then
	$RefType_Main = "Method"
	$EXAMPLE_EXT = ".vbs"
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "methods", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$EXAMPLE_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "Examples", "ERR")
	_OutputBuildWrite("Scanning Methods..." & @CRLF)
	ReBuild()
EndIf
Exit

Func OnQuit()
	; Close the SciTE related functions.
	_SciTE_Quit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func SciTECreate() ; Fixed by guinness - 27/08/2013
	Local $sSciTEProgram = "..\..\..\install\SciTe\SciTE.exe"

	; Use the generated version of SciTE4AutoIt3 when it exists.
	If Not FileExists($sSciTEProgram) Then $sSciTEProgram = RegRead("HKLM\Software\Microsoft\Windows\Currentversion\App Paths\Scite.Exe", "")

	Local $sAu3KeywordsProperties = "..\..\..\install\SciTe\au3.keywords.properties"
	; Use the generated version of au3.keywords.properties when it exists. Otherwise copy from Program Files\AutoIt3.
	If Not FileExists($sAu3KeywordsProperties) Then
;		FileCopy(@ProgramFilesDir & "\AutoIt3\SciTE\au3.keywords.properties", $sAu3KeywordsProperties, $FC_OVERWRITE + $FC_CREATEPATH)
;		FileCopy(@ProgramFilesDir & "\AutoIt3\SciTE\Properties\au3.keywords.properties", $sAu3KeywordsProperties, $FC_OVERWRITE + $FC_CREATEPATH)
;		FileCopy("c:\app\AutoIt\SciTE\ÊôÐÔÎÄ¼þ\au3.keywords.properties", $sAu3KeywordsProperties, 9)
	EndIf

	; Look for a running instance of SciTE. If it is found then ask the user to close it.
	; We do not want to use an existing session because it may have SciTE_HOME set.
	; If that environment variable is set then SciTE will load the user's properties files which can cause problems with syntax highlighting.
	; While SciTE exists display the following mmessage.
	While _SciTE_IsExists()
		MsgBox($MB_SYSTEMMODAL, "Error", "SciTE is running, please close all instances of SciTE and press OK to continue.")
	WEnd

	; When not found, prompt for the SciTE.exe location.
	If $sSciTEProgram = "" Or Not FileExists($sSciTEProgram) Then FileOpenDialog("Couldn't find SciTE.exe... please select it.", @WorkingDir, "SciTE (SciTE.exe)", $FD_FILEMUSTEXIST)
	If FileExists($sSciTEProgram) Then
		; Set the SciTE_HOME environment variable to override the user's.
		; This prevents the user's property files from getting loaded and causing issues.
;~ 		EnvSet("SciTE_HOME", @TempDir)
		Run($sSciTEProgram)
		WinWait(_SciTE_GetSciTETitle())
	Else
		Exit MsgBox($MB_SYSTEMMODAL, "Error", "Unable to find SciTE, aborting.") ; Exit the build scripts.
	EndIf

	; Initialise the SciTE functions.
	_SciTE_Startup()

	; Load the Au3 properties file in the install\SciTE directory.
;~ 	_SciTE_LoadPropertiesFile($sAu3KeywordsProperties)
	; Reload the SciTE properties.
	_SciTE_ReloadProperties()

	; Set the state of SciTE to minimized.
	WinSetState(_SciTE_WinGetSciTE(), "", @SW_MINIMIZE)
EndFunc   ;==>SciTECreate

Func ReBuild()
	; Pipe the list of sorted file names to fileList.tmp:
	_RunCmd("dir " & $INPUT_DIR & "*.txt /b | SORT > " & $TEMP_LIST)
	Local $hFileList = FileOpen($TEMP_LIST)
	If $hFileList = -1 Then
		Exit MsgBox($MB_SYSTEMMODAL, "Error", $TEMP_LIST & " could not be opened and/or found.")
	EndIf

	Local $sFilePath = ""
	While 1 ; Loop through each filename contained in fileList.tmp
		$g_sFilePath = FileReadLine($hFileList)
		If @error = -1 Then ExitLoop ; EOF reached

		$sFilePath = $INPUT_DIR & $g_sFilePath
		If StringStripWS($sFilePath, $STR_STRIPALL) = "" Then ExitLoop

		ConvertTextToHTML($sFilePath)
	WEnd

	FileClose($hFileList)
EndFunc   ;==>ReBuild

;------------------------------------------------------------------------------
; The main conversion function
;------------------------------------------------------------------------------
Func ConvertTextToHTML($sFilePath)
	If Not FileExists($sFilePath) Then
		_OutputBuildWrite($sFilePath & " was not found; skipping it." & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", $sFilePath & " was not found; skipping it.")
		Return 0
	EndIf
	If Not _FileReadToArrayEx($sFilePath, $g_aArrayInput) Then
		_OutputBuildWrite($sFilePath & " was not found; skipping it." & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", $sFilePath & " was not found; skipping it.")
		Return 0
	EndIf

	Local $sFileName = _GetFileName($sFilePath)
	Local $sHTMLFile = $OUTPUT_DIR & $sFileName & ".htm"

	Local $fReBuild = False, _
			$hFindFilePath = 0, _
			$sFindFilePath = ""
	If Not $ReGen_All Then
		If FileExists($EXAMPLE_DIR & $sFileName & "[2]" & $EXAMPLE_EXT) Then
			; Multiple files exist
			$hFindFilePath = FileFindFirstFile($EXAMPLE_DIR & $sFileName & "[*]" & $EXAMPLE_EXT)
			While 1
				$sFindFilePath = FileFindNextFile($hFindFilePath)
				If @error Then ExitLoop
				If Not IsGreaterFileTime($EXAMPLE_DIR & $sFindFilePath, $sHTMLFile) Then $fReBuild = True
			WEnd

			FileClose($hFindFilePath)
		EndIf

		If Not $fReBuild And IsGreaterFileTime($sFilePath, $sHTMLFile) Then
			If FileExists($EXAMPLE_DIR & $sFileName & $EXAMPLE_EXT) Then
				If IsGreaterFileTime($EXAMPLE_DIR & $sFileName & $EXAMPLE_EXT, $sHTMLFile) Then Return 0
			Else
				Return 0
			EndIf
		EndIf
	EndIf

	Local $hFileOpen = FileOpen($sHTMLFile, BitOR($FO_OVERWRITE, $FO_UTF8))
	Local $sRefType = StringStripWS(get(""), $STR_STRIPLEADING + $STR_STRIPTRAILING)

	If $sRefType <> "###" & $RefType_Main & "###" And $sRefType <> "###Keyword###" And $sRefType <> "###User Defined Function###" And $sRefType <> "###Structure Name###" And $sRefType <> "###Operator###" And $sRefType <> "###Macro###" Then
		_OutputBuildWrite($sFilePath & " has invalid first line; skipping file." & @CRLF)
		_OutputBuildWrite('x' & $sRefType & 'x' & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", $sFilePath & " has invalid first line; skipping file.")
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", 'x' & $sRefType & 'x')
		Return "Error"
	Else
		_OutputBuildWrite($sFilePath & @CRLF)
	EndIf

	Local $sFunctionOrKeyword = StringReplace(get($sRefType), '<br />', '') ; Name of the function or keyword

	FileWrite($hFileOpen, '<!DOCTYPE html>' & @CRLF)
	FileWrite($hFileOpen, '<html>' & @CRLF)
	FileWrite($hFileOpen, '<head>' & @CRLF)
	If StringInStr($sRefType, $RefType_Main) > 0 Then
		FileWrite($hFileOpen, '  <title>' & $RefType_Main & ' ' & $sFunctionOrKeyword & '</title>' & @CRLF)
	ElseIf StringInStr($sRefType, "Operator") Then
		FileWrite($hFileOpen, '  <title>Operator ' & $sFunctionOrKeyword & '</title>' & @CRLF)
	Else
		FileWrite($hFileOpen, '  <title>Keyword ' & $sFunctionOrKeyword & '</title>' & @CRLF)
	EndIf
	FileWrite($hFileOpen, '  <meta charset="utf-8">' & @CRLF)
	If $ReGen_AutoItX Then
		FileWrite($hFileOpen, '  <link href="../../css/default.css" rel="stylesheet">' & @CRLF)
	Else
		FileWrite($hFileOpen, '  <link href="../css/default.css" rel="stylesheet">' & @CRLF)
	EndIf
	FileWrite($hFileOpen, '</head>' & @CRLF)
	FileWrite($hFileOpen, '' & @CRLF)
	FileWrite($hFileOpen, '<body>' & @CRLF)

	; Insert the experimental section if required.
	If get("###Experimental###") Then
		FileWrite($hFileOpen, '<div class="experimental">Warning: This feature is experimental.  It may not work, may contain bugs or may be changed or removed without notice.<br /><br />DO NOT REPORT BUGS OR REQUEST NEW FEATURES FOR THIS FEATURE.</div><br/>' & @CRLF)
	EndIf

	If StringInStr($sRefType, $RefType_Main) > 0 Then
		FileWrite($hFileOpen, '<h1 class="small">' & $RefType_Main & ' Reference</h1>' & @CRLF)
	ElseIf StringInStr($sRefType, "Operator") Then
		FileWrite($hFileOpen, '<h1 class="small">Operator Reference</h1>' & @CRLF)
	Else
		FileWrite($hFileOpen, '<h1 class="small">Keyword Reference</h1>' & @CRLF)
	EndIf
	FileWrite($hFileOpen, '<hr style="height:0px">' & @CRLF)
	FileWrite($hFileOpen, '<h1>' & $sFunctionOrKeyword & '</h1>' & @CRLF)
	FileWrite($hFileOpen, '<p class="funcdesc">' & get("###Description###") & '</p>' & @CRLF)
	FileWrite($hFileOpen, '')

	FileWrite($hFileOpen, '<p class="codeheader">' & @CRLF)
	FileWrite($hFileOpen, get("###Syntax###") & @CRLF)
	FileWrite($hFileOpen, '</p>' & @CRLF)

	FileWrite($hFileOpen, '' & @CRLF)
	FileWrite($hFileOpen, '<h2>Parameters</h2>' & @CRLF)
	FileWrite($hFileOpen, '' & get("###Parameters###") & '' & @CRLF)
	FileWrite($hFileOpen, '' & get("###Fields###") & '' & @CRLF)
	FileWrite($hFileOpen, '' & @CRLF)
	If StringInStr($sRefType, $RefType_Main) > 0 Then
		FileWrite($hFileOpen, '<h2>Return Value</h2>' & @CRLF)
		FileWrite($hFileOpen, '' & get("###ReturnValue###") & '' & @CRLF)
		FileWrite($hFileOpen, '' & @CRLF)
	EndIf
	FileWrite($hFileOpen, '<h2>Remarks</h2>' & @CRLF)
	FileWrite($hFileOpen, '' & get("###Remarks###") & '' & @CRLF)
	FileWrite($hFileOpen, '' & @CRLF)
	Local $sRelated = get("###Related###")
	If StringStripWS($sRelated, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then
		FileWrite($hFileOpen, '<h2>Related</h2>' & @CRLF)
		FileWrite($hFileOpen, '' & $sRelated & '' & @CRLF)
		FileWrite($hFileOpen, '' & @CRLF)
	EndIf
	; only add "See also" section if requested
	Local $sSeeAlso = get("###See Also###")
	If StringStripWS($sSeeAlso, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then
		FileWrite($hFileOpen, '<h2>See Also</h2>' & @CRLF)
		FileWrite($hFileOpen, '' & $sSeeAlso & '' & @CRLF)
	EndIf

	; only add example box when example file is available
	Local $vExample = get("###Example###")
	If UBound($vExample) Or StringStripWS($vExample, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then
		FileWrite($hFileOpen, '' & @CRLF)
		FileWrite($hFileOpen, '<h2 class="bottom">Example</h2>' & @CRLF)
		FileWrite($hFileOpen, '<script type="text/javascript">' & @CRLF)
		FileWrite($hFileOpen, 'if ((navigator.appName=="Microsoft Internet Explorer") && (parseInt(navigator.appVersion)>=4)) // IE (4+) only' & @CRLF)
		FileWrite($hFileOpen, '    function copyToClipboard(s){if (window.clipboardData && clipboardData.setData){clipboardData.setData("text", s + "\r\n");alert("Copied to clipboard");}}' & @CRLF)
		FileWrite($hFileOpen, '</script>' & @CRLF)

		If UBound($vExample) Then
			; More than one example
			For $i = 0 To UBound($vExample) - 1
				FileWrite($hFileOpen, '<h3>' & $vExample[$i][0] & '</h3>' & @CRLF)
				FileWrite($hFileOpen, $vExample[$i][1] & @CRLF)
				FileWrite($hFileOpen, '' & @CRLF)
			Next
		ElseIf StringStripWS($vExample, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then
			FileWrite($hFileOpen, $vExample & @CRLF)
			FileWrite($hFileOpen, '' & @CRLF)
		EndIf
	EndIf

	FileWrite($hFileOpen, '</body>' & @CRLF)
	FileWrite($hFileOpen, '</html>' & @CRLF)
	FileClose($hFileOpen)

	Return True
EndFunc   ;==>ConvertTextToHTML

;------------------------------------------------------------------------------
; Retrieve text from $g_aArrayInput to put into html file
;------------------------------------------------------------------------------
Func get($sSection)
	If $sSection = "" Then Return $g_aArrayInput[1] ;very first line

	Local $sTempString, $iCount = 0
	Local $iUBoundInput = UBound($g_aArrayInput)
	While $iCount + 1 < $iUBoundInput
		$iCount = $iCount + 1
		If StringInStr($g_aArrayInput[$iCount], $sSection) Then ExitLoop
	WEnd
	If $iCount + 1 < $iUBoundInput Then $iCount = $iCount + 1 ;$iCount is now index of first line after the section heading

	Switch $sSection
		Case "###Experimental###"
			; This is an extremely ugly hack to work-around the surrounding
			; crappy code that makes lots of absurd assumptions about the format
			; of the file. What this does is test if the ###Experimental###
			; section exists. It returns a boolean to indicate if the section
			; is present. It determines the section is present by looking
			; at the counter and testing if it is larger than the input size
			; implying that it wasn't found.
			Return $iCount + 1 < $iUBoundInput
		Case "###" & $RefType_Main & "###", "###Keyword###"
			Return $g_aArrayInput[$iCount]
		Case "###Related###"
			Return makeRelatedLinks($iCount)
		Case "###Example###"
			Return makeExample($iCount)
		Case "###Special###" ;Random.htm has a special section
			$sTempString = '<p>' & @CRLF
			For $k = $iCount To $iUBoundInput - 1
				$sTempString = $sTempString & $g_aArrayInput[$k] & '<br />' & @CRLF
			Next
			Return $sTempString & '</p>'
	EndSwitch

	$sTempString = ""
	While $iCount < $iUBoundInput - 1
		If StringInStr($g_aArrayInput[$iCount], "###") Then ExitLoop
		; makes sure not to go beyond own section
		If StringInStr($g_aArrayInput[$iCount], "@@ParamTable@@") Then
			$sTempString = $sTempString & makeParamTable($iCount)
		ElseIf StringInStr($g_aArrayInput[$iCount], "@@ControlCommandTable@@") Then
			$sTempString = $sTempString & makeControlCommandTable($iCount)
		ElseIf StringInStr($g_aArrayInput[$iCount], "@@StandardTable@@") Then
			$sTempString = $sTempString & makeStandardTable($iCount)
		ElseIf StringInStr($g_aArrayInput[$iCount], "@@StandardTable1@@") Then
			$sTempString = $sTempString & makeStandardTable1($iCount)
		ElseIf StringInStr($g_aArrayInput[$iCount], "@@ReturnTable@@") Then
			$sTempString = $sTempString & makeReturnTable($iCount)
		ElseIf StringInStr($g_aArrayInput[$iCount], "@@MsdnLink@@") Then
			$sTempString = $sTempString & makeMsdnLink($iCount)
		Else
			; will ignore blank lines...
			; but in Remarks section, allow non-consecutive blank lines...
			If StringStripWS($g_aArrayInput[$iCount], $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Or $sSection = "###" & $RefType_Main & "###" Then
				;In case of a include <...> Also translate < and >
				If StringInStr($g_aArrayInput[$iCount], "#include <") Then
					$g_aArrayInput[$iCount] = StringRegExpReplace($g_aArrayInput[$iCount], '(.*#include )<(.*)>(.*)', ' $1&lt;$2&gt;$3')
				EndIf
				$sTempString = $sTempString & spaceToNBSP($g_aArrayInput[$iCount]) & '<br />' & @CRLF
			Else
				If $sSection = "###Remarks###" And $iCount + 1 < $iUBoundInput - 1 Then
					If StringStripWS($g_aArrayInput[$iCount + 1], $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then $sTempString = $sTempString & '<br />' & @CRLF
				EndIf
			EndIf
		EndIf
		$iCount += 1
	WEnd

	Return StringStripWS($sTempString, $STR_STRIPTRAILING) ;remove trailing whitespace
EndFunc   ;==>get

;------------------------------------------------------------------------------
; Makes the names of related functions into links
;------------------------------------------------------------------------------
Func makeRelatedLinks($iIndex)
	;links already containing '<a href' are pasted as is
	;normal function names and AutoItSetOption '(Option)' are "linkified"
	;assumes that multiple links are comma-separated

	;Handle special cases when no links

	Local $links = StringSplit(StringReplace($g_aArrayInput[$iIndex], ", ", "|"), "|")
	Local $errFlag = @error
	If $errFlag And StringInStr($g_aArrayInput[$iIndex], "none") Then
		Return "None."
	ElseIf $errFlag And StringInStr($g_aArrayInput[$iIndex], "many") Then
		Return "Many!" ;special instance in AutoItSetOption
	ElseIf $errFlag Then
		;StringSplit did not create array since only one link (no comma)
		Dim $links[2]
		$links[1] = $g_aArrayInput[$iIndex]
	EndIf

	;Create links

	Local $tempdir_In, $tempdir_Out, $sHTMLName, $tag, $tmp = ""
	For $i = 1 To UBound($links) - 1
		If StringStripWS($links[$i], $STR_STRIPLEADING) = "" Then ContinueLoop
		If StringInStr($links[$i], "<a href") Then
			$tmp = $tmp & $links[$i] & ", "
		ElseIf StringInStr($links[$i], " (Option)") Then
			$tag = StringReplace($links[$i], " (Option)", "")
			$tmp = $tmp & '<a href="AutoItSetOption.htm#' & $tag & '">' & $links[$i] & '</a>, '
		Else
			$sHTMLName = $links[$i]
			If StringInStr($sHTMLName, "/") Then ;  with aliases
				$sHTMLName = StringSplit($sHTMLName, "/")
				$sHTMLName = $sHTMLName[1]
			EndIf
			;  gui links to the summary pages
			If StringInStr($links[$i], "...") Then
				$sHTMLName = StringReplace($links[$i], "...", " Management")
			EndIf

			; links cross .chm
			If StringLeft($links[$i], 1) = "." Then
				$sHTMLName = StringReplace($links[$i], ".", "")
			EndIf

			If Not StringInStr($sHTMLName, " Management") Then
				; if the targetfile doesn't exist in the target htm dir then look in the other dirs.
				If Not FileExists($OUTPUT_DIR & $sHTMLName & ".htm") And Not FileExists($INPUT_DIR & $sHTMLName & ".txt") Then
					If $ReGen_AutoItX Then
						$tempdir_In = IniRead($TXT2HTM_INI, "Input", "methods", "ERR")
						$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
						If Not FileExists($tempdir_Out & $sHTMLName & ".htm") And Not FileExists($tempdir_In & $sHTMLName & ".txt") Then
							_OutputBuildWrite('** Error in ' & $g_sFilePath & ' => Invalid Method reference to:' & $sHTMLName & @CRLF)
							FileWriteLine(@WorkingDir & "\txt2htm_error.log", '** Error in ' & $g_sFilePath & ' => Invalid Method reference to:' & $sHTMLName)
							;ContinueLoop
						EndIf
						$sHTMLName = "../../" & $tempdir_Out & $sHTMLName
					Else
						If Not FileExists($CROSS_DIR & $sHTMLName & ".txt") Then
							$tempdir_In = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
							$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
							If Not FileExists($tempdir_Out & $sHTMLName & ".htm") And Not FileExists($tempdir_In & $sHTMLName & ".txt") Then
								$tempdir_In = IniRead($TXT2HTM_INI, "Input", "keywords", "ERR")
								$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "keywords", "ERR")
								If Not FileExists($tempdir_Out & $sHTMLName & ".htm") And Not FileExists($tempdir_In & $sHTMLName & ".txt") Then
									$tempdir_In = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
									$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
									If Not FileExists($tempdir_Out & $sHTMLName & ".htm") And Not FileExists($tempdir_In & $sHTMLName & ".txt") Then
										_OutputBuildWrite('** Error in ' & $g_sFilePath & ' => Invalid Function reference to:' & $sHTMLName & @CRLF)
										FileWriteLine(@WorkingDir & "\txt2htm_error.log", '** Error in ' & $g_sFilePath & ' => Invalid Function reference to:' & $sHTMLName)
										;ContinueLoop
									EndIf
								EndIf
							EndIf
							$sHTMLName = "../../" & $tempdir_Out & $sHTMLName
						Else
							$links[$i] = $sHTMLName
							$sHTMLName = $CROSSLINK & $sHTMLName
						EndIf
					EndIf
				EndIf
			EndIf
			$sHTMLName = StringReplace($sHTMLName, "../../html\functions\", "../functions/") ; Workaround for incorrect links in keywords HTML file.
			$tmp = $tmp & '<a href="' & $sHTMLName & '.htm">' & $links[$i] & '()</a>, '
		EndIf
	Next

	Return StringTrimRight($tmp, 2) ;remove trailing comma and space
EndFunc   ;==>makeRelatedLinks

;------------------------------------------------------------------------------
; Makes the a link to MSDN
; 11 Oct 2007 @@MsdnLink@@ search_string
; 18 Aug 2013 special case for GdiPlus function
;------------------------------------------------------------------------------
Func makeMsdnLink($iIndex)
	Local $vName = StringSplit($g_aArrayInput[$iIndex], " ")
	$vName = $vName[$vName[0]]
	If StringLeft($vName, 4) = "GDIP" Then Return 'Search <a href="http://search.msdn.microsoft.com/search/Default.aspx?brand=msdn&query=' & _
			$vName & '">' & _
			$vName & '</a> in MSDN  Library' & @CRLF
	Return 'Search <a href="http://msdn.microsoft.com/query/dev10.query?appId=Dev10IDEF1&l=EN-US&k=k(' & _
			$vName & ');k(DevLang-C);k(TargetOS-WINDOWS)&rd=true">' & _
			$vName & '</a> in MSDN  Library' & @CRLF
EndFunc   ;==>makeMsdnLink

;------------------------------------------------------------------------------
; Formats a code example (converts tabs and linefeeds to html)
; 31 Jan version also converts groups of 2 or more spaces to &nbsp;...
; 20 Sep version also converts < to &lt and > to &gt
; 14 Jan 2005 added the Button logic and commented the < > because we use HTML Color files now
; 18 Sep 2005 separation of install dir lib examples from autoit examples
; 17 Jan 2013 Added ability to use multiple examples of the form <filename>[n].au3
;------------------------------------------------------------------------------
Func makeExample(ByRef $i, $fromInclude = 0)
	Local $nbspified
	Local $tmp = ""
	Local $uboundinput = UBound($g_aArrayInput)
	While $i < $uboundinput
		If Not $fromInclude Then
			If StringInStr($g_aArrayInput[$i], "###Special###") Then ExitLoop
			If StringInStr($g_aArrayInput[$i], "@@IncludeExample@@") Then
				$i = -1
				ExitLoop
			EndIf
		EndIf
		$nbspified = StringReplace($g_aArrayInput[$i], "  ", "&nbsp;&nbsp;")
		;$nbspified = StringReplace($nbspified, "<", "&lt;")
		;$nbspified = StringReplace($nbspified, ">", "&gt;")
		$tmp = $tmp & _
				StringReplace($nbspified, @TAB, '&nbsp;&nbsp;&nbsp; ') & @CRLF
		$i = $i + 1
	WEnd

	If $i = -1 Then Return includeExample($i)

	$tmp = StringTrimRight($tmp, 0 + StringLen(@CRLF)) ;remove very last <br /> @CRLF stuff
	If StringStripWS($tmp, $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" And Not $fromInclude Then makeExample_AddButtons($tmp, "", 0)
	Return $tmp
EndFunc   ;==>makeExample

Func makeExample_AddButtons(ByRef $example, $exampleName, $n)
	Local $sPath = StringTrimLeft($exampleName, StringInStr($exampleName, '\', 0, -1))
	Local $sOpenButton = '<script type="text/javascript">' & @CRLF & _
			'if (document.URL.match(/^mk:@MSITStore:/i))' & @CRLF & _
			'{' & @CRLF & _
			'document.write(''<div class="codeSnippetContainerTab codeSnippetContainerTabSingle" dir="ltr">'');' & @CRLF & _
			'document.write(''<object id=hhctrl type="application/x-oleobject" classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11"><param name="Command" value="ShortCut"><param name="Font" value="Verdana,10pt"><param name="Text" value="Text:Open this Script"><param name="Item1" value=",Examples\\HelpFile\\' & _
			$sPath & ',"></object>'');' & @CRLF & _
			'document.write(''</div>'');' & @CRLF & _
			'}' & @CRLF & _
			'</script>' & @CRLF
	If $ReGen_AutoItX Or $exampleName = "" Then $sOpenButton = "" ; no open button as the example .vbs are not part of installer files

	$example = '<div class="codeSnippetContainer">' & @CRLF & _
			'    <div class="codeSnippetContainerTabs">' & @CRLF & _
			$sOpenButton & _
			'    </div>' & @CRLF & _
			'    <div class="codeSnippetContainerCodeContainer">' & @CRLF & _
			'        <div class="codeSnippetToolBar">' & @CRLF & _
			'            <div class="codeSnippetToolBarText">' & @CRLF & _
			'<script type="text/javascript">' & @CRLF & _
			'if ((navigator.appName=="Microsoft Internet Explorer") && (parseInt(navigator.appVersion)>=4)) // IE (4+) only' & @CRLF & _
			'    document.write(''<a href="#" id="copy" onclick="copyToClipboard(document.getElementById(\''copytext' & $n & '\'').innerText)">Copy to clipboard</a>'');' & @CRLF & _
			'</script>' & @CRLF & _
			'            </div>' & @CRLF & _
			'        </div>' & @CRLF & _
			'        <div id="copytext' & $n & '" class="codeSnippetContainerCode" dir="ltr">' & @CRLF & _
			'<div style="color:Black;"><pre>' & @CRLF & _
			$example & _
			'</pre></div>' & @CRLF & _
			'		</div>' & @CRLF & _
			'	</div>' & @CRLF & _
			'</div>' & @CRLF
EndFunc   ;==>makeExample_AddButtons

;------------------------------------------------------------------------------
; include file as an example
; 14 Jan 2005 added the Au3 to htm conversion to Color the examples
; 06 Apr 2005 suppress mixing source Au3 examples and Colored HTM conversions files
; 18 Sep 2005 separation of input lib examples
; 17 Jan 2013 Added ability to use multiple examples of the form <filename>[n].au3
;------------------------------------------------------------------------------
Func includeExample(ByRef $i)
	Local $tFilename = StringReplace($EXAMPLE_DIR & $g_sFilePath, ".txt", "")

	If FileExists($tFilename & "[2]" & $EXAMPLE_EXT) Then
		; Multiple files exist
		Local $hFind = FileFindFirstFile($tFilename & "[*]" & $EXAMPLE_EXT)

		Local $aFiles[1] = [StringReplace($g_sFilePath, ".txt", $EXAMPLE_EXT)], $count = 0, $sFile
		While 1
			$sFile = FileFindNextFile($hFind)
			If @error Then ExitLoop

			$count += 1
			ReDim $aFiles[$count + 1]
			$aFiles[$count] = $sFile
		WEnd

		FileClose($hFind)

		Local $aRet[$count + 1][2], $n

		For $ex = 1 To $count + 1
			; Forces examples to be in order.
			If $ex = 1 Then
				$n = 0
			Else
				For $n = 1 To $count
					If StringRight($aFiles[$n], StringLen("[" & $ex & "]" & $EXAMPLE_EXT)) = "[" & $ex & "]" & $EXAMPLE_EXT Then ExitLoop
				Next
			EndIf

			$aRet[$ex - 1][0] = FileReadLine($EXAMPLE_DIR & $aFiles[$n], 1)
			$aRet[$ex - 1][1] = makeExample_ReadFile($i, $EXAMPLE_DIR & $aFiles[$n])

			; Check if a custom title is used.
			If StringLeft($aRet[$ex - 1][0], 5) = "; == " Then
				$aRet[$ex - 1][1] = StringReplace($aRet[$ex - 1][1], $aRet[$ex - 1][0], "")
				$aRet[$ex - 1][1] = StringRegExpReplace($aRet[$ex - 1][1], "\<span\s+class\=""[^""]*""\s*\>\</span\>\r\n", "")
				$aRet[$ex - 1][1] = StringReplace($aRet[$ex - 1][1], "<br />", "", 1)

				$aRet[$ex - 1][0] = StringStripWS(StringTrimLeft(StringStripWS($aRet[$ex - 1][0], $STR_STRIPLEADING + $STR_STRIPTRAILING), 4), $STR_STRIPLEADING + $STR_STRIPTRAILING)
			Else
				$aRet[$ex - 1][0] = "Example " & $ex
			EndIf

			makeExample_AddButtons($aRet[$ex - 1][1], $aFiles[$n], $n)
		Next

		Return $aRet
	Else
		$tFilename = $tFilename & $EXAMPLE_EXT

		Local $sRet = makeExample_ReadFile($i, $tFilename)
		makeExample_AddButtons($sRet, $tFilename, 0)
		Return $sRet
	EndIf
EndFunc   ;==>includeExample

;------------------------------------------------------------------------------
; Reads an example from a file, and formats it.
;------------------------------------------------------------------------------
Func makeExample_ReadFile(ByRef $i, $tFilename)
	; This program sends the commands to SciTE Director interface to Open the file, save as html and close.
	If FileExists($tFilename) Then makeExampleHTML($tFilename)

	If Not _FileReadToArrayEx($tFilename, $g_aArrayInput) Then
		_OutputBuildWrite("** Warning in:" & $g_sFilePath & " ==> Include Example file was not found; skipping it:" & StringReplace($g_sFilePath, ".txt", $EXAMPLE_EXT) & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", "** Warning in:" & $g_sFilePath & " ==> Include Example file was not found; skipping it:" & StringReplace($g_sFilePath, ".txt", $EXAMPLE_EXT))
		Return ""
	Else
		$i = 1
		Return makeExample($i, 1)
	EndIf
EndFunc   ;==>makeExample_ReadFile

;------------------------------------------------------------------------------
; Uses SciTE to convert an Au3 file to html
;------------------------------------------------------------------------------
Func makeExampleHTML(ByRef $sSource) ; Fixed by guinness - 27/08/2013
	Local $sDestination = @WorkingDir & "\" & $EXAMPLE_DIRO & $g_sFilePath & ".htm"
	If Not $ReGen_AutoItX Then
		_SciTE_ExportToHTML($sSource, $sDestination)
	Else
		FileCopy($sSource, $sDestination, $FC_OVERWRITE)
	EndIf
	If FileExists($sDestination) Then
		$sSource = $sDestination
		; Read the generated file and strip the header and footer and replace some stuff to make it look better
		Local $sOutput = "", $sFileRead = FileRead($sSource)
		If _SciTE_ParseHTML($sFileRead) Then
			$sOutput = $sFileRead
			; Add Links to known keywords
			_AutoIt3_Helpfile_Link($sOutput)
		Else
			$sOutput = $sFileRead
		EndIf
		FileDelete($sSource)
		FileWrite($sSource, $sOutput)
	EndIf
EndFunc   ;==>makeExampleHTML

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
;------------------------------------------------------------------------------
Func makeStandardTable(ByRef $iIndex)
	; Assumes one line per row with tab-separated columns
	$iIndex += 1

	Local $aTabSplit = 0, $sTable = @CRLF ;will contain final html table code

	While Not StringInStr($g_aArrayInput[$iIndex], "@@End@@")
		; StringSplit each row into an array for easy parsing.
		$aTabSplit = StringSplit($g_aArrayInput[$iIndex], @TAB)
		If @error Then
			$iIndex += 1
			ContinueLoop
		EndIf

		$sTable &= '  <tr>' & @CRLF
		For $i = 1 To $aTabSplit[0]
			$sTable &= '    <td>' & $aTabSplit[$i] & '</td>' & @CRLF
		Next
		$sTable &= '  </tr>' & @CRLF

		$iIndex += 1
	WEnd

	Return '<table>' & $sTable & '</table>'
EndFunc   ;==>makeStandardTable

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
; 28 Feb version change table look to have a separating line after first row only
;------------------------------------------------------------------------------
Func makeStandardTable1(ByRef $iIndex)
	;Assumes one line per row with tab-separated columns
	$iIndex = $iIndex + 1

	Local $x, $tbl = @CRLF ;will contain final html table code
	; to generate a separation line after the first row
	Local $tr = '  <tr>'
	Local $td = "th"
	While Not StringInStr($g_aArrayInput[$iIndex], "@@End@@")
		;StringSplit each row into an array for easy parsing
		$x = StringSplit($g_aArrayInput[$iIndex], @TAB)
		If @error Then
			$iIndex = $iIndex + 1
			ContinueLoop
		EndIf

		$tbl = $tbl & $tr & @CRLF
		For $i = 1 To $x[0]
			$tbl = $tbl & '    <' & $td & '>' & $x[$i] & '</' & $td & '>' & @CRLF
		Next
		$tbl = $tbl & '  </tr>' & @CRLF
		;reset separation line for next lines
		$tr = '  <tr>'
		$td = 'td'
		$iIndex = $iIndex + 1
	WEnd

	Return '<br /><table>' & $tbl & '</table>'
EndFunc   ;==>makeStandardTable1

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 10% width and Column 2 has 90% width
;------------------------------------------------------------------------------
Func makeReturnTable(ByRef $iIndex)
	;Assumes one line per row with tab-separated columns
	$iIndex = $iIndex + 1

	Local $tbl = @CRLF & '  <tr>' & @CRLF ;will contain final html table code
	Local $x = StringSplit($g_aArrayInput[$iIndex], @TAB)
	If Not StringInStr($x[1], ':') Then $x[1] &= ':'
	$tbl &= '    <td style="width:10%" class="valign-top">' & $x[1] & '</td>' & @CRLF
	$tbl &= '    <td style="width:90%">' & $x[2]
	$iIndex += 1

	While Not StringInStr($g_aArrayInput[$iIndex], "@@End@@")
		;StringSplit each row into an array for easy parsing
		$x = StringSplit($g_aArrayInput[$iIndex], @TAB)
		If @error Then
			$iIndex += 1
			ContinueLoop
		EndIf

		If $x[1] = "" Then
			$tbl &= '<br />' & @CRLF & "       " & spaceToNBSP(StringTrimLeft($g_aArrayInput[$iIndex], 1))
		Else
			$tbl &= '</td>' & @CRLF & '  </tr>' & @CRLF & '  <tr>' & @CRLF
			If Not StringInStr($x[1], ':') Then $x[1] &= ':' ; force : if missing
			$tbl &= '    <td class="valign-top">' & $x[1] & '</td>' & @CRLF
			$tbl &= '    <td>' & $x[2]
		EndIf
		$iIndex += 1
	WEnd

	Return '<table class="noborder">' & $tbl & '</td>' & @CRLF & '  </tr>' & @CRLF & '</table>'
EndFunc   ;==>makeReturnTable

;------------------------------------------------------------------------------
; Convert special tab delimited text to a two-colum table.
;    Each non-indented line indicates a new row.
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 15% width and Column 2 has 85% width
;------------------------------------------------------------------------------
Func makeParamTable(ByRef $iIndex)
	;make a pass to determine how many rows and columns the table has
	Local $indention, $rows = 0
	Local $i = $iIndex + 1
	While Not StringInStr($g_aArrayInput[$i], "@@End@@")
		$indention = stringCount($g_aArrayInput[$i], @TAB)
		If $indention = 0 Then $rows = $rows + 1
		$i = $i + 1
	WEnd
	Local $start = $iIndex + 1
	Local $stop = $i - 1

	$iIndex = $stop + 1 ;note that $iIndex was ByRef'ed

	Local $matrix[$rows][2]

	Local $data = ""
	Local $r = -1
	Local $c = 0
	For $i = $start To $stop
		$indention = stringCount($g_aArrayInput[$i], @TAB)

		If $indention = 0 Then
			$r = $r + 1
			$c = 0
		Else
			$c = 1
			$indention = 1
		EndIf

		$data = spaceToNBSP(StringTrimLeft($g_aArrayInput[$i], $indention))

		; Ensure [optional] is bold.
		If StringInStr($g_aArrayInput[$i], "[optional]") Then $data = StringReplace($g_aArrayInput[$i], "[optional]", "<strong>[optional]</strong>")

		If $matrix[$r][$c] <> "" Then
			$matrix[$r][$c] = $matrix[$r][$c] & '<br />' & $data
		Else
			$matrix[$r][$c] = $data
		EndIf
	Next

	Local $tbl = '<table>' & @CRLF

	For $r = 0 To $rows - 1

		$tbl = $tbl & '  <tr>' & @CRLF

		For $c = 0 To 1
			$data = StringReplace($matrix[$r][$c], "<br />", "<br />" & @CRLF & "       ")
			Select
				Case $r = 0 And $c = 0 ;only put width%-info on first row
					$tbl = $tbl & '    <td style="width:15%">' & $data & '</td>' & @CRLF
				Case $r = 0 And $c = 1
					$tbl = $tbl & '    <td style="width:85%">' & $data & '</td>' & @CRLF
				Case Else
					$tbl = $tbl & '   <td>' & $data & '</td>' & @CRLF
			EndSelect
		Next
		$tbl = $tbl & '  </tr>' & @CRLF
	Next

	Return $tbl & '</table>'
EndFunc   ;==>makeParamTable

;------------------------------------------------------------------------------
; Convert special tab delimited text to a two-colum table.
;    Each non-indented line indicates a new row.
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 40% width and Column 2 has 60% width
;------------------------------------------------------------------------------
Func makeControlCommandTable(ByRef $iIndex)
	;make a pass to determine how many rows and columns the table has
	Local $indention, $rows = 0
	Local $i = $iIndex + 1
	While Not StringInStr($g_aArrayInput[$i], "@@End@@")
		$indention = stringCount($g_aArrayInput[$i], @TAB)
		If $indention = 0 Then $rows = $rows + 1
		$i = $i + 1
	WEnd
	Local $start = $iIndex + 1
	Local $stop = $i - 1

	$iIndex = $stop + 1 ;note that $iIndex was ByRef'ed

	Local $matrix[$rows][2]

	Local $data = ""
	Local $r = -1
	Local $c = 0
	For $i = $start To $stop
		$indention = stringCount($g_aArrayInput[$i], @TAB)
		$data = spaceToNBSP(StringTrimLeft($g_aArrayInput[$i], $indention))
		If $indention = 0 Then
			$r = $r + 1
			$c = 0
		Else
			$c = 1
		EndIf
		If $matrix[$r][$c] <> "" Then
			$matrix[$r][$c] = $matrix[$r][$c] & '<br />' & $data
		Else
			$matrix[$r][$c] = $data
		EndIf
	Next

	Local $tbl = '<table>' & @CRLF

	For $r = 0 To $rows - 1

		$tbl = $tbl & '  <tr>' & @CRLF

		For $c = 0 To 1
			$data = StringReplace($matrix[$r][$c], "<br />", "<br />" & @CRLF & "       ")
			Select
				Case $r = 0 And $c = 0 ;only put width%-info on first row
					$tbl = $tbl & '    <td style="width:40%">' & $data & '</td>' & @CRLF
				Case $r = 0 And $c = 1
					$tbl = $tbl & '    <td style="width:60%">' & $data & '</td>' & @CRLF
				Case Else
					$tbl = $tbl & '   <td>' & $data & '</td>' & @CRLF
			EndSelect
		Next
		$tbl = $tbl & '  </tr>' & @CRLF
	Next

	Return $tbl & '</table>'
EndFunc   ;==>makeControlCommandTable

; --------------------------------------------------------------------
; Count the occcurrences of a single character in a string
; --------------------------------------------------------------------
Func stringCount($sString, $sChar) ; Fixed by guinness - 27/08/2013
	Local $aArray = StringSplit($sString, $sChar)
	If @error Then Return 0
	Return $aArray[0] - 1
EndFunc   ;==>stringCount

; --------------------------------------------------------------------
; Convert all but one leading space to the &nbsp; html code
; --------------------------------------------------------------------
Func spaceToNBSP($sString)
	For $i = 1 To StringLen($sString)
		If StringMid($sString, $i, 1) <> " " Then ExitLoop
	Next
	If $i - 1 > 0 Then $sString = StringReplace($sString, " ", "&nbsp;", $i - 1)

	;Also convert each leading tab to 4 spaces ("&nbsp;&nbsp;&nbsp; ")
	For $i = 1 To StringLen($sString)
		If StringMid($sString, $i, 1) <> @TAB Then ExitLoop
	Next
	If $i - 1 > 0 Then
		$sString = StringReplace($sString, @TAB, "&nbsp;&nbsp;&nbsp; ", $i - 1)
	EndIf

	Return $sString
EndFunc   ;==>spaceToNBSP

;------------------------------------------------------------------------------
; Run DOS/console commands
;------------------------------------------------------------------------------
Func _RunCmd($command)
	FileWriteLine("brun.bat", $command & " > " & $TEMP_LIST)
	RunWait(@ComSpec & " /c brun.bat", "", @SW_HIDE)
	FileDelete("brun.bat")
	Return
EndFunc   ;==>_RunCmd

;------------------------------------------------------------------------------
; Check if the input is newer than the output
;------------------------------------------------------------------------------
Func IsGreaterFileTime($sSource, $sDestination)
	If Not $ReGen_All Then
		Local $sSourceTime = FileGetTime($sSource, $FT_MODIFIED, 1)
		If @error Then
			Return 1 ; Skip generation of this file when its not there
		Else
			Local $sDestinationTime = FileGetTime($sDestination, $FT_MODIFIED, 1)
			If @error Then Return 0
			If $sSourceTime < $sDestinationTime Then Return 1 ; To skip generation for this file
		EndIf
	EndIf
	Return 0
EndFunc   ;==>IsGreaterFileTime

;------------------------------------------------------------------------------
; Add link to keywords, Functions and UDFs
;------------------------------------------------------------------------------
Func _AutoIt3_Helpfile_Link(ByRef $sExampleData)
	; UDF
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S15">([\w]+?)</span>', '<a class="codeSnippetLink" href="../libfunctions/\1.htm"><span class="S15">\1</span></a>')
	; LIBFUNC-structure of $tag ... in the examples
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S9">(\$tag\w+?)</span>', '<a class="codeSnippetLink" href="\1.htm"><span class="S9">\1</span></a>')
	; Functions
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S4">([\w]+?)</span>', '<a class="codeSnippetLink" href="../functions/\1.htm"><span class="S4">\1</span></a>')
	$sExampleData = StringReplace($sExampleData, 'href="../functions/Opt.htm">', 'href="../functions/AutoItSetOption.htm">')
	; Exception for UDPStartup(), UDPShutdown()
	$sExampleData = StringReplace($sExampleData, '<a class="codeSnippetLink" href="UDPStartup.htm"><span class="S4">UDPStartup</span></a>', '<a class="codeSnippetLink" href="TCPStartup.htm"><span class="S4">UDPStartup</span></a>')
	$sExampleData = StringReplace($sExampleData, '<a class="codeSnippetLink" href="UDPShutdown.htm"><span class="S4">UDPShutdown</span></a>', '<a class="codeSnippetLink" href="TCPShutdown.htm"><span class="S4">UDPShutdown</span></a>')
	; Macros
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S6">(@[^<]+)</span>', '<a class="codeSnippetLink" href="../macros.htm#\1"><span class="S6">\1</span></a>')
	; Operators
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S8">((?:[+^*/=&-]|&gt;|&lt;)+)</span>', '<a class="codeSnippetLink" href="../intro/lang_operators.htm"><span class="S8">\1</span></a>')
	; Keywords
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(Not|And|Or)</span>', '<a class="codeSnippetLink" href="../intro/lang_operators.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(ContinueCase|ContinueLoop|Default|Dim|Do|Enum|Exit|ExitLoop|For|Func|If|ReDim|Select|Static|Switch|While|With)</span>', '<a class="codeSnippetLink" href="../keywords/\1.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(Else|Then|ElseIf|EndIf)</span>', '<a class="codeSnippetLink" href="../keywords/IfElseEndIf.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(Next|To|Step)</span>', '<a class="codeSnippetLink" href="../keywords/For.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(Case|EndSwitch)</span>', '<a class="codeSnippetLink" href="../keywords/Switch.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(Global|Local|Const)</span>', '<a class="codeSnippetLink" href="../keywords/Dim.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(EndFunc|ByRef|Return)</span>', '<a class="codeSnippetLink" href="../keywords/Func.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S5">(True|False)</span>', '<a class="codeSnippetLink" href="../keywords/Booleans.htm"><span class="S5">\1</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S5">Until</span>', '<a class="codeSnippetLink" href="../keywords/Do.htm"><span class="S5">Until</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S5">WEnd</span>', '<a class="codeSnippetLink" href="../keywords/While.htm"><span class="S5">WEnd</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S5">EndSelect</span>', '<a class="codeSnippetLink" href="../keywords/Select.htm"><span class="S5">EndSelect</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S5">In</span>', '<a class="codeSnippetLink" href="../keywords/ForInNext.htm"><span class="S5">In</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S5">EndWith</span>', '<a class="codeSnippetLink" href="../keywords/With.htm"><span class="S5">EndWith</span></a>')
	; Directives
	$sExampleData = StringReplace($sExampleData, '<span class="S11">#OnAutoItStartRegister</span>', '<a class="codeSnippetLink" href="../keywords/OnAutoItStartRegister.htm"><span class="S11">#OnAutoItStartRegister</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S11">#include</span>', '<a class="codeSnippetLink" href="../keywords/include.htm"><span class="S11">#include</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S11">#include-once</span>', '<a class="codeSnippetLink" href="../keywords/include-once.htm"><span class="S11">#include-once</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S11">#RequireAdmin</span>', '<a class="codeSnippetLink" href="../keywords/RequireAdmin.htm"><span class="S11">#RequireAdmin</span></a>')
	$sExampleData = StringReplace($sExampleData, '<span class="S11">#NoTrayIcon</span>', '<a class="codeSnippetLink" href="../keywords/NoTrayIcon.htm"><span class="S11">#NoTrayIcon</span></a>')
EndFunc   ;==>_AutoIt3_Helpfile_Link

;------------------------------------------------------------------------------
; Based on Jon's post http://www.autoitscript.com/forum/index.php?showtopic=530
;------------------------------------------------------------------------------
Func _FileReadToArrayEx($sFilePath, ByRef $aArray)
	Local $hFileOpen = FileOpen($sFilePath)
	If $hFileOpen = -1 Then Return 0 ; Failure

	Local $sText = ""
	While 1
		$sText &= FileReadLine($hFileOpen) & @LF
		If @error Then ExitLoop
	WEnd

	FileClose($hFileOpen)

	$sText = StringTrimRight($sText, StringLen(@LF)) ; Remove final @LF.
	$aArray = StringSplit($sText, @LF)

	Return 1 ; Success
EndFunc   ;==>_FileReadToArrayEx

Func _GetFileName($sFilePath)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	_PathSplit($sFilePath, $sDrive, $sDir, $sFileName, $sExtension)
	Return $sFileName
EndFunc   ;==>_GetFileName

Func TestingOnly()
	Local $sFilePath = FileOpenDialog("Choose an AutoIt text file to convert", @ScriptDir & "\..\..\autoit\english\txt2htm", "AutoIt Text File (*.txt)")
	If @error Then Return False

	$ReGen_All = False
	$ReGen_AutoIt = True
	$ReGen_UDFs = False
	$ReGen_AutoItX = False

	$RefType_Main = "Function"
	$EXAMPLE_EXT = ".au3"
	$CROSS_DIR = ""
	$CROSSLINK = ""

	Local $sDrive = "", $sFolder = "", $sFileName = "", $sExtension = ""
	_PathSplit($sFilePath, $sDrive, $sFolder, $sFileName, $sExtension)
	$sFolder = StringRegExpReplace($sDrive & $sFolder, "[\\/]+$", "") & "\"

	$INPUT_DIR = $sFolder
	$OUTPUT_DIR = $sFolder

	$EXAMPLE_DIR = _PathFull($sFolder & "..\examples\")
	ConvertTextToHTML($sFilePath)
EndFunc   ;==>TestingOnly
