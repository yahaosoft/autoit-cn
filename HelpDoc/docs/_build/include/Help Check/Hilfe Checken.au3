#Region ;************ Includes ************
#include <Array.au3>
#include <ArrayMore.au3>
#include <File.au3>
#include <String.au3>
#include <StructureConstants.au3>
#EndRegion ;************ Includes ************

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Hilfe checken
#AutoIt3Wrapper_Res_Fileversion=1.0.0.28
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Author|Tweaky
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Variables must be declared.
Opt("MustDeclareVars", 1)

; Path to the ini file
Global Const $sIni = @ScriptDir & "\" & "Hilfe Checken.ini"
If Not FileExists($sIni) Then
	MsgBox(4112, "Error", "Unable to load file:" & @CRLF & $sIni)
	Exit -1
EndIf

; Language
Global Const $sLangId = IniRead($sIni, "Settings", "Language", 1031)

; Path to the source files (txt)
Global Const $grundpfad_txt_rel = IniRead($sIni, "Settings", "DocSource", "")
If Not FileExists($grundpfad_txt_rel) Then
	MsgBox(4112, "Error", "Invalid directory:" & @CRLF & $grundpfad_txt_rel)
	Exit -2
EndIf

; Path to the source files (html)
Global Const $grundpfad_html_rel = IniRead($sIni, "Settings", "htmlSource", "")
If Not FileExists($grundpfad_html_rel) Then
	MsgBox(4112, "Error", "Invalid directory:" & @CRLF & $grundpfad_html_rel)
	Exit -2
EndIf

; include folder
Global Const $pfad_include = IniRead($sIni, "Settings", "IncludeSource", "")
If Not FileExists($pfad_include) Then
	MsgBox(4112, "Error", "Invalid directory:" & @CRLF & $pfad_include)
	Exit -2
EndIf

Global Const $wort_functions = IniRead($sIni, "Settings", "functions", "")
Global Const $wort_keywords = IniRead($sIni, "Settings", "keywords", "")
Global Const $wort_libfunctions = IniRead($sIni, "Settings", "libfunctions", "")
Global Const $wort_examples = IniRead($sIni, "Settings", "examples", "")
Global Const $wort_libexamples = IniRead($sIni, "Settings", "libexamples", "")
Global Const $wort_txtfunctions = IniRead($sIni, "Settings", "txtfunctions", "")
Global Const $wort_txtlibfunctions = IniRead($sIni, "Settings", "txtlibfunctions", "")
Global Const $wort_txtkeywords = IniRead($sIni, "Settings", "txtkeywords", "")
Global Const $output = IniRead($sIni, "Settings", "Output", "")

Global Const $pfad_1 = $grundpfad_txt_rel & $wort_txtfunctions & "\"
Global Const $pfad_2 = $grundpfad_txt_rel & $wort_txtkeywords & "\"
Global Const $pfad_3 = $grundpfad_txt_rel & $wort_txtlibfunctions & "\"
Global Const $pfad_4 = $grundpfad_txt_rel & $wort_examples & "\"
Global Const $pfad_5 = $grundpfad_txt_rel & $wort_libexamples & "\"

; Load the text string for optional.
Global Const $wort_optional = IniRead($sIni, "Settings", "Optional", "[optional]")

Global $name_funktion_dateiname, $name_funktion_dateiname_merken, $anzahl_fehler, $file

; These variables control which checks are active.	If they are non-empty then
; they contain an error string for that particular test and that test is active.
Global $1 = "", $2 = "", $3 = "", $4 = "", $5 = "", $6 = "", $7 = "", $8 = "", $9 = "", $10 = "", $11 = "", $12 = "", $13 = "", $14 = "", $15 = "", $16 = "", $17 = "", $18 = "", $19 = "", $20 = "", $21 = "", $22 = "", $23 = ""

; This loop iterates each test loading the appropriate string if the test is
; enabled.  The lower and upper bounds of this test should correspond to the
; numbered variables declared above.
For $i = 1 To 23
	If IniRead($sIni, $i, "Enabled", 0) = 1 Then Assign($i, IniRead($sIni, $i, $sLangId, ""))
