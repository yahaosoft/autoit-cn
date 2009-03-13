;==============================================================================
; Automatically generate base syntax files for functions and keywords
;==============================================================================
$def= ""
$Conv= ""

; Do the functions
DoFunctions()

; Do the macros
DoMacros()

Filecopy(@ScriptDir & '\extra.def',@ScriptDir & '\AutoIt3.def',1)
$jfile = FileOpen(@ScriptDir & '\AutoIt3.def', 1)
FileWriteLine($jfile, $Def)
FileClose($jfile)

Exit


;------------------------------------------------------------------------------
; Makes a list of the functions and their parameters
;------------------------------------------------------------------------------
Func DoFunctions()

Local $templist, $filename, $htemplist, $houtput, $functionlist, $bfirst
Local $functionname, $afunctionname, $functionparamlist

	; Change directory to the functions text files
	FileChangeDir(@ScriptDir & "\..\..\txtFunctions")

	;pipe the list of sorted file names to fileList.tmp:
	$templist = FileGetShortName(@ScriptDir & '\fileList.tmp')
	_RunCmd('dir /b /o:N > "' & $templist & '"')

	$htemplist = FileOpen($templist, 0)  ;read mode
	If $htemplist = -1 Then
		MsgBox(0, "AutoIt", "Error opening temp list.")
		Exit
	EndIf
	
    $filename = FileReadLine($htemplist)
    $bfirst = 1
    While Not @error
		If Not StringInStr($filename, ".txt") Then
			$filename = FileReadLine($htemplist)				
			ContinueLoop
		EndIf
		
		; Get the function name (strip .txt)
		$functionname = StringTrimRight($filename, 4)
	
		; Add to our basic function list
		If $bFirst = 0 Then $functionlist = $functionlist & @CRLF
		$functionlist = $functionlist & $functionname

		; Add to our parameter function list
		If $bFirst = 0 Then $functionparamlist = $functionparamlist & @CRLF
		$functionparamlist = $functionparamlist & GetParams($filename)
      
		$def = $def & "[" & $functionname & " | " & GetDesc($filename) & "]" & @CRLF
		$def = $def & StringReplace(GetParams($filename),"( " ,"( |") & @CRLF & ";" & @CRLF
      $Conv = $Conv & $functionname & "|" & $functionname & @CRLF
		$bFirst = 0
      $filename = FileReadLine($htemplist)
    Wend

	; Close and delete templist
	FileClose($htemplist)
	FileDelete($templist)

	; Output the list of functions (LF delimited)
	$houtput = FileOpen(@ScriptDir & '\..\functions.txt', 2)
	FileWriteLine($houtput, $functionlist)
	FileClose($houtput)

	; Output the list of functions and params(LF delimited)
	$houtput = FileOpen(@ScriptDir & '\..\function_params.txt', 2)
	FileWriteLine($houtput, $functionparamlist)
	FileClose($houtput)
	
	; Reset working directory
	FileChangeDir(@ScriptDir)


EndFunc

;------------------------------------------------------------------------------
; Gets the ###Syntax### entry of a file
;------------------------------------------------------------------------------
Func GetParams($filename)

Local $line, $hfile

	$hfile = FileOpen($filename, 0)

	$line = FileReadLine($hfile)
	While Not @error
		If StringInStr($line, "###Syntax###") Then
			$line = StringStripWS( FileReadLine($hfile), 3)
			;Get 1st non-blank line; (assume it's the keyword/function name)
			While $line = ""
				$line = StringStripWS( FileReadLine($hfile), 3)
			WEnd
			ExitLoop
		EndIf

		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

	Return $line
EndFunc

;------------------------------------------------------------------------------
; Gets the ###Description### entry of a file
;------------------------------------------------------------------------------
Func GetDesc($filename)

Local $line, $hfile

	$hfile = FileOpen($filename, 0)

	$line = FileReadLine($hfile)
	While Not @error
		If StringInStr($line, "###Description###") Then
			$line = StringStripWS( FileReadLine($hfile), 3)
			;Get 1st non-blank line; (assume it's the keyword/function name)
			While $line = ""
				$line = StringStripWS( FileReadLine($hfile), 3)
			WEnd
			ExitLoop
		EndIf

		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

	Return $line
EndFunc

;------------------------------------------------------------------------------
; Makes a list of the macros
;------------------------------------------------------------------------------
Func DoMacros()

Local $hfile, $line, $bfirst, $pos, $macrolist
Local $MName

	$hfile = FileOpen("..\..\..\html\macros.htm", 0)  ;read mode
	If $hfile = -1 Then
		MsgBox(0, "AutoIt", "Error opening macros.html.")
		Exit
	EndIf
	
	$bfirst = 1
	$line = FileReadLine($hfile)
	While Not @error
		$pos = StringInStr($line, 'bold;">@')
		If $pos <> 0 Then
			$line = StringTrimLeft($line, $pos+6)
			$pos = StringInStr($line, '</td>')
			If $pos <> 0 Then $line = StringLeft($line, $pos-1)
			$line = StringStripWS($line, 3)
         $MName = $line

         If $bfirst = 0 Then $macrolist = $macrolist & @CRLF
			$macrolist = $macrolist & $line
      
         $line = FileReadLine($hfile)
         $line = StringReplace($line,'<td>','')
         $line = StringReplace($line,'</td>','')
   		$def = $def & "[" & $MName & " | " & $Line & "]" & @CRLF
	   	$def = $def & $MName & @CRLF & ";" & @CRLF

         $Conv = $Conv & $MName & "|" & $MName & @CRLF

			$bfirst = 0
		EndIf

		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

	; Write the output
	FileWriteLine("macros.txt", $macrolist)

EndFunc



;------------------------------------------------------------------------------
; Run DOS/console commands
;------------------------------------------------------------------------------
Func _RunCmd($command)
    Return RunWait(@ComSpec & " /c " & $command, "", @SW_HIDE)
EndFunc
