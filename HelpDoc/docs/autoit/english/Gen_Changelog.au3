#cs
	Credit: Created by guinness - 2013/07/22
#ce
#include '..\..\_build\include\MiscLib.au3'
#include '..\..\_build\include\OutputLib.au3'
#include <Constants.au3>
#include <FileConstants.au3>

Opt('TrayIconDebug', 1)

OnAutoItExitRegister('OnQuit') ; ### Debug Console
_OutputWindowCreate() ; ### Debug Console

_OutputProgressWrite('history.htm Creation...')

FileChangeDir(@ScriptDir)

; Only works with 3.2.0.1 (13th August, 2006) (Release) and newer.
; Use the functions.txt and libfunctions.txt files in docs\autoit\english\txt2htm\syntaxfiles
HTMLChangelog(@ScriptDir & '\html\autoit_changelog.txt', @ScriptDir & '\html\history.htm', @ScriptDir & '\txt2htm\syntaxfiles\functions.txt', _
		@ScriptDir & '\txt2htm\syntaxfiles\libfunctions.txt', @ScriptDir & '\txt2htm\syntaxfiles\macros.txt', '')
; HTMLChangelog(@ScriptDir & '\html\autoit_changelog.txt', @ScriptDir & '\html\history_chm.htm', @ScriptDir & '\txt2htm\syntaxfiles\functions.txt', _
; @ScriptDir & '\txt2htm\syntaxfiles\libfunctions.txt', @ScriptDir & '\txt2htm\syntaxfiles\macros.txt', 'UDFs3.chm::/html/')

_OutputProgressWrite('Finished.' & @CRLF) ;### Debug Console

Exit

Func OnQuit()
	_OutputWaitClosed() ; ### Debug Console
EndFunc   ;==>OnQuit


