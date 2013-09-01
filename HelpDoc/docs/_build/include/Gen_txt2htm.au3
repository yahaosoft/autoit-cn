;  AutoIt:  3.0.91 with "smart boolean comparison" and FileChangeDir
;Platform:  Tested on "American" Windows XP sp1
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
;           - Conversion of AU3 examples to Colored HTM versions by using SciTE.
;   Fixed:  06 Apr 2005 jpm
;           - suppress mixing source AU3 examples and Colored HTM conversions files
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
;           - @LF to $NL to be able to generate ANSI/PC files
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
#include "OutputLib.au3"
#include <Constants.au3>
#include <SendMessage.au3>

Opt("TrayIconDebug", 1)
Opt("WinTitleMatchMode", 2)

OnAutoItExitRegister("OnQuit") ;### Debug Console
_OutputWindowCreate() ;### Debug Console

Const $NL = @CRLF ; can be change to @LF to have UNIX style instead of PC

Global $ReGen_All = StringInStr($CmdLineRaw, "/RegenAll")

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
Global $CROSS_DIR
Global $CROSSLINK
Global $INPUT_DIR
Global $OUTPUT_DIR
Global $TEMP_LIST = "fileList.tmp"
Global $Example_DIR
Global $Example_EXT

Global $Input ;array containing each line of the txt-file to convert
Global $hOut ;file handle to the output file (overwrite mode)
Global $Filename ;name of file being converted
Global $path ;name of file being converted

Global $My_Hwnd
Global $SciTE_hwnd, $SciTEPgm, $Au3KeywordsProperties
If Not $ReGen_AutoItX Then SciTEOpen()

; clear log
FileDelete(@WorkingDir & "\txt2htm_error.log")

;
_OutputBuildWrite("txt2htm Conversion" & @CRLF)

Global $Example_DIRO = IniRead($TXT2HTM_INI, "Output", "Examples", "ERR")
DirCreate($Example_DIRO)

Global $Reftype_main
If $ReGen_AutoIt Then
	$Reftype_main = "Function"
	$Example_EXT = ".au3"
	; rebuild all changed TXT files.
	$CROSS_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	$CROSSLINK = IniRead($TXT2HTM_INI, "CrossLink", "AutoIt", "ERR")
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$Example_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "Examples", "ERR")
	_OutputBuildWrite("Scanning Functions..." & @CRLF)
	Rebuild()
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "keywords", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "keywords", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	_OutputBuildWrite("Scanning Keywords..." & @CRLF)
	Rebuild()
EndIf

If $ReGen_UDFs Then
	$Reftype_main = "Function"
	$Example_EXT = ".au3"
	$CROSS_DIR = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
	$CROSSLINK = IniRead($TXT2HTM_INI, "CrossLink", "UDFs", "ERR")
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$Example_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "LibExamples", "ERR")
	_OutputBuildWrite("Scanning UDF's..." & @CRLF)
	Rebuild()
EndIf

If $ReGen_AutoItX Then
	$Reftype_main = "Method"
	$Example_EXT = ".vbs"
	$INPUT_DIR = IniRead($TXT2HTM_INI, "Input", "methods", "ERR")
	$OUTPUT_DIR = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
	If Not FileExists($OUTPUT_DIR) Then DirCreate($OUTPUT_DIR)
	$Example_DIR = @WorkingDir & "\" & IniRead($TXT2HTM_INI, "Input", "Examples", "ERR")
	_OutputBuildWrite("Scanning Methods..." & @CRLF)
	Rebuild()
EndIf

Exit

Func OnQuit()
	_OutputWaitClosed() ;### Debug Console
EndFunc   ;==>OnQuit

Func SciTEClose()
	; Close SciTE since we started it.
	SendSciTE_Command(0, $SciTE_hwnd, "quit:")
EndFunc   ;==>SciTEClose

Func SciTEOpen()
	$SciTEPgm = "..\..\..\install\SciTe\SciTE.exe"
	; Use the generated version of SciTE4AutoIt3 when it exists.
	If Not FileExists($SciTEPgm) Then $SciTEPgm = RegRead("HKLM\Software\Microsoft\Windows\Currentversion\App Paths\Scite.Exe", "")

	$Au3KeywordsProperties = "..\..\..\install\SciTe\au3.keywords.properties"
	; Use the generated version of au3.keywords.properties when it exists.
	If Not FileExists($Au3KeywordsProperties) Then
		FileCopy(@ProgramFilesDir & "\AutoIt3\SciTE\au3.keywords.properties", $Au3KeywordsProperties, 8 + 1)
		FileCopy(@ProgramFilesDir & "\AutoIt3\SciTE\Properties\au3.keywords.properties", $Au3KeywordsProperties, 8 + 1)
	EndIf

	; Get SciTE Director interface Window Handle
	Opt("WinSearchChildren", 1)
	Opt("WinTitleMatchMode", 4)
	; get SciTE handle and when not found start SciTE

	; Look for a running instance of SciTE.  If it is found the ask the user to
	; close it.  We do not want to use an existing session because it may
	; have SciTE_HOME set.  If that environment variable is set then SciTE
	; will load the user's properties files which can cause problems with
	; syntax highlighting.
	Do
		$SciTE_hwnd = WinGetHandle("DirectorExtension")
		If $SciTE_hwnd Then MsgBox(4112, "Error", "SciTE is running, please close all instances of SciTE and press OK to continue.")
	Until Not $SciTE_hwnd

	; When not found prompt for the SciTE.exe
	If $SciTEPgm = "" Or Not FileExists($SciTEPgm) Then FileOpenDialog("Couldn't find SciTE.exe... please select it.", @WorkingDir, "SciTE (SciTE.exe)", 1)
	If FileExists($SciTEPgm) Then
		; Set the SciTE_HOME environment variable to override the user's.
		; This prevents the user's property files from getting loaded and
		; causing issues.
		EnvSet("SciTE_HOME", @TempDir)
		Run($SciTEPgm)
		WinWait("Classname=SciTEWindow")
	Else
		Exit MsgBox(4112, "Error", "Unable to find SciTE, aborting.") ; Exit the build scripts.
	EndIf
	; Ensure the handle is know also when SciTE got started in this script.
	$SciTE_hwnd = WinGetHandle("DirectorExtension")
	;
	; Copy the latest SciTE  properties files to your own SciTE installation
	LoadSciTE_Properties()
	; Jos: Reload SciTE properties without closing SciTE first.
	SendSciTE_Command($My_Hwnd, $SciTE_hwnd, "reloadproperties:")

	WinSetState("Classname=SciTEWindow", "", @SW_MINIMIZE)

	OnAutoItExitRegister("SciTEClose")
