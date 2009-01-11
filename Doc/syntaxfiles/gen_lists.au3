;==============================================================================
; Automatically generate base syntax files for functions and keywords
;==============================================================================

; Do the functions
DoFunctions()
DoLibFunctions()

; Do the macros
DoMacros()

; Now the keywords (static) ;p
If Not FileExists(@ScriptDir & '\keywords.txt') Then ; in case of, but at the end must be removed
	$hfile = FileOpen(@ScriptDir & '\keywords.txt', 2)
	FileWriteLine($hfile, "And")
	FileWriteLine($hfile, "ByRef")
	FileWriteLine($hfile, "Case")
	FileWriteLine($hfile, "Const")
	FileWriteLine($hfile, "ContinueCase")
	FileWriteLine($hfile, "ContinueLoop")
	FileWriteLine($hfile, "Default")
	FileWriteLine($hfile, "Dim")
	FileWriteLine($hfile, "Do")
	FileWriteLine($hfile, "Else")
	FileWriteLine($hfile, "ElseIf")
	FileWriteLine($hfile, "EndFunc")
	FileWriteLine($hfile, "EndIf")
	FileWriteLine($hfile, "EndSelect")
	FileWriteLine($hfile, "Enum")
	FileWriteLine($hfile, "EndStruct")
	FileWriteLine($hfile, "EndSwitch")
	FileWriteLine($hfile, "EndWith")
	FileWriteLine($hfile, "Exit")
	FileWriteLine($hfile, "ExitLoop")
	FileWriteLine($hfile, "False")
	FileWriteLine($hfile, "For")
	FileWriteLine($hfile, "Func")
	FileWriteLine($hfile, "Global")
	FileWriteLine($hfile, "If")
	FileWriteLine($hfile, "In")
	FileWriteLine($hfile, "Local")
	FileWriteLine($hfile, "Next")
	FileWriteLine($hfile, "Not")
	FileWriteLine($hfile, "Or")
	FileWriteLine($hfile, "Return")
	FileWriteLine($hfile, "ReDim")
	FileWriteLine($hfile, "Select")
	FileWriteLine($hfile, "Step")
	FileWriteLine($hfile, "Struct")
	FileWriteLine($hfile, "Switch")
	FileWriteLine($hfile, "Then")
	FileWriteLine($hfile, "True")
	FileWriteLine($hfile, "To")
	FileWriteLine($hfile, "Until")
	FileWriteLine($hfile, "WEnd")
	FileWriteLine($hfile, "With")
	FileWriteLine($hfile, "While")
	FileWriteLine($hfile, "#ce")
	FileWriteLine($hfile, "#comments-end")
	FileWriteLine($hfile, "#comments-start")
	FileWriteLine($hfile, "#cs")
	FileWriteLine($hfile, "#include")
	FileWriteLine($hfile, "#include-once")
	FileWriteLine($hfile, "#NoTrayIcon")
	FileWriteLine($hfile, "#forceref")
	FileWriteLine($hfile, "#compiler_allow_decompile")
	FileWriteLine($hfile, "#compiler_au3check_dat")
	FileWriteLine($hfile, "#compiler_au3check_parameters")
	FileWriteLine($hfile, "#compiler_au3check_stop_onwarning")
	FileWriteLine($hfile, "#compiler_aut2exe")
	FileWriteLine($hfile, "#compiler_autoit3")
	FileWriteLine($hfile, "#compiler_compression")
	FileWriteLine($hfile, "#compiler_icon")
	FileWriteLine($hfile, "#compiler_outfile")
	FileWriteLine($hfile, "#compiler_outfile_type")
	FileWriteLine($hfile, "#compiler_passphrase")
	FileWriteLine($hfile, "#compiler_plugin_funcs")
	FileWriteLine($hfile, "#compiler_prompt")
	FileWriteLine($hfile, "#compiler_res_comment")
	FileWriteLine($hfile, "#compiler_res_description")
	FileWriteLine($hfile, "#compiler_res_field")
	FileWriteLine($hfile, "#compiler_res_field1name")
	FileWriteLine($hfile, "#compiler_res_field1value")
	FileWriteLine($hfile, "#compiler_res_field2name")
	FileWriteLine($hfile, "#compiler_res_field2value")
	FileWriteLine($hfile, "#compiler_res_fileversion")
	FileWriteLine($hfile, "#compiler_res_fileversion_autoincrement")
	FileWriteLine($hfile, "#compiler_res_legalcopyright")
	FileWriteLine($hfile, "#compiler_run_after")
	FileWriteLine($hfile, "#compiler_run_au3check")
	FileWriteLine($hfile, "#compiler_run_before")
	FileWriteLine($hfile, "#compiler_run_cvswrapper")
	FileWriteLine($hfile, "#compiler_run_tidy")
	FileWriteLine($hfile, "#compiler_tidy_stop_onerror")
	FileWriteLine($hfile, "#compiler_useupx")
	FileWriteLine($hfile, "#endregion")
	FileWriteLine($hfile, "#region")
	FileWrite($hfile, "#tidy_parameters")
	FileClose($hfile)