Func HTMLChangelog($sChangeLogPath, $sHTMLOutPath, $sNativeList, $sUDFList, $sMacroList, $sLocalRef)
	If FileExists($sNativeList) = 0 Or FileExists($sUDFList) = 0 Or FileExists($sMacroList) = 0 Then
		_OutputProgressWrite('Missing function lists - please re-generate the lists for history.html to be created.' & @CRLF) ; ### Debug Console
		Return False
	EndIf

	; Read the changelog file.
	Local $sData = FileRead($sChangeLogPath)

	; Remove old entries (v3.2.0 and older). These aren't supported with this script.
	$sData = StringRegExpReplace($sData, '(?ms)^3\.2\.0\h+.+', '')

	; By Melba23, convert \r & \n to \r\n.
	$sData = StringRegExpReplace($sData, '((?<!\r)\n|\r(?!\n))', @CRLF) ; Using \R caused unexpected issues.

	; Convert & to &amp;.
	$sData = StringRegExpReplace($sData, '&(?!(?:amp|gt|lt);)', '&amp;') ; Convert &.

	; Convert < and >.
	$sData = StringReplace($sData, '<', '&lt;') ; Convert <.
	$sData = StringReplace($sData, '>', '&gt;') ; Convert >.

	; Strip <space> and dash at the start of the line.
	$sData = StringRegExpReplace($sData, '(?m)^\h*\-\h*', '')

	; Remove double blank lines and trailing whitespace.
	_StripEmptyLines($sData)
	_StripWhitespace($sData)

	; Convert native functions to a URL. Case-sensitive so it matches correctly. Matches Function().
	Local $aAu3API = StringRegExp(FileRead($sNativeList), '(?m)^(\w+)', 3)
	For $i = 0 To UBound($aAu3API) - 1
		$sData = StringRegExpReplace($sData, '\b' & $aAu3API[$i] & '\b([(][)]+)+', '<a href="functions/' & $aAu3API[$i] & '.htm">' & $aAu3API[$i] & '\1</a>')
	Next

	; Convert UDF functions to a URL. Case-sensitive so it matches correctly. Matches _Function().
	$aAu3API = StringRegExp(FileRead($sUDFList), '(?m)^(\w+)', 3)
	For $i = 0 To UBound($aAu3API) - 1
		$sData = StringRegExpReplace($sData, '\b' & $aAu3API[$i] & '\b([(][)]+)+', '<a href="' & $sLocalRef & 'libfunctions/' & $aAu3API[$i] & '.htm">' & $aAu3API[$i] & '\1</a>')
	Next

	; Convert macros. Case-sensitive so it matches correctly. Matches @Macro.
	$aAu3API = StringRegExp(FileRead($sMacroList), '(?m)^(@\w+)', 3)
	For $i = 0 To UBound($aAu3API) - 1
		$sData = StringReplace($sData, $aAu3API[$i], '<a href="macros.htm#' & $aAu3API[$i] & '">' & $aAu3API[$i] & '</a>')
	Next

	; Convert Trac numbers to a URL with Trac number.
	$sData = StringRegExpReplace($sData, '#(\d+)', '<a href="http://www.autoitscript.com/trac/autoit/ticket/\1">#\1</a>')

	; Parse changelog to an array using a regular expression.
	Local $aSRE = StringRegExp($sData, '(?ms)((?:\d+\.){3}\d+.+?)(?=^(?:\d+\.){3}\d+|\Z)', 3), $aSplit = 0, _
			$fFirstRun = True, $fSectionStart = True, _
			$iIndex = 2, _
			$sHTML = ''

	; HTML header.
	$sHTML &= '<!DOCTYPE html>' & @CRLF
	$sHTML &= '<html>' & @CRLF
	$sHTML &= '<head>' & @CRLF
	$sHTML &= @TAB & '<title>History</title>' & @CRLF
	$sHTML &= @TAB & '<meta charset="ISO-8859-1">' & @CRLF
	$sHTML &= @TAB & '<link href="css/default.css" rel="stylesheet" type="text/css">' & @CRLF
	$sHTML &= '</head>' & @CRLF
	$sHTML &= '<body>' & @CRLF
	$sHTML &= @TAB & '<h1>History</h1>' & @CRLF
	$sHTML &= @TAB & '<p class="c1"><strong>IMPORTANT:</strong> <a href="script_breaking_changes.htm">See here</a> for recent script-breaking changes.</p>' & @CRLF
	$sHTML &= @TAB & '<p>&nbsp;</p>' & @CRLF
	$sHTML &= @TAB & '<p>Here is the summarized history of the changes to AutoIt v3.</p>' & @CRLF
	$sHTML &= @TAB & '<p class="c2">(For the complete technical history click <a href="autoit_changelog.txt">here</a>. For the complete history including <strong>all changes between beta versions</strong> click <a href="autoit_changelog_complete.txt">here</a>.)</p>' & @CRLF
	$sHTML &= @TAB & '<p>&nbsp;</p>' & @CRLF

	Local $fStart = True
	For $i = 0 To UBound($aSRE) - 1 ; Commented out UBound for current release only.
		$aSRE[$i] = StringRegExpReplace($aSRE[$i], '^\v+', '') ; Remove blank lines at the start.
		$aSRE[$i] = StringRegExpReplace($aSRE[$i], '\v+$', '') ; Remove blank lines at the end.
		$aSplit = StringSplit($aSRE[$i], @CRLF, 1)
		If @error = 0 Then
			$iIndex = 2
			If Not $fStart Then $sHTML &= @TAB & '<br>' & @CRLF
			$fStart = False
			$sHTML &= @TAB & '<p class="c4"><strong class="c3">' & $aSplit[1] & '</strong></p>' & @CRLF ; Release and date.
			If StringStripWS($aSplit[2], $STR_STRIPALL) = '' Then
				$sHTML &= @TAB & '<ul>' & @CRLF
				$iIndex = 3 ; Workaround: If the next entry is blank, then increase by one.
			EndIf
			For $j = $iIndex To $aSplit[0]
				Switch $aSplit[$j] ; Check if the array entry is a section or other.
					Case 'Au3Check:', 'Au3Info:', 'Au3Record:', 'Aut2Exe:', 'AutoIt:', 'AutoIt3Help:', 'AutoItX:', 'Big Changes:', 'Others:', 'Other Changes:', 'SciTE "lite":', 'UDFs:'
						If $fFirstRun Then ; If this is the first time manipulating the following release, then do the following.
							$fFirstRun = False
						Else
							$sHTML &= @TAB & '</ul>' & @CRLF
						EndIf
						$fSectionStart = True ; Set to True as we are in a section.
						$sHTML &= @TAB & '<p><strong>' & $aSplit[$j] & '</strong></p>' & @CRLF
						$sHTML &= @TAB & '<ul>' & @CRLF
					Case Else
						If StringStripWS($aSplit[$j], $STR_STRIPALL) = '' Then
							If $fSectionStart Then ; If blank line and section then do the following.
								$fSectionStart = False

								; If $j is less than the total number of array items and then next line a new section. Add a close ul tag.
								If $j < $aSplit[0] And StringRegExp($aSplit[$j + 1], '(?m)^\V+:') = 0 Then
									$sHTML &= @TAB & '</ul>' & @CRLF
									If Not ($j = $aSplit[0]) Then ; If not the last entry then add a new ul tag.
										$sHTML &= @TAB & '<ul>' & @CRLF
									EndIf
								Else
									$sHTML &= @TAB & '</ul>' & @CRLF ; Create a blank space.
									$sHTML &= @TAB & '<ul>' & @CRLF
								EndIf
							Else
								$sHTML &= @TAB & '</ul>' & @CRLF ; Create a blank space.
								$sHTML &= @TAB & '<ul>' & @CRLF
							EndIf

						Else ; Else it's either an entry.
							If Not $fSectionStart And $j = 2 Then
								$sHTML &= @TAB & '<ul>' & @CRLF
							EndIf
							$sHTML &= @TAB & @TAB & '<li>' & $aSplit[$j] & '</li>' & @CRLF ; Add new entry.
							If $j = $aSplit[0] Then ; If the last entry then add the close ul tag.
								$sHTML &= @TAB & '</ul>' & @CRLF
							EndIf
						EndIf
				EndSwitch
			Next
		EndIf
		; Reset the variables.
		$fFirstRun = True
		$fSectionStart = False

	Next
	$sHTML &= '</body>' & @CRLF
	$sHTML &= '</html>' & @CRLF
	Local $hFileOpen = FileOpen($sHTMLOutPath, $FO_OVERWRITE)
	If $hFileOpen > -1 Then
		FileWrite($sHTMLOutPath, $sHTML)
		FileClose($hFileOpen)
	Else
		_OutputProgressWrite('There was an error creating the history.htm file.' & @CRLF) ; ### Debug Console
	EndIf
	Return True
EndFunc   ;==>HTMLChangelog