EndFunc   ;==>SciTEOpen

Func Rebuild()
	;pipe the list of sorted file names to fileList.tmp:
	_RunCmd("dir " & $INPUT_DIR & "*.txt /b | SORT > " & $TEMP_LIST)
	Local $hFileList
	$hFileList = FileOpen($TEMP_LIST, 0) ;read mode
	If $hFileList = -1 Then
		MsgBox($MB_SYSTEMMODAL, "Error", $TEMP_LIST & " could not be opened and/or found.")
		Exit
	EndIf

	While 1 ;loop thru each filename contained in fileList.tmp
		$Filename = FileReadLine($hFileList)
		If @error = -1 Then ExitLoop ;EOF reached
		$path = $INPUT_DIR & $Filename
		If $Filename = "CVS" Then ContinueLoop ; Skip CVS
		If $Filename = "Changelog.txt" Then ContinueLoop ; Skip ChangeLog.txt
		If StringStripWS($path, 3) = "" Then ExitLoop

		If Not FileExists($path) Then
			_OutputBuildWrite($path & " WAS not found; skipping it." & @CRLF)
			FileWriteLine(@WorkingDir & "\txt2htm_error.log", $path & " WAS not found; skipping it.")
			ContinueLoop
		EndIf
		If Not FileToArray($path, $Input) Then
			_OutputBuildWrite($path & " was not found; skipping it." & @CRLF)
			FileWriteLine(@WorkingDir & "\txt2htm_error.log", $path & " was not found; skipping it.")
			ContinueLoop
		EndIf

		; Don't rebuild if the target files are up-todate
		If $ReGen_All = 0 Then
			Local $bRebuild = 0, $tFilename = StringTrimRight($Filename, 4), $sHtmfile = $OUTPUT_DIR & $tFilename & ".htm"
			If FileExists($Example_DIR & $tFilename & "[2]" & $Example_EXT) Then
				; Multiple files exist
				Local $sFile, $hFind = FileFindFirstFile($Example_DIR & $tFilename & "[*]" & $Example_EXT)
				While 1
					$sFile = FileFindNextFile($hFind)
					If @error Then ExitLoop

					If isGreaterFileTime($Example_DIR & $sFile, $sHtmfile) = 0 Then $bRebuild = 1
				WEnd

				FileClose($hFind)
			EndIf

			If $bRebuild = 0 And isGreaterFileTime($INPUT_DIR & $Filename, $sHtmfile) Then
				If FileExists($Example_DIR & $tFilename & $Example_EXT) Then
					If isGreaterFileTime($Example_DIR & $tFilename & $Example_EXT, $sHtmfile) Then ContinueLoop
				Else
					ContinueLoop
				EndIf
			EndIf
		EndIf

		$hOut = FileOpen($sHtmfile, 2)

		Convert()
		FileClose($hOut)
	WEnd
	FileClose($hFileList)
EndFunc   ;==>Rebuild