Next

; following function are not checked if the file name, variables, and variables to match (eg, x and y are separated in the syntax, but it is summarizes in the description)
Global Const $array_auslassen_anz_var[6][3] = [ _
		[0, 0, 0],["Call.txt", 1, 4],["GUICtrlSetGraphic.txt", 2, 4],["MouseClick.txt", 1, 5],["MouseClickDrag.txt", 1, 6], _
		["StringFormat.txt", 1, 3]]

; not looking for certain functions marked "optional" (eg, the syntax is separated x and y, in the description it is combined to one point) (note: this function appears triply in this check script)
Global Const $array_auslassen_optional[5] = [0, "DllCall.txt", "DllCallAddress.txt", "MouseClick.txt", "RegWrite.txt"]

;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************
;************************************************************************************************************************************************************************************************************************************************

If $output = "file" Then $file = FileOpen(@ScriptDir & "\" & "Hilfe Checken Ergebnis.txt", 2)

Global $array_dateien = _FileListToArray($pfad_1, "*.txt", 1) ; basic Functions
_ermitteln($pfad_1)
$array_dateien = _FileListToArray($pfad_2, "*.txt", 1) ; Keywords
_ermitteln($pfad_2)
$array_dateien = _FileListToArray($pfad_3, "*.txt", 1) ; UDFs
_ermitteln($pfad_3)

If $output = "file" Then FileClose($file)

;******************************
; main function
;******************************

Func _ermitteln($pfad)
	Local $array_txt[1]
	For $i = 1 To UBound($array_dateien) - 1
		Local $name = $pfad & $array_dateien[$i] ; complete path of each file
		_FileReadToArray($name, $array_txt) ; Write lines of the file into an array
		Local $anzahl_variablen_ist = 0 ; Number of variables in the function syntax
		Local $array_zaehler = 1 ; number of variables
		Local $zeile_syntax = 0 ; Line in which the syntax is
		Local $zeile_include = 0 ; Line in which the include is
		Local $variable_erledigt = 0 ; necessary, otherwise the error message with the variables is repeatedly
		Local $tabelle_beginn = 0 ; Line in which table begin
		Local $tabelle_ende = 0 ; Line in which table end
		Local $funktion_art = 0 ; Function Headline available?
		Local $syntax = 0 ; Syntax Heading available?
		Local $parameter = 0 ; Parameter Heading available?
		Local $verwandte_funcs = 0 ; Related Headline available?
		Local $beschreibung = 0 ; Description Heading available?
		Local $rueckgabewert = 0 ; ReturnValue Heading available?
		Local $returntable = 0 ; In Returnvalue (###ReturnValue###) there is an @@ReturnTable@@ but at least 1 tabulator is missing
		Local $bemerkungen = 0 ; Remarks Headline available?
		Local $beispiel = 0 ; Example Heading available?
		Local $beispiel_include = 0 ; IncludeExample Heading available?
		$name_funktion_dateiname = StringTrimRight($array_dateien[$i], 4) ; File name without extension

		;*******************************************************************************
		; It is checked whether the word "@@End@@" is included sufficient
		; It is checked whether over the word "@@End@@" is a blank line
		; It is checked whether the link to the file is correct
		;*******************************************************************************
		For $z = 1 To UBound($array_txt) - 1
			Local $link_nicht_onlinefaehig = 0 ; Link online capability?
			If StringInStr($array_txt[$z], '@@ParamTable@@') Or StringInStr($array_txt[$z], '@@ControlCommandTable@@') _
					Or StringInStr($array_txt[$z], '@@StandardTable1@@') Or StringInStr($array_txt[$z], '@@StandardTable@@') _
					Or StringInStr($array_txt[$z], '@@ReturnTable@@') Then $tabelle_beginn += 1
			If StringInStr($array_txt[$z], '@@End@@') Then
				$tabelle_ende += 1
				If $array_txt[$z - 1] = "" Then _log_schreiben($18, "")
			EndIf

			; test links
			If $20 <> "" And StringInStr($array_txt[$z], 'href=') Then
				Local $link_tmp = _StringBetween($array_txt[$z], 'href="', '"') ; Link to filter out
				If IsArray($link_tmp) Then
					Local $link = $link_tmp[0]
					Local $link_ori = $link
					If StringInStr($link, '#') Then ; # if a link contains filter out
						$link_tmp = StringSplit($link, '#')
						$link = $link_tmp[1]
					EndIf

					Local $grundpfad_html_abs = _PathFull($grundpfad_html_rel)

					If Not StringInStr($link, "\") And Not StringInStr($link, "/") Then
						If StringInStr($pfad, $wort_txtfunctions) Then
							$link = $grundpfad_html_abs & $wort_functions & "\" & $link ; set new path
						ElseIf StringInStr($pfad, $wort_txtkeywords) Then
							$link = $grundpfad_html_abs & $wort_keywords & "\" & $link ; set new path
						ElseIf StringInStr($pfad, $wort_txtlibfunctions) Then
							$link = $grundpfad_html_abs & $wort_libfunctions & "\" & $link ; set new path
						EndIf
					Else
						$link = StringReplace($link, "../", $grundpfad_html_abs) ; set new path
						$link = StringReplace($link, "..\..\..\docs\autoit\english\html\", $grundpfad_html_abs) ; set new path
						$link = StringReplace($link, "..\", $grundpfad_html_abs) ; set new path
					EndIf

					If Not StringInStr($link_ori, 'http://') Then
						If Not FileExists($link) Then
							_log_schreiben($20, $link) ; Link errors
						EndIf

						Local $szDrive, $szDir, $szFName, $szExt
						Local $TestPath = _PathSplit($link, $szDrive, $szDir, $szFName, $szExt)
						Local $h_file = FileFindNextFile(FileFindFirstFile($link))

						If FileExists($link) Then
							If $h_file == $TestPath[3] & $TestPath[4] Then
								; Capital and lowercase fit
							Else
								; Capital and lowercase does not fit
								$link_nicht_onlinefaehig = 1
							EndIf
						EndIf

						If $link_nicht_onlinefaehig = 1 Then _log_schreiben($21, $link_ori) ; Link works not online (maybe you used \ instead of / or casesense is not ok)
					EndIf
				Else
					_log_schreiben($22, $array_txt[$z]) ; Link badly formatted
				EndIf
			EndIf
		Next

		Local $anzahl_variablen_soll

		For $z = 1 To UBound($array_txt) - 1

			;*******************************************************************************
			; It is checked whether the return value (###ReturnValue###) with @@ReturnTable@@ tabs missing
			;*******************************************************************************
			If $rueckgabewert = 1 Then
				If $returntable = 1 Or $array_txt[$z] = "@@ReturnTable@@" Then
					$returntable = 1
					If $array_txt[$z] = "@@End@@" Then
						$returntable = 0
					ElseIf ($array_txt[$z] <> "@@ReturnTable@@") And ($array_txt[$z] <> "") And (Not StringInStr($array_txt[$z], @TAB)) Then
						_log_schreiben($23, "") ; In Returnvalue (###ReturnValue###) there is an @@ReturnTable@@ but at least 1 tabulator is missing
						$returntable = 0
					EndIf
				EndIf
			EndIf

			;*******************************************************************************
			; Detect function name
			;*******************************************************************************
			If $array_txt[$z] = "###Structure Name###" Or $array_txt[$z] = "###User Defined Function###" Or $array_txt[$z] = "###Keyword###" Or $array_txt[$z] = "###Function###" Or $array_txt[$z] = "###Macro###" Or $array_txt[$z] = "###Operator###" Then
				$funktion_art = 1 ; Heading to the function name exists
				If Not StringInStr($pfad, $wort_txtkeywords) Then ; if no keywords function
					$z += 1

					Local $split = StringSplit($array_txt[$z], ", ", 1)
					If UBound($split) = 2 Then ; If the function name is only one function
						Local $name_funktion_inhalt = $array_txt[$z]
						If $name_funktion_inhalt <> $name_funktion_dateiname Then _log_schreiben($1, "") ; Function name in ###Function### wrong
					ElseIf UBound($split) > 2 Then ; are separated by comma if two functions in the Function Name
						Local $funktion_ok = 0
						For $o = 1 To UBound($split) - 1
							If $split[$o] = $name_funktion_dateiname Then
								$funktion_ok = 1
								ExitLoop
							EndIf
						Next
						If $funktion_ok = 0 Then _log_schreiben($1, "") ; Function name in ###Function### wrong
					EndIf
				EndIf

				;*******************************************************************************
				; Determine the line in which the word syntax is
				; Line in the first include is
				;*******************************************************************************
			ElseIf $array_txt[$z] = "###Syntax###" Then
				$syntax = 1 ; Heading to the syntax is available
				Local $zeile_syntax_wort = $z ; The line in which the word syntax is
				Do
					$z += 1
				Until Not StringInStr($array_txt[$z], "#Include")

				$zeile_syntax = $z ; The line in which the syntax is
				If $zeile_syntax_wort + 1 = $zeile_syntax Then
					$zeile_include = "kein Include" ; Line in the first include is
				Else
					$zeile_include = $zeile_syntax_wort + 1 ; Line in the first include is
				EndIf

				$z = $zeile_syntax_wort ; Reset line again

				;*******************************************************************************
				; Check function name in the syntax
				;*******************************************************************************
			ElseIf $z = $zeile_syntax Then
				If Not StringInStr($pfad, $wort_txtkeywords) Then ; if no keywords function
					Local $syntax_klammer
					If StringInStr($array_dateien[$i], "$tag") Then ; at $tag functions
						$syntax_klammer = StringInStr($array_txt[$z], "=") ; delimiter
					Else ; in other functions
						$syntax_klammer = StringInStr($array_txt[$z], "(") ; delimiter
					EndIf
					Local $syntax_funktion = StringLeft($array_txt[$z], $syntax_klammer - 1)
					Local $syntax_variablen = StringTrimLeft($array_txt[$z], $syntax_klammer) ; 1 at $tag functions Line syntax right side (only variables)
					$syntax_funktion = StringReplace($syntax_funktion, 'Global Const ', '') ; at $tag functions

					$syntax_funktion = StringStripWS($syntax_funktion, 3) ; Remove spaces at the beginning and end

					If $syntax_funktion <> $name_funktion_dateiname Then _log_schreiben($2, "") ; Function name in the syntax wrong

					;*******************************************************************************
					; Identify variables in syntax
					; Check which variable in the syntax is optional
					;*******************************************************************************
					Local $exp_tmp
					Local $nur_var[1]

					If StringInStr($array_dateien[$i], "$tag") Then ; at $tag functions
						Local $verbinden = 0
						Local $var_tmp = 0

						Do ; necessary because the syntax is sometimes in multiple lines
							Local $array_tmp = $array_txt[$z]

							$nur_var[0] = $syntax_variablen
							If $verbinden = 1 Then ; necessary if the syntax is in multiple rows
;~ 								$nur_var = _StringBetween($array_tmp, '"', '"')
								$nur_var[0] = StringStripWS($array_tmp, 1)
								$nur_var[0] = $var_tmp & $nur_var[0]
							EndIf

							If StringRight($array_txt[$z], 1) = '_' Then
								$verbinden = 1
								$z += 1
								$var_tmp = $nur_var[0]
								$var_tmp = StringTrimRight($var_tmp, 1)
							Else
								ExitLoop
							EndIf
						Until Not StringRight($array_txt[$z], 1) = '_' ; not until the line "_" is closing, which means that the end of the syntax and is not continued on the next line

						$nur_var[0] = StringReplace($nur_var[0], '; endstruct', "")
						$nur_var[0] = StringReplace($nur_var[0], ';endstruct', "")
						$nur_var[0] = StringReplace($nur_var[0], '"struct;" & ', "")
						$nur_var[0] = StringReplace($nur_var[0], 'struct; ', "")
						$nur_var[0] = StringReplace($nur_var[0], 'struct;', "")
						$nur_var[0] = StringReplace($nur_var[0], 'struct ;', " ")
						$nur_var[0] = StringReplace($nur_var[0], ';handle ', "; ")
						$nur_var[0] = StringRegExpReplace($nur_var[0], '(align \d+;)', "")
						$nur_var[0] = StringReplace($nur_var[0], ';lparam ', "; ")
						$nur_var[0] = StringRegExpReplace($nur_var[0], '(\[\d+\])', "")

						$exp_tmp = StringSplit($nur_var[0], ";")
					Else ; in other functions
						Local $entf = $array_txt[$z]
						$entf = StringReplace($entf, "]", "")
						$nur_var = _StringBetween($entf, "(", ")")
						If IsArray($nur_var) Then
							If StringRight($nur_var[0], 1) = " " Then $nur_var[0] = StringTrimRight($nur_var[0], 1)
						Else
							Dim $nur_var[1]
						EndIf
						$exp_tmp = StringSplit($nur_var[0], ",")
					EndIf

					; separate complete syntax and write into an array
					If IsArray($exp_tmp) Then
						Local $array_var_syn[UBound($exp_tmp)][2]
						For $b = 0 To UBound($exp_tmp) - 1
							$exp_tmp[$b] = StringReplace($exp_tmp[$b], '"', "")
							If StringInStr($exp_tmp[$b], "[") And StringInStr($exp_tmp[$b], "]") Then $exp_tmp[$b] = StringRegExpReplace($exp_tmp[$b], '[\[]+[\d]+[\]]', "") ; replace, for example, [16]

							$exp_tmp[$b] = StringStripWS($exp_tmp[$b], 1) ; Remove spaces from the beginning

							If StringInStr($exp_tmp[$b], "[") = 1 Then ; [ find in the first place
								$array_var_syn[$b][0] = StringReplace($exp_tmp[$b], "[", "") ; Parameter
								$array_var_syn[$b][1] = "optional" ; Parameter is optional
							EndIf

							If StringInStr($exp_tmp[$b], "[", 1, 1, 2) Then ; [ found at any point
								$array_var_syn[$b][0] = StringReplace($exp_tmp[$b], "[", "") ; Parameter
								$array_var_syn[$b + 1][1] = "optional" ; Parameter is optional
							ElseIf Not StringInStr($exp_tmp[$b], "[") Then ; without [
								$array_var_syn[$b][0] = $exp_tmp[$b] ; Parameter
							EndIf
							If $b = 0 Then $array_var_syn[$b][0] = $exp_tmp[0] ; Parameter

							$array_var_syn[$b][0] = StringStripWS($array_var_syn[$b][0], 1) ; Remove spaces from the beginning

							Local $pos_trim = StringInStr($array_var_syn[$b][0], "=")
							If $pos_trim > 0 Then $array_var_syn[$b][0] = StringLeft($array_var_syn[$b][0], $pos_trim - 1)
							$array_var_syn[$b][0] = StringRegExpReplace($array_var_syn[$b][0], '(ByRef)|(Const)', "") ; Remove everything in the brackets

							If StringInStr($array_dateien[$i], "$tag") Then ; at $tag functions
								$array_var_syn[$b][0] = StringRegExpReplace($array_var_syn[$b][0], '(?<!tagPO)(INT )|(uint_ptr )|(uint )|(UINT )|(int64 )|(int )|(int_ptr )|(ulong_ptr )|(dword_ptr )|(ptr )|(handle )|(dword )|(word )|(bool )|(long )|(ulong )|(ushort )|(short )|(ubyte )|(byte )|(hwnd )|(float )|(lparam )|(wchar )|(char )|(& _)|(& )|( & )', "") ; remove everything in the brackets
							EndIf

							$array_var_syn[$b][0] = StringStripWS($array_var_syn[$b][0], 3) ; Remove spaces at the beginning and end
						Next

						$anzahl_variablen_soll = UBound($array_var_syn) - 1 ; Includes the syntax (set)
					Else
						$anzahl_variablen_soll = 0 ; Includes the syntax (set)
					EndIf
				EndIf

				;*******************************************************************************
				; checks whether the includes the syntax shown in the also exist
				;*******************************************************************************
			ElseIf $z = $zeile_include Then
				If Not StringInStr($pfad, $wort_txtkeywords) Then ; if no keywords function
					Do
						If StringInStr($array_txt[$z], "#Include") Then
							Local $include_between = _StringBetween($array_txt[$z], "<", ">")
							If IsArray($include_between) Then
								If Not FileExists($pfad_include & $include_between[0]) Then _log_schreiben($3, "") ; specified include file does not exist							EndIf
							EndIf
						EndIf
						$z += 1
					Until Not StringInStr($array_txt[$z], "#Include")
					$z -= 1
				EndIf

				;******************************************************************************************************************
				; Variables in the description identify (is), and this with the variables in syntax (to) compare
				; Check which variable in the description is optional and compare this with the variables in the syntax
				;******************************************************************************************************************
			ElseIf $variable_erledigt = 0 And $array_txt[$z] = "@@ParamTable@@" Then
				$variable_erledigt = 1 ; necessary, otherwise the error message with the variables is repeatedly
				Local $variable_optional = 0 ; Reset the check of the word "[Optional]"

				If Not StringInStr($pfad, $wort_txtkeywords) Then ; if no keywords function
					Local $array_txt_temp
					$array_txt_temp = $array_txt
					Do
						$z += 1
						If $array_zaehler < UBound($array_var_syn) Then
							$array_txt[$z] = StringRegExpReplace($array_txt[$z], '(ByRef)|(\()|(\))|(\	)|(\")', "") ; Remove everything in the brackets
							$array_txt[$z] = StringStripWS($array_txt[$z], 3) ; Remove spaces at the beginning and end

							If $array_txt[$z] = $array_var_syn[$array_zaehler][0] Then ; Variable and the syntax of variable declaration is consistent
								$z += 1
								If $array_var_syn[$array_zaehler][1] = "optional" And Not StringInStr($array_txt[$z], $wort_optional) Then ; Syntax = optional		Description = not optional
									_ArraySearch($array_auslassen_optional, $array_dateien[$i], 1)
									If @error Then ; "optional" are not looking for certain things (eg, x, y)
										$variable_optional = 1
										$array_txt_temp[$z] = _StringInsert($array_txt_temp[$z], $wort_optional & " ", 1) ; optional and insert spaces at the beginning
									EndIf
								ElseIf Not $array_var_syn[$array_zaehler][1] = "optional" And StringInStr($array_txt[$z], $wort_optional) Then ; Syntax = not optional		Description = optional
									_ArraySearch($array_auslassen_optional, $array_dateien[$i], 1)
									If @error Then ; "optional" are not looking for certain things (eg, x, y)
										$variable_optional = 1
									EndIf
								EndIf
								$array_zaehler += 1
								$anzahl_variablen_ist += 1
							EndIf

						Else
							$array_txt[$z] = "@@End@@"
						EndIf

					Until $array_txt[$z] = "@@End@@"

					; If a mandatory parameter to an optional parameter follows
					For $d = 2 To UBound($array_var_syn) - 1
						If $array_var_syn[$d][1] <> $array_var_syn[$d - 1][1] And $array_var_syn[$d][1] = "" Then
							_ArraySearch($array_auslassen_optional, $array_dateien[$i], 1)
							If @error Then $variable_optional = 1 ; "optional" are not looking for certain things (eg, x, y)
						EndIf
					Next

					If $variable_optional = 1 Then _log_schreiben($19, "") ; The word "[optional]" is missing, has been misspelled or is unnecessary in the description (at least one variable)

					If $anzahl_variablen_ist <> $anzahl_variablen_soll Then ; different variables
						Local $auslassen = 0 ; Reset omit a function

						For $e = 1 To UBound($array_auslassen_anz_var) - 1
							If $array_dateien[$i] = $array_auslassen_anz_var[$e][0] And $anzahl_variablen_ist = $array_auslassen_anz_var[$e][1] And $anzahl_variablen_soll = $array_auslassen_anz_var[$e][2] Then $auslassen = 1
						Next
						If $auslassen = 0 Then _log_schreiben($4, $anzahl_variablen_ist & " | " & $anzahl_variablen_soll) ; Number of variables / variable differently written / variables in a different order
					EndIf
				EndIf

				;******************************************************************************************************************
				; The following functions exist in the related functions
				; The link to at least a related function is duplicated
				;******************************************************************************************************************
			ElseIf $array_txt[$z] = "###Related###" Then
				$verwandte_funcs = 1 ; Heading over to the related functions is available
				$z += 1
				If $z <= UBound($array_txt) - 1 Then ; otherwise, an error occurs if, after "Related" there is no row
					Local $split_tmp = StringSplit($array_txt[$z], ", ", 1)

					If IsArray($split_tmp) Then
						For $h = 1 To UBound($split_tmp) - 1
							If StringLeft($split_tmp[$h], 1) = '.' Then $split_tmp[$h] = StringTrimLeft($split_tmp[$h], 1) ; have some function, remove a point before this
							If $split_tmp[$h] <> "" And Not StringInStr($split_tmp[$h], "(Option)") And Not StringInStr($split_tmp[$h], "Nichts") And Not StringInStr($split_tmp[$h], "Keine") And Not StringInStr($split_tmp[$h], "None") And Not StringInStr($split_tmp[$h], "Many") And Not StringInStr($split_tmp[$h], "Viele") And Not StringInStr($split_tmp[$h], "AutoItRelated") And Not StringInStr($split_tmp[$h], "AutoItSetOption") Then
;~ 								If StringInStr($array_dateien[$i], "guicrea") Then _ArrayDisplay($split_tmp)
								If StringInStr($split_tmp[$h], 'href') Then ; a link
									Local $split_tmp_bet = _StringBetween($split_tmp[$h], '"', '.htm')
									If IsArray($split_tmp_bet) Then $split_tmp[$h] = $split_tmp_bet[0]
									Local $split_tmp2 = StringSplit($split_tmp[$h], "/")
									If IsArray($split_tmp2) Then $split_tmp[$h] = $split_tmp2[UBound($split_tmp2) - 1]
									Local $split_tmp3 = StringSplit($split_tmp[$h], "\")
									If IsArray($split_tmp3) Then $split_tmp[$h] = $split_tmp3[UBound($split_tmp3) - 1]
								EndIf

								If Not StringInStr($split_tmp[$h], '..') And Not FileExists($pfad_1 & $split_tmp[$h] & ".txt") And Not FileExists($pfad_2 & $split_tmp[$h] & ".txt") And Not FileExists($pfad_3 & $split_tmp[$h] & ".txt") Then _log_schreiben($5, "")
							EndIf
						Next

						Local $array_doppelt = _Array2DDblDel($split_tmp, 0) ; find duplicate functions
						If $array_doppelt = 1 And Not $array_dateien[$i] = "func.txt" Then _log_schreiben($6, "") ; dual capture (Func miss because it is willed there)
						Local $array_gleiche_funktion = _ArraySearch($split_tmp, $name_funktion_dateiname)
						If $array_gleiche_funktion <> -1 Then _log_schreiben($7, "") ; Related function equal to the current function
					EndIf
				EndIf

				;******************************************************************************************************************
				; Description Heading available?
				; Parameters Heading available?
				; ReturnValue Heading available?
				; Remarks Headline available?
				; Example Heading available?
				; IncludeExample Heading available?
				;******************************************************************************************************************
			ElseIf $array_txt[$z] = "###Description###" Then
				$beschreibung = 1 ; Headline of the Description is available
			ElseIf $array_txt[$z] = "###Parameters###" Or $array_txt[$z] = "###Fields###" Then
				$parameter = 1 ; Headline about the Parameters is available
			ElseIf $array_txt[$z] = "###ReturnValue###" Then
				$rueckgabewert = 1 ; Heading over to the ReturnValue is available
			ElseIf $array_txt[$z] = "###Remarks###" Then
				$bemerkungen = 1 ; Heading over to the Remarks is available
			ElseIf $array_txt[$z] = "###Example###" Then
				$beispiel = 1 ; Heading to the Example is available
			ElseIf $array_txt[$z] = "@@IncludeExample@@" Then
				$beispiel_include = 1 ; Heading to the IncludeExample is available
			EndIf
		Next

		;******************************************************************************************************************
		; Function Heading available?
		; Description Heading available?
		; Syntax Heading available?
		; Parameters Heading available?
		; ReturnValue Heading available?
		; Remarks Headline available?
		; Related Headline available?
		;******************************************************************************************************************
		If StringInStr($array_dateien[$i], '$tag') Then ; simulate some headlines as available for $tag-functions
			$rueckgabewert = 1 ; ReturnValue does not exist in the $tag-functions
			$verwandte_funcs = 1 ; Related does not exist in the $tag-functions
			$beispiel = 1 ; Example does not exist in the $tag-functions
			$beispiel_include = 1 ; IncludeExample does not exist in the $tag-functions
		Else
			If (Not FileExists($pfad_4 & $name_funktion_dateiname & ".au3") And Not FileExists($pfad_5 & $name_funktion_dateiname & ".au3")) And ($beispiel = 1 And $beispiel_include = 1) Then
				_log_schreiben($8, "") ; Entry exists for the example / sample file is missing
			ElseIf (FileExists($pfad_4 & $name_funktion_dateiname & ".au3") Or FileExists($pfad_5 & $name_funktion_dateiname & ".au3")) And ($beispiel = 0 Or $beispiel_include = 0) Then
				_log_schreiben($9, "") ; Example entry for the missing / example file exists
			EndIf
		EndIf

		If StringInStr($pfad, $wort_txtkeywords) Then $rueckgabewert = 1 ; when keywords function

		If $tabelle_beginn <> $tabelle_ende Then _log_schreiben($10, "") ; Number of @@End@@ mismatch

		If $funktion_art = 0 Then _log_schreiben($11, "") ; Heading for type of function is missing (###Function###)
		If $beschreibung = 0 Then _log_schreiben($12, "") ; Heading for missing description (###Description###)
		If $syntax = 0 Then _log_schreiben($13, "") ; Heading for missing syntax (###Syntax###)
		If $parameter = 0 Then _log_schreiben($14, "") ; Heading for missing parameters (###Parameters###)
		If $rueckgabewert = 0 Then _log_schreiben($15, "") ; Heading for the return value is missing (###ReturnValue###)
		If $bemerkungen = 0 Then _log_schreiben($16, "") ; Heading for missing observations (###Remarks###)
		If $verwandte_funcs = 0 Then _log_schreiben($17, "") ; Heading for Related function missing (###Related###)

	Next
EndFunc   ;==>_ermitteln

;*********************************************************
; send all the errors to the Console
;*********************************************************
Func _log_schreiben($text, $zusatz)
	Local $line
	If $text <> "" Then ; If this parameter is blank, nothing is written (this is useful if only a certain error should be sought)
		If $name_funktion_dateiname <> $name_funktion_dateiname_merken Then $anzahl_fehler += 1
		If $zusatz = "" Then
			$line = $anzahl_fehler & @TAB & $name_funktion_dateiname & @TAB & @TAB & $text & @CRLF
			If $output = "file" Then
				FileWrite($file, $line) ; Write error to a file
			Else
				ConsoleWrite($line) ; Write error to the Console
			EndIf
		Else
			$line = $anzahl_fehler & @TAB & $name_funktion_dateiname & @TAB & @TAB & $text & @TAB & $zusatz & @CRLF
			If $output = "file" Then
				FileWrite($file, $line) ; Write error to a file
			Else
				ConsoleWrite($line) ; Write error to the Console
			EndIf
		EndIf
		$name_funktion_dateiname_merken = $name_funktion_dateiname
	EndIf
EndFunc   ;==>_log_schreiben