EndIf

; Add extra functions
$hfile = FileOpen(@ScriptDir & '\functions.txt', 1)
FileWriteLine($hfile, "")
FileWrite($hfile, "Opt")
FileClose($hfile)

$hfile = FileOpen(@ScriptDir & '\function_params.txt', 1)
FileWriteLine($hfile, "")
FileWriteLine($hfile, "PluginClose ( dllhandle )")
FileWrite($hfile, "PluginOpen ( filename )")
FileClose($hfile)

Exit


;------------------------------------------------------------------------------
; Makes a list of the functions and their parameters
;------------------------------------------------------------------------------
Func DoFunctions()

Local $templist, $filename, $htemplist, $houtput, $functionlist, $bfirst, $desc
Local $functionname, $afunctionname, $functionparamlist

	; Change directory to the functions text files
	FileChangeDir(@ScriptDir & "\..\txtFunctions")

	;pipe the list of sorted file names to fileList.tmp:
	$templist = @ScriptDir & '\fileList.tmp'
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
		$functionparamlist = $functionparamlist & GetParams($filename, $desc)& " " & $desc

	

		$bFirst = 0
	    $filename = FileReadLine($htemplist)
    Wend

	; Close and delete templist
	FileClose($htemplist)
	FileDelete($templist)

	; Output the list of functions (LF delimited)
	$houtput = FileOpen(@ScriptDir & '\functions.txt', 2)
	FileWrite($houtput, $functionlist)
	FileClose($houtput)

	; Output the list of functions and params(LF delimited)
	$houtput = FileOpen(@ScriptDir & '\function_params.txt', 2)
	FileWrite($houtput, $functionparamlist)
	FileClose($houtput)
	
	; Reset working directory
	FileChangeDir(@ScriptDir)


EndFunc ;==>some text

Func DoLibFunctions()

Local $templist, $filename, $htemplist, $houtput, $functionlist, $bfirst, $desc
Local $functionname, $afunctionname, $functionparamlist

	; Change directory to the functions text files
	FileChangeDir(@ScriptDir & "\..\txtlibFunctions")

	;pipe the list of sorted file names to fileList.tmp:
	$templist = @ScriptDir & '\fileList.tmp'
	_RunCmd('dir /b /o:N > "' & $templist & '"')

	$htemplist = FileOpen($templist, 0)  ;read mode
	If $htemplist = -1 Then
		MsgBox(0, "AutoIt", "Error opening temp list.")
		Exit
	EndIf
	
    $filename = FileReadLine($htemplist)
    $bfirst = 1
    While Not @error
		If Not StringInStr($filename, ".txt") Or StringLeft($filename,1) <> "_" Then
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
		$functionparamlist = $functionparamlist & GetParams($filename,$desc, true) & " " & $desc

	

		$bFirst = 0
	    $filename = FileReadLine($htemplist)
    Wend

	; Close and delete templist
	FileClose($htemplist)
	FileDelete($templist)

	; Output the list of functions (LF delimited)
	$houtput = FileOpen(@ScriptDir & '\libfunctions.txt', 2)
	FileWrite($houtput, $functionlist)
	FileClose($houtput)

	; Output the list of functions and params(LF delimited)
	$houtput = FileOpen(@ScriptDir & '\libfunction_params.txt', 2)
	FileWrite($houtput, $functionparamlist)
	FileClose($houtput)
	
	; Reset working directory
	FileChangeDir(@ScriptDir)


EndFunc ;==>some text

;------------------------------------------------------------------------------
; Gets the ###Syntax### entry of a file
;------------------------------------------------------------------------------
Func GetParams($filename, ByRef $desc, $lib=false)

Local $line, $hfile

	$hfile = FileOpen($filename, 0)

	$line = FileReadLine($hfile)
	While Not @error
		If StringInStr($line, "###Description###") Then
			$desc = StringStripWS( FileReadLine($hfile), 3)
			$line = FileReadLine($hfile)
		EndIf
		
		If StringInStr($line, "###Syntax###") Then
			If $lib Then
				$desc &= " (Requires: " & StringStripWS( FileReadLine($hfile), 3) & ")"
			Endif
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

	$hfile = FileOpen("..\..\html\macros.htm", 0)  ;read mode
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
	

			If $bfirst = 0 Then $macrolist = $macrolist & @CRLF
			$macrolist = $macrolist & $line
			
			$bfirst = 0
		EndIf

		$line = FileReadLine($hfile)
	WEnd

	FileClose($hfile)

	; Write the output
	FileDelete("macros.txt")
	FileWrite("macros.txt", $macrolist)

EndFunc



;------------------------------------------------------------------------------
; Run DOS/console commands
;------------------------------------------------------------------------------
Func _RunCmd($command)
    Return RunWait(@ComSpec & " /c " & $command, "", @SW_HIDE)
EndFunc