;------------------------------------------------------------------------------
; The main conversion function
;------------------------------------------------------------------------------
Func Convert()

	Local $RefType = StringStripWS(get(""), 3)

	If $RefType <> "###" & $Reftype_main & "###" And $RefType <> "###Keyword###" And $RefType <> "###User Defined Function###" And $RefType <> "###Structure Name###" And $RefType <> "###Operator###" And $RefType <> "###Macro###" Then
		_OutputBuildWrite($path & " has invalid first line; skipping file." & @CRLF)
		_OutputBuildWrite('x' & $RefType & 'x' & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", $path & " has invalid first line; skipping file.")
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", 'x' & $RefType & 'x')
		Return "Error"
	Else
		_OutputBuildWrite($path & @CRLF)
	EndIf

	Local $Name = StringReplace(get($RefType), '<br>', '') ;name of the function or keyword

	put('<!DOCTYPE html>')
	put('<html>')
	put('<head>')
	If StringInStr($RefType, $Reftype_main) > 0 Then
		put('  <title>' & $Reftype_main & ' ' & $Name & '</title>')
	ElseIf StringInStr($RefType, "Operator") Then
		put('  <title>Operator ' & $Name & '</title>')
	Else
		put('  <title>Keyword ' & $Name & '</title>')
	EndIf
	put('  <meta charset="ISO-8859-1">')
	If $ReGen_AutoItX Then
		put('  <link href="../../css/default.css" rel="stylesheet" type="text/css">')
	Else
		put('  <link href="../css/default.css" rel="stylesheet" type="text/css">')
	EndIf
	put('</head>')
	put('')
	put('<body>')

	; Insert the experimental section if required.
	If get("###Experimental###") Then
		put('<div class="experimental">Warning: This feature is experimental.  It may not work, may contain bugs or may be changed or removed without notice.<br><br>DO NOT REPORT BUGS OR REQUEST NEW FEATURES FOR THIS FEATURE.</div><br/>')
	EndIf

	If StringInStr($RefType, $Reftype_main) > 0 Then
		put('<h1 class="small">' & $Reftype_main & ' Reference</h1>')
	ElseIf StringInStr($RefType, "Operator") Then
		put('<h1 class="small">Operator Reference</h1>')
	Else
		put('<h1 class="small">Keyword Reference</h1>')
	EndIf
	put('<hr style="height:0px">')
	put('<h1>' & $Name & '</h1>')
	put('<p class="funcdesc">' & get("###Description###") & '</p>')
	put('')

	put('<p class="codeheader">')
	put(get("###Syntax###"))
	put('</p>')

	put('')
	put('<h2>Parameters</h2>')
	put('' & get("###Parameters###") & '')
	put('' & get("###Fields###") & '')
	put('')
	If StringInStr($RefType, $Reftype_main) > 0 Then
		put('<h2>Return Value</h2>')
		put('' & get("###ReturnValue###") & '')
		put('')
	EndIf
	put('<h2>Remarks</h2>')
	put('' & get("###Remarks###") & '')
	put('')
	Local $related = get("###Related###")
	If StringStripWS($related, 3) <> "" Then
		put('<h2>Related</h2>')
		put('' & $related & '')
		put('')
	EndIf
	; only add "See also" section if requested
	Local $seealso = get("###See Also###")
	If StringStripWS($seealso, 3) <> "" Then
		put('<h2>See Also</h2>')
		put('' & $seealso & '')
	EndIf
	; only add example box when example file is available
	Local $example = get("###Example###")
	If IsArray($example) Or StringStripWS($example, 3) <> "" Then
		put('')
		put('<h2 class="bottom">Example</h2>')
		put('<script type="text/javascript">')
		put('if ((navigator.appName=="Microsoft Internet Explorer") && (parseInt(navigator.appVersion)>=4)) // IE (4+) only')
		put('    function copyToClipboard(s){if (window.clipboardData && clipboardData.setData){clipboardData.setData("text", s + "\r\n");}}')
		put('</script>')

		If IsArray($example) Then
			; More than one example
			For $ex = 0 To UBound($example) - 1
				put('<h3>' & $example[$ex][0] & '</h3>')
				put($example[$ex][1])
				put('')
			Next
		ElseIf StringStripWS($example, 3) <> "" Then
			put($example)
			put('')
		EndIf
	EndIf

	;	If StringInStr($Name, "Random") Then  ;Random.htm has a special section
	;		put('' & get("###Special###") & '')
	;		put('')
	;	EndIf
	put('</body>')
	put('</html>')

EndFunc   ;==>Convert

;------------------------------------------------------------------------------
; Write a new line to the output file
;------------------------------------------------------------------------------
Func put($line)
	FileWrite($hOut, $line & $NL)
EndFunc   ;==>put

;------------------------------------------------------------------------------
; Retrieve text from $Input to put into html file
;------------------------------------------------------------------------------
Func get($sSection)
	If $sSection = "" Then Return $Input[1] ;very first line

	Local $sTempString, $iCount = 0
	Local $iUBoundInput = UBound($Input)
	While $iCount + 1 < $iUBoundInput
		$iCount = $iCount + 1
		If StringInStr($Input[$iCount], $sSection) Then ExitLoop
	WEnd
	If $iCount + 1 < $iUBoundInput Then $iCount = $iCount + 1 ;$iCount is now index of first line after the section heading

	Switch $sSection
		Case "###Experimental###"
			; This is an extremely ugly hack to work-around the surrounding
			; crappy code that makes lots of absurd assumptions about the format
			; of the file.  What this does is test if the ###Experimental###
			; section exists.  It returns a boolean to indicate if the section
			; is present.  It determines the section is present by looking
			; at the counter and testing if it is larger than the input size
			; implying that it wasn't found.
			Return $iCount + 1 < $iUBoundInput
		Case "###" & $Reftype_main & "###", "###Keyword###"
			Return $Input[$iCount]
		Case "###Related###"
			Return makeRelatedLinks($iCount)
		Case "###Example###"
			Return makeExample($iCount)
		Case "###Special###" ;Random.htm has a special section
			$sTempString = '<p>' & $NL
			For $k = $iCount To $iUBoundInput - 1
				$sTempString = $sTempString & $Input[$k] & '<br>' & $NL
			Next
			Return $sTempString & '</p>'
	EndSwitch

	$sTempString = ""
	While $iCount < $iUBoundInput - 1
		If StringInStr($Input[$iCount], "###") Then ExitLoop
		; makes sure not to go beyond own section
		If StringInStr($Input[$iCount], "@@ParamTable@@") Then
			$sTempString = $sTempString & makeParamTable($iCount)
		ElseIf StringInStr($Input[$iCount], "@@ControlCommandTable@@") Then
			$sTempString = $sTempString & makeControlCommandTable($iCount)
		ElseIf StringInStr($Input[$iCount], "@@StandardTable@@") Then
			$sTempString = $sTempString & makeStandardTable($iCount)
		ElseIf StringInStr($Input[$iCount], "@@StandardTable1@@") Then
			$sTempString = $sTempString & makeStandardTable1($iCount)
		ElseIf StringInStr($Input[$iCount], "@@ReturnTable@@") Then
			$sTempString = $sTempString & makeReturnTable($iCount)
		ElseIf StringInStr($Input[$iCount], "@@MsdnLink@@") Then
			$sTempString = $sTempString & makeMsdnLink($iCount)
		Else
			; will ignore blank lines...
			; but in Remarks section, allow non-consecutive blank lines...
			If StringStripWS($Input[$iCount], $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Or $sSection = "###" & $Reftype_main & "###" Then
				;In case of a include <...> Also translate < and >
				If StringInStr($Input[$iCount], "#include <") Then
					$Input[$iCount] = StringReplace($Input[$iCount], "<", "&lt;")
					$Input[$iCount] = StringReplace($Input[$iCount], ">", "&gt;")
				EndIf
				$sTempString = $sTempString & spaceToNBSP($Input[$iCount]) & '<br>' & $NL
			Else
				If $sSection = "###Remarks###" And $iCount + 1 < $iUBoundInput - 1 Then
					If StringStripWS($Input[$iCount + 1], $STR_STRIPLEADING + $STR_STRIPTRAILING) <> "" Then $sTempString = $sTempString & '<br>' & $NL
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
Func makeRelatedLinks($index)
	;links already containing '<a href' are pasted as is
	;normal function names and AutoItSetOption '(Option)' are "linkified"
	;assumes that multiple links are comma-separated

	;Handle special cases when no links

	Local $links = StringSplit(StringReplace($Input[$index], ", ", "|"), "|")
	Local $errFlag = @error
	If $errFlag And StringInStr($Input[$index], "none") Then
		Return "None."
	ElseIf $errFlag And StringInStr($Input[$index], "many") Then
		Return "Many!" ;special instance in AutoItSetOption
	ElseIf $errFlag Then
		;StringSplit did not create array since only one link (no comma)
		Dim $links[2]
		$links[1] = $Input[$index]
	EndIf

	;Create links

	Local $tempdir_In, $tempdir_Out, $htmName, $tag, $tmp = ""
	For $i = 1 To UBound($links) - 1
		If StringStripWS($links[$i], 1) = "" Then ContinueLoop
		If StringInStr($links[$i], "<a href") Then
			$tmp = $tmp & $links[$i] & ", "
		ElseIf StringInStr($links[$i], " (Option)") Then
			$tag = StringReplace($links[$i], " (Option)", "")
			$tmp = $tmp & '<a href="AutoItSetOption.htm#' & $tag & '">' & $links[$i] & '</a>, '
		Else
			$htmName = $links[$i]
			If StringInStr($htmName, "/") Then ;  with aliases
				$htmName = StringSplit($htmName, "/")
				$htmName = $htmName[1]
			EndIf
			;  gui links to the summary pages
			If StringInStr($links[$i], "...") Then
				$htmName = StringReplace($links[$i], "...", " Management")
			EndIf

			; links cross .chm
			If StringLeft($links[$i], 1) = "." Then
				$htmName = StringReplace($links[$i], ".", "")
			EndIf

			If StringInStr($htmName, " Management") = 0 Then
				; if the targetfile doesn't exist in the target htm dir then look in the other dirs.
				If Not FileExists($OUTPUT_DIR & $htmName & ".htm") And Not FileExists($INPUT_DIR & $htmName & ".txt") Then
					If $ReGen_AutoItX Then
						$tempdir_In = IniRead($TXT2HTM_INI, "Input", "methods", "ERR")
						$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "methods", "ERR")
						If Not FileExists($tempdir_Out & $htmName & ".htm") And Not FileExists($tempdir_In & $htmName & ".txt") Then
							_OutputBuildWrite('** Error in ' & $Filename & ' => Invalid Method reference to:' & $htmName & @CRLF)
							FileWriteLine(@WorkingDir & "\txt2htm_error.log", '** Error in ' & $Filename & ' => Invalid Method reference to:' & $htmName)
							;ContinueLoop
						EndIf
						$htmName = "../../" & $tempdir_Out & $htmName
					Else
						If Not FileExists($CROSS_DIR & $htmName & ".txt") Then
							$tempdir_In = IniRead($TXT2HTM_INI, "Input", "functions", "ERR")
							$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "functions", "ERR")
							If Not FileExists($tempdir_Out & $htmName & ".htm") And Not FileExists($tempdir_In & $htmName & ".txt") Then
								$tempdir_In = IniRead($TXT2HTM_INI, "Input", "keywords", "ERR")
								$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "keywords", "ERR")
								If Not FileExists($tempdir_Out & $htmName & ".htm") And Not FileExists($tempdir_In & $htmName & ".txt") Then
									$tempdir_In = IniRead($TXT2HTM_INI, "Input", "libfunctions", "ERR")
									$tempdir_Out = IniRead($TXT2HTM_INI, "Output", "libfunctions", "ERR")
									If Not FileExists($tempdir_Out & $htmName & ".htm") And Not FileExists($tempdir_In & $htmName & ".txt") Then
										_OutputBuildWrite('** Error in ' & $Filename & ' => Invalid Function reference to:' & $htmName & @CRLF)
										FileWriteLine(@WorkingDir & "\txt2htm_error.log", '** Error in ' & $Filename & ' => Invalid Function reference to:' & $htmName)
										;ContinueLoop
									EndIf
								EndIf
							EndIf
							$htmName = "../../" & $tempdir_Out & $htmName
						Else
							$links[$i] = $htmName
							$htmName = $CROSSLINK & $htmName
						EndIf
					EndIf
				EndIf
			EndIf
			$htmName = StringReplace($htmName, "../../html\functions\", "../functions/") ; Workaround for incorrect links in keywords HTML file.
			$tmp = $tmp & '<a href="' & $htmName & '.htm">' & $links[$i] & '</a>, '
		EndIf
	Next

	Return StringTrimRight($tmp, 2) ;remove trailing comma and space

EndFunc   ;==>makeRelatedLinks

;------------------------------------------------------------------------------
; Makes the a link to MSDN
; 11 Oct 2007 @@MsdnLink@@ search_string
; 18 Aug 2013 special case for GdiPlus function
;------------------------------------------------------------------------------
Func makeMsdnLink($index)
	Local $Name = StringSplit($Input[$index], " ")
	$Name = $Name[$Name[0]]
	; It can be better to launch an explorer web page
	; seems pretty long to stay in .chm to browse pages
	; an expert is needed for doing someting similar to the button "Open this script"
	If StringLeft($Name, 4) = "Gdip" Then Return 'Search <a href="http://search.msdn.microsoft.com/search/Default.aspx?brand=msdn&query=' & _
			$Name & '">' & _
			$Name & '</a> in MSDN  Library' & @CRLF

	Return 'Search <a href="http://msdn.microsoft.com/query/dev10.query?appId=Dev10IDEF1&l=EN-US&k=k(' & _
			$Name & ');k(DevLang-C);k(TargetOS-WINDOWS)&rd=true">' & _
			$Name & '</a> in MSDN  Library' & $NL
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
	Local $uboundinput = UBound($Input)
	While $i < $uboundinput
		If Not $fromInclude Then
			If StringInStr($Input[$i], "###Special###") Then ExitLoop
			If StringInStr($Input[$i], "@@IncludeExample@@") Then
				$i = -1
				ExitLoop
			EndIf
		EndIf
		$nbspified = StringReplace($Input[$i], "  ", "&nbsp;&nbsp;")
		;$nbspified = StringReplace($nbspified, "<", "&lt;")
		;$nbspified = StringReplace($nbspified, ">", "&gt;")
		$tmp = $tmp & _
				StringReplace($nbspified, @TAB, '&nbsp;&nbsp;&nbsp; ') & $NL
		$i = $i + 1
	WEnd

	If $i = -1 Then Return includeExample($i)

	$tmp = StringTrimRight($tmp, 0 + StringLen($NL)) ;remove very last <br> $NL stuff
	If StringStripWS($tmp, 3) <> "" And Not $fromInclude Then makeExample_AddButtons($tmp, "", 0)
	Return $tmp
EndFunc   ;==>makeExample

Func makeExample_AddButtons(ByRef $example, $exampleName, $n)
	Local $sPath = StringTrimLeft($exampleName, StringInStr($exampleName, '\', 0, -1))
	Local $sOpenButton = '<script type="text/javascript">' & $NL & _
			'if (document.URL.match(/^mk:@MSITStore:/i))' & $NL & _
			'{' & $NL & _
			'document.write(''<div class="codeSnippetContainerTab codeSnippetContainerTabSingle" dir="ltr">'');' & $NL & _
			'document.write(''<object id=hhctrl type="application/x-oleobject" classid="clsid:adb880a6-d8ff-11cf-9377-00aa003b7a11"><param name="Command" value="ShortCut"><param name="Font" value="Verdana,10pt"><param name="Text" value="Text:Open this Script"><param name="Item1" value=",Examples\\HelpFile\\' & _
			$sPath & ',"></object>'');' & $NL & _
			'document.write(''</div>'');' & $NL & _
			'}' & $NL & _
			'</script>' & $NL
	If $ReGen_AutoItX Or $exampleName = "" Then $sOpenButton = "" ; no open button as the example .vbs are not part of installer files

	$example = '<div class="codeSnippetContainer">' & $NL & _
			'    <div class="codeSnippetContainerTabs">' & $NL & _
			$sOpenButton & _
			'    </div>' & $NL & _
			'    <div class="codeSnippetContainerCodeContainer">' & $NL & _
			'        <div class="codeSnippetToolBar">' & $NL & _
			'            <div class="codeSnippetToolBarText">' & $NL & _
			'<script type="text/javascript">' & $NL & _
			'if ((navigator.appName=="Microsoft Internet Explorer") && (parseInt(navigator.appVersion)>=4)) // IE (4+) only' & $NL & _
			'    document.write(''<a href="#" id="copy" onclick="copyToClipboard(document.getElementById(\''copytext' & $n & '\'').innerText)">Copy to clipboard</a>'');' & $NL & _
			'</script>' & $NL & _
			'            </div>' & $NL & _
			'        </div>' & $NL & _
			'        <div id="copytext' & $n & '" class="codeSnippetContainerCode" dir="ltr">' & $NL & _
			'<div style="color:Black;"><pre>' & $NL & _
			$example & _
			'</pre></div>' & $NL & _
			'		</div>' & $NL & _
			'	</div>' & $NL & _
			'</div>' & $NL

EndFunc   ;==>makeExample_AddButtons

;------------------------------------------------------------------------------
; include file as an example
; 14 Jan 2005 added the au3 to htm conversion to Color the examples
; 06 Apr 2005 suppress mixing source AU3 examples and Colored HTM conversions files
; 18 Sep 2005 separation of input lib examples
; 17 Jan 2013 Added ability to use multiple examples of the form <filename>[n].au3
;------------------------------------------------------------------------------
Func includeExample(ByRef $i)
	Local $tFilename = StringReplace($Example_DIR & $Filename, ".txt", "")

	If FileExists($tFilename & "[2]" & $Example_EXT) Then
		; Multiple files exist
		Local $hFind = FileFindFirstFile($tFilename & "[*]" & $Example_EXT)

		Local $aFiles[1] = [StringReplace($Filename, ".txt", $Example_EXT)], $count = 0, $sFile
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
					If StringRight($aFiles[$n], StringLen("[" & $ex & "]" & $Example_EXT)) = "[" & $ex & "]" & $Example_EXT Then ExitLoop
				Next
			EndIf

			$aRet[$ex - 1][0] = FileReadLine($Example_DIR & $aFiles[$n], 1)
			$aRet[$ex - 1][1] = makeExample_ReadFile($i, $Example_DIR & $aFiles[$n])

			; Check if a custom title is used.
			If StringLeft($aRet[$ex - 1][0], 4) = ";== " Then
				$aRet[$ex - 1][1] = StringReplace($aRet[$ex - 1][1], $aRet[$ex - 1][0], "")
				$aRet[$ex - 1][1] = StringRegExpReplace($aRet[$ex - 1][1], "\<span\s+class\=""[^""]*""\s*\>\</span\>\r\n", "")
				$aRet[$ex - 1][1] = StringReplace($aRet[$ex - 1][1], "<br>", "", 1)

				$aRet[$ex - 1][0] = StringStripWS(StringTrimLeft(StringStripWS($aRet[$ex - 1][0], 3), 4), 3)
			Else
				$aRet[$ex - 1][0] = "Example " & $ex
			EndIf

			makeExample_AddButtons($aRet[$ex - 1][1], $aFiles[$n], $n)
		Next

		Return $aRet
	Else
		$tFilename = $tFilename & $Example_EXT

		Local $sRet = makeExample_ReadFile($i, $tFilename)
		makeExample_AddButtons($sRet, $tFilename, 0)
		Return $sRet
	EndIf
EndFunc   ;==>includeExample

;------------------------------------------------------------------------------
; Reads an example from a file, and formats it.
;------------------------------------------------------------------------------
Func makeExample_ReadFile(ByRef $i, $tFilename)
	; Added to convert the AU3 file to colored HTM by running ConvAU3ToHtm.exe.
	; This program sends the commands to SciTE Director interface to Open the file, save as html and close.
	If FileExists($tFilename) Then makeExampleHTML($tFilename)

	If Not FileToArray($tFilename, $Input) Then
		_OutputBuildWrite("** Warning in:" & $Filename & " ==> Include Example file was not found; skipping it:" & StringReplace($Filename, ".txt", $Example_EXT) & @CRLF)
		FileWriteLine(@WorkingDir & "\txt2htm_error.log", "** Warning in:" & $Filename & " ==> Include Example file was not found; skipping it:" & StringReplace($Filename, ".txt", $Example_EXT))
		Return ""
	Else
		$i = 1
		Return makeExample($i, 1)
	EndIf
EndFunc   ;==>makeExample_ReadFile

;------------------------------------------------------------------------------
; Uses SciTE to convert an au3 file to html
;------------------------------------------------------------------------------
Func makeExampleHTML(ByRef $tFilename)
	Local $oFileName = @WorkingDir & "\" & $Example_DIRO & $Filename & ".htm"
	If Not $ReGen_AutoItX Then
		;RunWait(@WorkingDir & "\ConvAU3ToHtm.exe " & $tFilename, @WorkingDir)
		SendSciTE_Command(0, $SciTE_hwnd, 'open:' & StringReplace($tFilename, "\", "\\") & '')
		SendSciTE_Command(0, $SciTE_hwnd, 'exportashtml:' & StringReplace($oFileName, "\", "\\"))
		SendSciTE_Command(0, $SciTE_hwnd, 'close:')
	Else
		FileCopy($tFilename, $oFileName, 1)
	EndIf
	If FileExists($oFileName) Then
		$tFilename = $oFileName
		; Read the generated file and strip the header and footer and replace some stuff to make it look better
		Local $OutRec, $TotalFile = FileRead($tFilename, FileGetSize($tFilename))
		If StringInStr($TotalFile, "<body") Then
			$OutRec = StringTrimLeft($TotalFile, StringInStr($TotalFile, '<body bgcolor="#') + 25)
			$OutRec = StringLeft($OutRec, StringInStr($OutRec, '</body>') - 1)
			$OutRec = StringReplace($OutRec, "<br />", "")
			; Add Links to known keywords
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tFilename = ' & $tFilename & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_AutoIt3_Helpfile_Link($OutRec)
		Else
			$OutRec = $TotalFile
		EndIf
		FileDelete($tFilename)
		FileWrite($tFilename, $OutRec)
	EndIf
EndFunc   ;==>makeExampleHTML

;------------------------------------------------------------------------------
; Set au3.api and au3.keyword.properties to be used by ConvAu3ToHtm
; to generated the right colored examples.
; They are built by "AutoIt Extractor.au3"
;------------------------------------------------------------------------------
Func LoadSciTE_Properties()
	; Get My GUI Handle
	$My_Hwnd = GUICreate("AutoIt3-SciTE interface")

	;Load AU3 Keywords file
	LoadPropertiesFile($Au3KeywordsProperties)
EndFunc   ;==>LoadSciTE_Properties

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
;------------------------------------------------------------------------------
Func makeStandardTable(ByRef $index)
	;Assumes one line per row with tab-separated columns
	$index = $index + 1

	Local $x, $tbl = $NL ;will contain final html table code

	While Not StringInStr($Input[$index], "@@End@@")
		;StringSplit each row into an array for easy parsing
		$x = StringSplit($Input[$index], @TAB)
		If @error Then
			$index = $index + 1
			ContinueLoop
		EndIf

		$tbl = $tbl & '  <tr>' & $NL
		For $i = 1 To $x[0]
			$tbl = $tbl & '    <td>' & $x[$i] & '</td>' & $NL
		Next
		$tbl = $tbl & '  </tr>' & $NL

		$index = $index + 1
	WEnd

	Return '<table>' & $tbl & '</table>'

EndFunc   ;==>makeStandardTable

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
; 28 Feb version change table look to have a separating line after first row only
;------------------------------------------------------------------------------
Func makeStandardTable1(ByRef $index)
	;Assumes one line per row with tab-separated columns
	$index = $index + 1

	Local $x, $tbl = $NL ;will contain final html table code
	; to generate a separation line after the first row
	Local $tr = '  <tr>'
	Local $td = "th"
	While Not StringInStr($Input[$index], "@@End@@")
		;StringSplit each row into an array for easy parsing
		$x = StringSplit($Input[$index], @TAB)
		If @error Then
			$index = $index + 1
			ContinueLoop
		EndIf

		$tbl = $tbl & $tr & $NL
		For $i = 1 To $x[0]
			$tbl = $tbl & '    <' & $td & '>' & $x[$i] & '</' & $td & '>' & $NL
		Next
		$tbl = $tbl & '  </tr>' & $NL
		;reset separation line for next lines
		$tr = '  <tr>'
		$td = 'td'
		$index = $index + 1
	WEnd

	Return '<br><table>' & $tbl & '</table>'

EndFunc   ;==>makeStandardTable1

;------------------------------------------------------------------------------
; Convert tab-delimited text to an html table
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 10% width and Column 2 has 90% width
;------------------------------------------------------------------------------
Func makeReturnTable(ByRef $index)
	;Assumes one line per row with tab-separated columns
	$index = $index + 1

	Local $tbl = $NL & '  <tr>' & $NL ;will contain final html table code
	Local $x = StringSplit($Input[$index], @TAB)
	If StringInStr($x[1], ':') = 0 Then $x[1] &= ':'
	$tbl &= '    <td style="width:10%" valign="top">' & $x[1] & '</td>' & $NL
	$tbl &= '    <td style="width:90%">' & $x[2]
	$index += 1

	While Not StringInStr($Input[$index], "@@End@@")
		;StringSplit each row into an array for easy parsing
		$x = StringSplit($Input[$index], @TAB)
		If @error Then
			$index += 1
			ContinueLoop
		EndIf

		If $x[1] = "" Then
			$tbl &= '<br>' & $NL & "       " & spaceToNBSP(StringTrimLeft($Input[$index], 1))
		Else
			$tbl &= '</td>' & $NL & '  </tr>' & $NL & '  <tr>' & $NL
			If StringInStr($x[1], ':') = 0 Then $x[1] &= ':' ; force : if missing
			$tbl &= '    <td valign="top">' & $x[1] & '</td>' & $NL
			$tbl &= '    <td>' & $x[2]
		EndIf
		$index += 1
	WEnd

	Return '<table class="noborder">' & $tbl & '</td>' & $NL & '  </tr>' & $NL & '</table>'

EndFunc   ;==>makeReturnTable

;------------------------------------------------------------------------------
; Convert special tab delimited text to a two-colum table.
;    Each non-indented line indicates a new row.
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 15% width and Column 2 has 85% width
;------------------------------------------------------------------------------
Func makeParamTable(ByRef $index)
	;make a pass to determine how many rows and columns the table has
	Local $indention, $rows = 0
	Local $i = $index + 1
	While Not StringInStr($Input[$i], "@@End@@")
		$indention = stringCount($Input[$i], @TAB)
		If $indention = 0 Then $rows = $rows + 1
		$i = $i + 1
	WEnd
	Local $start = $index + 1
	Local $stop = $i - 1

	$index = $stop + 1 ;note that $index was ByRef'ed

	Local $matrix[$rows][2]

	Local $data = ""
	Local $r = -1
	Local $c = 0
	For $i = $start To $stop
		$indention = stringCount($Input[$i], @TAB)

		If $indention = 0 Then
			$r = $r + 1
			$c = 0
		Else
			$c = 1
			$indention = 1
		EndIf

		$data = spaceToNBSP(StringTrimLeft($Input[$i], $indention))

		; Ensure [optional] is bold.
		If StringInStr($Input[$i], "[optional]") Then $data = StringReplace($Input[$i], "[optional]", "<b>[optional]</b>")

		If $matrix[$r][$c] <> "" Then
			$matrix[$r][$c] = $matrix[$r][$c] & '<br>' & $data
		Else
			$matrix[$r][$c] = $data
		EndIf
	Next

	Local $tbl = '<table>' & $NL

	For $r = 0 To $rows - 1

		$tbl = $tbl & '  <tr>' & $NL

		For $c = 0 To 1
			$data = StringReplace($matrix[$r][$c], "<br>", "<br>" & $NL & "       ")
			Select
				Case $r = 0 And $c = 0 ;only put width%-info on first row
					$tbl = $tbl & '    <td style="width:15%">' & $data & '</td>' & $NL
				Case $r = 0 And $c = 1
					$tbl = $tbl & '    <td style="width:85%">' & $data & '</td>' & $NL
				Case Else
					$tbl = $tbl & '   <td>' & $data & '</td>' & $NL
			EndSelect
		Next
		$tbl = $tbl & '  </tr>' & $NL
	Next

	Return $tbl & '</table>'

EndFunc   ;==>makeParamTable

;------------------------------------------------------------------------------
; Convert special tab delimited text to a two-colum table.
;    Each non-indented line indicates a new row.
;    Each indented line indicates contents of column 2 for that row.
; Column 1 has 40% width and Column 2 has 60% width
;------------------------------------------------------------------------------
Func makeControlCommandTable(ByRef $index)
	;make a pass to determine how many rows and columns the table has
	Local $indention, $rows = 0
	Local $i = $index + 1
	While Not StringInStr($Input[$i], "@@End@@")
		$indention = stringCount($Input[$i], @TAB)
		If $indention = 0 Then $rows = $rows + 1
		$i = $i + 1
	WEnd
	Local $start = $index + 1
	Local $stop = $i - 1

	$index = $stop + 1 ;note that $index was ByRef'ed

	Local $matrix[$rows][2]

	Local $data = ""
	Local $r = -1
	Local $c = 0
	For $i = $start To $stop
		$indention = stringCount($Input[$i], @TAB)
		$data = spaceToNBSP(StringTrimLeft($Input[$i], $indention))
		If $indention = 0 Then
			$r = $r + 1
			$c = 0
		Else
			$c = 1
		EndIf
		If $matrix[$r][$c] <> "" Then
			$matrix[$r][$c] = $matrix[$r][$c] & '<br>' & $data
		Else
			$matrix[$r][$c] = $data
		EndIf
	Next

	Local $tbl = '<table>' & $NL

	For $r = 0 To $rows - 1

		$tbl = $tbl & '  <tr>' & $NL

		For $c = 0 To 1
			$data = StringReplace($matrix[$r][$c], "<br>", "<br>" & $NL & "       ")
			Select
				Case $r = 0 And $c = 0 ;only put width%-info on first row
					$tbl = $tbl & '    <td style="width:40%">' & $data & '</td>' & $NL
				Case $r = 0 And $c = 1
					$tbl = $tbl & '    <td style="width:60%">' & $data & '</td>' & $NL
				Case Else
					$tbl = $tbl & '   <td>' & $data & '</td>' & $NL
			EndSelect
		Next
		$tbl = $tbl & '  </tr>' & $NL
	Next

	Return $tbl & '</table>'

EndFunc   ;==>makeControlCommandTable

; --------------------------------------------------------------------
; Count the occcurrences of a single character in a string
; --------------------------------------------------------------------
Func stringCount($str, $char)
	Local $t = StringSplit($str, $char)
	If @error Then Return 0
	Return $t[0] - 1
EndFunc   ;==>stringCount

; --------------------------------------------------------------------
; Convert all but one leading space to the &nbsp; html code
; --------------------------------------------------------------------
Func spaceToNBSP($str)
	For $i = 1 To StringLen($str)
		If StringMid($str, $i, 1) <> " " Then ExitLoop
	Next
	If $i - 1 > 0 Then $str = StringReplace($str, " ", "&nbsp;", $i - 1)

	;Also convert each leading tab to 4 spaces ("&nbsp;&nbsp;&nbsp; ")
	For $i = 1 To StringLen($str)
		If StringMid($str, $i, 1) <> @TAB Then ExitLoop
	Next
	If $i - 1 > 0 Then
		$str = StringReplace($str, @TAB, "&nbsp;&nbsp;&nbsp; ", $i - 1)
	EndIf

	Return $str
EndFunc   ;==>spaceToNBSP

;------------------------------------------------------------------------------
; Based on Jon's post http://www.autoitscript.com/forum/index.php?showtopic=530
;------------------------------------------------------------------------------
Func FileToArray($sFile, ByRef $aArray)
	Local $hFile = FileOpen($sFile, 0)
	If $hFile = -1 Then Return 0 ;failure

	Local $sText = ""
	While 1
		$sText = $sText & FileReadLine($hFile) & @LF
		If @error <> 0 Then ExitLoop
	WEnd

	FileClose($hFile)

	$sText = StringTrimRight($sText, 1) ;remove final @LF
	$aArray = StringSplit($sText, @LF)

	Return 1 ;success

EndFunc   ;==>FileToArray

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
; Check when rebuildall not asked if the input is newer than the output
;------------------------------------------------------------------------------
Func isGreaterFileTime($sInfile, $sOutfile)
	If Not $ReGen_All Then
		Local $sInTime = FileGetTime($sInfile, 0, 1)
		If @error Then
			; skip generation of this file when its not there
			; MsgBox(0, "error", "Unable to retrieve filedate for:" & $sInfile & @CRLF)
			Return 1
		Else
			Local $sOutTime = FileGetTime($sOutfile, 0, 1)
			If @error Then Return 0
			If $sInTime < $sOutTime Then Return 1; to skip generation for this file
		EndIf
	EndIf
	Return 0
EndFunc   ;==>isGreaterFileTime

;------------------------------------------------------------------------------
Func LoadPropertiesFile($file)
	Local $Au3Props = FileRead($file)
	$Au3Props = StringRegExpReplace($Au3Props, '\\(.*?)\r\n', '')
	$Au3Props = StringRegExpReplace($Au3Props, '(\h+?)', ' ')
	$Au3Props = StringSplit($Au3Props, @CRLF, 1)
	For $x = 1 To $Au3Props[0]
		If StringLeft($Au3Props[$x], 1) <> "#" Then UpdateVar($Au3Props[$x])
	Next
EndFunc   ;==>LoadPropertiesFile

;------------------------------------------------------------------------------
; update properties
;------------------------------------------------------------------------------
Func UpdateVar($Input)
	Local $Keyword = StringLeft($Input, StringInStr($Input, "=") - 1)
	If $Keyword = "" Then Return
	; update keyword in SciTE
	SendSciTE_Command($My_Hwnd, $SciTE_hwnd, "property:" & $Input)
EndFunc   ;==>UpdateVar

;------------------------------------------------------------------------------
; Send commands to SciTE's Director interface
;------------------------------------------------------------------------------
Func SendSciTE_Command($hWnd, $hSciTE, $sString)
	$sString = ':' & Dec(StringTrimLeft($hWnd, 2)) & ':' & $sString
	Local $tData = DllStructCreate('char[' & StringLen($sString) + 1 & ']') ; wchar
	DllStructSetData($tData, 1, $sString)

	Local Const $tagCOPYDATASTRUCT = 'ptr;dword;ptr' ; ';ulong_ptr;dword;ptr'
	Local $tCOPYDATASTRUCT = DllStructCreate($tagCOPYDATASTRUCT)
	DllStructSetData($tCOPYDATASTRUCT, 1, 1)
	DllStructSetData($tCOPYDATASTRUCT, 2, DllStructGetSize($tData))
	DllStructSetData($tCOPYDATASTRUCT, 3, DllStructGetPtr($tData))
	_SendMessage($hSciTE, $WM_COPYDATA, $hWnd, DllStructGetPtr($tCOPYDATASTRUCT))
	Return Number(Not @error)
EndFunc   ;==>SendSciTE_Command


;------------------------------------------------------------------------------
; Add link to keywords, Functions and UDFs
;------------------------------------------------------------------------------
Func _AutoIt3_Helpfile_Link(ByRef $sExampleData)
	; UDF
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S15">([\w]+?)</span>', '<a class="codeSnippetLink" href="../libfunctions/\1.htm"><span class="S15">\1</span></a>')
	; LIBFUNC-structure of $tag ... in the examples
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S9">(\$tag\w+?)</span>', '<a class="codeSnippetLink" href="\1.htm"><span class="S9">\1</span></a>')
	; functions
	$sExampleData = StringRegExpReplace($sExampleData, '<span class="S4">([\w]+?)</span>', '<a class="codeSnippetLink" href="../functions/\1.htm"><span class="S4">\1</span></a>')
	$sExampleData = StringReplace($sExampleData, 'href="../functions/Opt.htm">', 'href="../functions/AutoItSetOption.htm">')
	; exception for UDPStartup, UDPShutdown
	$sExampleData = StringReplace($sExampleData, '<a class="codeSnippetLink" href="UDPStartup.htm"><span class="S4">UDPStartup</span></a>', '<a class="codeSnippetLink" href="TCPStartup.htm"><span class="S4">UDPStartup</span></a>')
	$sExampleData = StringReplace($sExampleData, '<a class="codeSnippetLink" href="UDPShutdown.htm"><span class="S4">UDPShutdown</span></a>', '<a class="codeSnippetLink" href="TCPShutdown.htm"><span class="S4">UDPShutdown</span></a>')
	; macros
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S6">(@[^<]+)</span>', '<a class="codeSnippetLink" href="../macros.htm#\1"><span class="S6">\1</span></a>')
	; operators
	$sExampleData = StringRegExpReplace($sExampleData, '(?i)<span class="S8">((?:[+^*/=&-]|&gt;|&lt;)+)</span>', '<a class="codeSnippetLink" href="../intro/lang_operators.htm"><span class="S8">\1</span></a>')
	; keywords
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
