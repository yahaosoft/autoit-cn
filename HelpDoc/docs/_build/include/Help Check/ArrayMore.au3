;----------------------------------------------------------------------------------------------------------------------
;									Sammlung von Array-UDF
;
;	Enthaltene Funktionen:
;
;	_ArraySort_2ary()
;		sortiert 2D Arrays mehrstufig
;
;	_Array2DSortByLen()
;		sortiert 1D/2D Arrays nach Länge der Einträge
;
;	_ArraySortDblDel()    ** Funktion auskommentiert - siehe Funktionskopf
;		sortiert 1D/2D Arrays und entfernt doppelte Einträge
;		in 2.ter Dimension begrenzt auf 2 Vorkommen
;
;	_Array2DDblDel()
;		entfernt doppelte Einträge in 1D/2D Arrays
;
;   _Array2DAdd()
;       fügt einen Eintrag einem 1D/2D-Array hinzu
;       Spaltenwerte in 2D-Arrays sind durch '|' zu trennen
;       wird die Funktion ohne Wertübergabe aufgerufen, wird die Arraygröße um 1 erhöht
;
;	_Array2DInsert()
;		fügt 1 Element (leer oder mit Daten) an gegebener Position ein
;		arbeitet mit 1D/2D Arrays
;
;	_Array2DSplit()
;		splittet 1D/2D Arrays ab gegebener Position in 2 Arrays
;		optional wird eine Anzahl Elemente in ein Zielarray exportiert
;
;	_Array2DEmptyDel()
;		löscht leere Zeilen, in 2D Arrays Zeilen oder optional Spalten
;
;	_Array2DJoin()
;		verbindet 2 Arrays zu einem, 1D/2D -Arrays, auch untereinander
;		Größe der 2.ten Dimension muß nicht übereinstimmen
;
;	_Array2DDelete()
;		löscht eine Zeile aus einem 1D/2D -Array am gegebenen ZeilenIndex
;
;	_Array2DSearch()
;		sucht nach allen oder einmaligem Auftreten des Suchbegriffs in einem 1D/2D -Array
;		ein Array mit dem/den gefundenen Index(es) wird zurückgeliefert
;
;	_Array2DMirror()
;		spiegelt ein 2D-Array, Zeilen werden zu Spalten und umgekehrt
;
;	_SubArrayGetEntry()
;		gibt den Wert eines Elements aus einem 1D/2D-Array als Element eines 1D/2D-Arrays zurück
;
;	_SubArraySetEntry()
;		setzt den Wert eines Elements in einem 1D/2D-Array als Element eines 1D/2D-Arrays
;
;	_Array2DSortByCountSameEntries()
;		sortiert ein Array nach der Anzahl gleicher Elemente, bei 2D für eine angegebene Spalte
;
;   _Array2DPop()
;       gibt den letzten Wert eines 1D/2D-Arrays zurück und löscht ihn gleichzeitig vom Array
;
;  _Array2DPush()
;       fügt Einzelwerte oder Arrays in 1D/2D-Arrays ein ohne deren Größe zu verändern
;       es kann vom Anfang oder vom Ende eingefügt werden, überzählige Elemente werden 'herausgeschoben'
;
;----------------------------------------------------------------------------------------------------------------------
#include <Array.au3>
;----------------------------------------------------------------------------------------------------------------------
;	Function		_ArraySort_2ary(ByRef $ARRAY [, $DIM_1ST=0 [, $DESCENDING=0 [$REVERSE=False]]])
;
;	Description		sort an 2D-Array 2-ary
;					BaseIndex is 0
;					sort the whole array
;
;	Parameter		$ARRAY:			Array to sort
;		optional	$DIM_1ST:		MainSortIndex; 1st Dim. [0] or last occurence in 2nd Dim.[all other values] (default 0)
;		optional	$DESCENDING:	Sort ascending[0]/descending[1] (default 0)
;		optional	$REVERSE:		Sort 2nd Dimension reverse to 1st Dimension (default False)
;
;	Return			Succes			-1		ByRef 2-ary sorted Array
;					Failure			0  		set @error
;									@error = 1 	given array is not array
;									@error = 2 	given array has only 1 dimension
;
;	Requirements	By using numeric entry, be sure that type is "number" for correct sort
;					Works with any occurences in 2nd Dimension
;
;	Author			BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _ArraySort_2ary(ByRef $ARRAY, $DIM_1ST = 0, $DESCENDING = 0, $REVERSE = False)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	Local $FIRST = 0, $LAST, $tmpFIRST, $sortYES = 0, $u, $i
	Local $UBound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		SetError(2)
		Return 0
	EndIf
	If $DIM_1ST <> 0 Then $DIM_1ST = $UBound2nd - 1
	Local $arTmp[1][$UBound2nd]
	_ArraySort($ARRAY, $DESCENDING, 0, 0, $DIM_1ST)
	If $REVERSE Then
		Switch $DESCENDING
			Case 0
				$DESCENDING = 1
			Case 1
				$DESCENDING = 0
		EndSwitch
	EndIf
	For $u = 0 To $UBound2nd - 1
		For $i = 0 To UBound($ARRAY) - 1
			If $sortYES = 0 Then
				If $u > 0 Then
					If ($i < UBound($ARRAY) - 1) And ($ARRAY[$i][$u] = $ARRAY[$i + 1][$u]) And _
							($ARRAY[$i][$u - 1] = $ARRAY[$i + 1][$u - 1]) Then
						$sortYES = 1
						$FIRST = $i
					EndIf
				Else
					If ($i < UBound($ARRAY) - 1) And ($ARRAY[$i][$u] = $ARRAY[$i + 1][$u]) Then
						$sortYES = 1
						$FIRST = $i
					EndIf
				EndIf
			ElseIf $sortYES = 1 Then
				If ($i = UBound($ARRAY) - 1) Or ($ARRAY[$i][$u] <> $ARRAY[$i + 1][$u]) Then
					$sortYES = 0
					$LAST = $i + 1
					ReDim $arTmp[$LAST - $FIRST][$UBound2nd]
					$tmpFIRST = $FIRST
					For $k = 0 To UBound($arTmp) - 1
						For $l = 0 To $UBound2nd - 1
							$arTmp[$k][$l] = $ARRAY[$tmpFIRST][$l]
						Next
						$tmpFIRST += 1
					Next
					$tmpFIRST = $FIRST
					Switch $DIM_1ST
						Case 0
							If $u = $UBound2nd - 1 Then
								_ArraySort($arTmp, $DESCENDING, 0, 0, $UBound2nd - 1)
							Else
								_ArraySort($arTmp, $DESCENDING, 0, 0, $u + 1)
							EndIf
							For $k = 0 To UBound($arTmp) - 1
								For $l = 1 To $UBound2nd - 1
									$ARRAY[$tmpFIRST][$l] = $arTmp[$k][$l]
								Next
								$tmpFIRST += 1
							Next
						Case $UBound2nd - 1
							If $u = $UBound2nd - 1 Then
								_ArraySort($arTmp, $DESCENDING, 0, 0, 0)
							Else
								_ArraySort($arTmp, $DESCENDING, 0, 0, $UBound2nd - 1 - $u - 1)
							EndIf
							For $k = 0 To UBound($arTmp) - 1
								For $l = 0 To $UBound2nd - 2
									$ARRAY[$tmpFIRST][$l] = $arTmp[$k][$l]
								Next
								$tmpFIRST += 1
							Next
					EndSwitch
				EndIf
			EndIf
		Next
		$sortYES = 0
	Next
	Return -1
EndFunc   ;==>_ArraySort_2ary
;----------------------------------------------------------------------------------------------------------------------
; Function		_Array2DSortByLen(ByRef $ARRAY [, $iDESCENDING=0])
;
; Description	- Sorts an 1D/2D Array by Length.
;				- BaseIndex is 0; sorts the whole array.
;
; Parameter		$ARRAY:			Array to sort
;	optional	$iDESCENDING:	Sort ascending[0]/descending[1] (default 0)
;
; Return		Succes			-1	ByRef sorted Array by Length
;				Failure			0	set @error = 1; no array
;
; Requirements	Func _ArraySort_2ary()
;				#include <array.au3>
;
; Author		BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DSortByLen(ByRef $ARRAY, $iDESCENDING = 0)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	If $iDESCENDING <> 0 Then $iDESCENDING = 1
	Local $i, $k
	Local $UBound2nd = UBound($ARRAY, 2)
	Local $arTmp[1] = ['']
	If @error = 2 Then
		ReDim $arTmp[UBound($ARRAY)][2]
		For $i = 0 To UBound($ARRAY) - 1
			$arTmp[$i][0] = StringLen($ARRAY[$i])
			$arTmp[$i][1] = $ARRAY[$i]
			$ARRAY[$i] = ''
		Next
		_ArraySort($arTmp, $iDESCENDING, 0, 0, 0)
		For $i = 0 To UBound($arTmp) - 1
			$ARRAY[$i] = $arTmp[$i][1]
		Next
	Else
		ReDim $arTmp[UBound($ARRAY)][$UBound2nd + 1]
		For $i = 0 To UBound($ARRAY) - 1
			For $k = 0 To $UBound2nd - 1
				$arTmp[$i][$k] = StringLen($ARRAY[$i][$k])
			Next
			$arTmp[$i][$UBound2nd] = $i
		Next
		_ArraySort_2ary($arTmp, 0, $iDESCENDING)
		For $i = 0 To UBound($arTmp) - 1
			For $k = 0 To $UBound2nd - 1
				$arTmp[$i][$k] = $ARRAY[$arTmp[$i][$UBound2nd]][$k]
			Next
		Next
		ReDim $arTmp[UBound($ARRAY)][$UBound2nd]
		$ARRAY = $arTmp
	EndIf
	Return -1
EndFunc   ;==>_Array2DSortByLen

;----------------------------------------------------------------------------------------------------------------------
; Function		_Array2DDblDel(ByRef $ARRAY [, $CASESENS=0])
;
; Description	- From an 1D/2D Array will delete double entries (2D -> combination by '[n][0]' to '[n][x]').
;				- Autodetection 1D/2D Array
;				- By using string, you can choose case sensitivity.
;
; Parameter		$ARRAY:			Array to sort
;	optional	$CASESENS:		Case sensitivity off[0] or on[1] (default 0)
;
; Return		Succes			ByRef Array without doubles
;								Count of doubles
;				Failure			0 and set @error = 1; no array
;
; Author		BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DDblDel(ByRef $ARRAY, $CASESENS = 0)
	Local $arTmp[1] = [''], $dbl = 0, $count = 0, $x, $l, $val, $valTmp, $i, $k
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	Local $UBound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		For $i = 0 To UBound($ARRAY) - 1
			$dbl = 0
			For $k = 0 To UBound($arTmp) - 1
				Switch $CASESENS
					Case 0
						If $arTmp[$k] = $ARRAY[$i] Then
							$dbl = 1
							$count += 1
						EndIf
					Case 1
						If $arTmp[$k] == $ARRAY[$i] Then
							$dbl = 1
							$count += 1
						EndIf
				EndSwitch
			Next
			If $dbl = 0 Then
				If $arTmp[0] = "" Then
					$arTmp[0] = $ARRAY[$i]
				Else
					ReDim $arTmp[UBound($arTmp) + 1]
					$arTmp[UBound($arTmp) - 1] = $ARRAY[$i]
				EndIf
			Else
				$dbl = 0
			EndIf
		Next
	Else
		ReDim $arTmp[1][$UBound2nd]
		$arTmp[0][0] = ''
		$x = 0
		For $i = 0 To UBound($ARRAY) - 1
			$dbl = 0
			$val = ''
			$valTmp = ''
			For $l = 0 To $UBound2nd - 1
				$val &= $ARRAY[$i][$l]
			Next
			For $k = 0 To UBound($arTmp) - 1
				For $l = 0 To $UBound2nd - 1
					$valTmp &= $arTmp[$k][$l]
				Next
				Switch $CASESENS
					Case 0
						If $valTmp = $val Then
							$dbl = 1
							$count += 1
						EndIf
					Case 1
						If $valTmp == $val Then
							$dbl = 1
							$count += 1
						EndIf
				EndSwitch
				$valTmp = ''
			Next
			If $dbl = 0 Then
				If $x = 1 Then ReDim $arTmp[UBound($arTmp) + 1][$UBound2nd]
				For $l = 0 To $UBound2nd - 1
					If $arTmp[0][0] = '' Or $x = 0 Then
						$arTmp[0][$l] = $ARRAY[0][$l]
						If $l = $UBound2nd - 1 Then $x = 1
					Else
						$arTmp[UBound($arTmp) - 1][$l] = $ARRAY[$i][$l]
						$x = 2
						If $l = $UBound2nd - 1 Then $x = 1
					EndIf
				Next
			Else
				$dbl = 0
			EndIf
		Next
	EndIf
	$ARRAY = $arTmp
	Return $count
EndFunc   ;==>_Array2DDblDel

;------------------------------------------------------------------------------------------------------------
;
;	Function		_Array2DAdd(ByRef $avArray, $sValue='')
;
;	Description		Redim Array Size and add an Array element at last position
;					Works with any occurences in 2nd Dimension
;					Works also with 1D-Array
;
;	Parameter		$avArray	Given Array
;		optional	$sValue		Value of new Element, parts must be seperate with '|'
;
;	Return			Succes		-1
;					Failure		0 and set @error
;								@error = 1	given array is not array
;								@error = 2	given parts of Element too less/much
;
;	Author			BugFix  (bugfix@autoit.de)
;------------------------------------------------------------------------------------------------------------
Func _Array2DAdd(ByRef $avArray, $sValue = '')
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	Local $i
	Local $UBound2nd = UBound($avArray, 2)
	If @error = 2 Then
		ReDim $avArray[UBound($avArray) + 1]
		$avArray[UBound($avArray) - 1] = $sValue
	Else
		Local $arValue
		ReDim $avArray[UBound($avArray) + 1][$UBound2nd]
		If $sValue = '' Then
			For $i = 0 To $UBound2nd - 2
				$sValue &= '|'
			Next
		EndIf
		$arValue = StringSplit($sValue, '|')
		If $arValue[0] <> $UBound2nd Then
			SetError(2)
			Return 0
		EndIf
		For $i = 0 To $UBound2nd - 1
			$avArray[UBound($avArray) - 1][$i] = $arValue[$i + 1]
		Next
	EndIf
	Return -1
EndFunc   ;==>_Array2DAdd

;------------------------------------------------------------------------------------------------------------
;
;	Function		_Array2DInsert(ByRef $avArray, $iElement [, $sValue=''])
;
;	Description		Insert an Array element on a given position
;					Works with any occurences in 2nd Dimension
;					Works also with 1D-Array
;
;	Parameter		$avArray	Given Array
;					$iElement	0-based Array Index, to insert new Element
;		optional	$sValue		Value of new Element, parts must be seperate with '|'
;
;	Return			Succes		-1
;					Failure		0 	set @error
;								@error = 1	given array is not array
;								@error = 2	given parts of Element too less/much
;								@error = 3	$iElement larger then Ubound
;
;	Author			BugFix  (bugfix@autoit.de)
;------------------------------------------------------------------------------------------------------------
Func _Array2DInsert(ByRef $avArray, $iElement, $sValue = '')
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	Local $i, $k
	Local $UBound2nd = UBound($avArray, 2)
	If @error = 2 Then
		Local $arTmp[UBound($avArray) + 1]
		If $iElement > UBound($avArray) Then
			SetError(3)
			Return 0
		EndIf
		For $i = 0 To UBound($arTmp) - 1
			If $i < $iElement Then
				$arTmp[$i] = $avArray[$i]
			ElseIf $i = $iElement Then
				If $i < UBound($avArray) Then
					$arTmp[$i] = $sValue
					$arTmp[$i + 1] = $avArray[$i]
				Else
					$arTmp[$i] = $sValue
				EndIf
			ElseIf ($i > $iElement) And ($i < UBound($avArray)) Then
				$arTmp[$i + 1] = $avArray[$i]
			EndIf
		Next
	Else
		Local $arTmp[UBound($avArray) + 1][$UBound2nd], $arValue
		If $sValue = '' Then
			For $i = 0 To $UBound2nd - 2
				$sValue &= '|'
			Next
		EndIf
		$arValue = StringSplit($sValue, '|')
		If $arValue[0] <> $UBound2nd Then
			SetError(2)
			Return 0
		EndIf
		If $iElement > UBound($avArray) Then
			SetError(3)
			Return 0
		EndIf
		For $i = 0 To UBound($arTmp) - 1
			If $i < $iElement Then
				For $k = 0 To $UBound2nd - 1
					$arTmp[$i][$k] = $avArray[$i][$k]
				Next
			ElseIf $i = $iElement Then
				If $i < UBound($avArray) Then
					For $k = 0 To $UBound2nd - 1
						$arTmp[$i][$k] = $arValue[$k + 1]
						$arTmp[$i + 1][$k] = $avArray[$i][$k]
					Next
				Else
					For $k = 0 To $UBound2nd - 1
						$arTmp[$i][$k] = $arValue[$k + 1]
					Next
				EndIf
			ElseIf ($i > $iElement) And ($i < UBound($avArray)) Then
				For $k = 0 To $UBound2nd - 1
					$arTmp[$i + 1][$k] = $avArray[$i][$k]
				Next
			EndIf
		Next
	EndIf
	$avArray = $arTmp
	Return -1
EndFunc   ;==>_Array2DInsert

;------------------------------------------------------------------------------------------------------------
;	Funktion		_Array2DSplit(ByRef $AR_SOURCE, ByRef $AR_TARGET, $iFROM=-1 [, $ANZ=-1])
;
;	Beschreibung	Splittet ein 1D/2D Array ab Indexposition, optional wird Anzahl Einträge ausgelagert
;
;	Parameter		$AR_SOURCE		Array mit Ausgangsdaten
;					$AR_TARGET		Array mit abgesplitteten Daten
;					$iFROM			Index ab dem gesplittet wird
;		optional	$ANZ			Anzahl Elemente, die abgesplittet werden sollen
;
;	Rückgabe		Erfolg			-1
;					Fehler			0		@error = 1		Ausgangsvariablen sind keine Arrays
;											@error = 2		kein Startindex oder Index außerhalb Bereich
;
;	Autor			BugFix  (bugfix@autoit.de)
;------------------------------------------------------------------------------------------------------------
Func _Array2DSplit(ByRef $AR_SOURCE, ByRef $AR_TARGET, $iFROM = -1, $ANZ = -1)
	If (Not IsArray($AR_SOURCE)) Or (Not IsArray($AR_TARGET)) Then
		SetError(1)
		Return 0
	EndIf
	If $ANZ = -1 Then $ANZ = UBound($AR_SOURCE) - $iFROM
	If ($iFROM < 0) Or ($iFROM > UBound($AR_SOURCE) - 1) Or ($ANZ < 1) Or ($ANZ > (UBound($AR_SOURCE) - $iFROM)) Then
		SetError(2)
		Return 0
	EndIf
	Local $i, $j, $k
	Local $UBound2nd = UBound($AR_SOURCE, 2)
	If @error = 2 Then
		Local $arTmp[UBound($AR_SOURCE) - $ANZ]
		ReDim $AR_TARGET[$ANZ]
		For $k = 0 To $iFROM - 1
			$arTmp[$k] = $AR_SOURCE[$k]
		Next
		$j = 0
		For $i = $iFROM To $iFROM + $ANZ - 1
			$AR_TARGET[$j] = $AR_SOURCE[$i]
			$j += 1
		Next
		For $i = $iFROM + $ANZ To UBound($AR_SOURCE) - 1
			$arTmp[$k] = $AR_SOURCE[$i]
			$k += 1
		Next
		$AR_SOURCE = $arTmp
		Return -1
	Else
		Local $arTmp[UBound($AR_SOURCE) - $ANZ][$UBound2nd]
		ReDim $AR_TARGET[$ANZ][$UBound2nd]
		For $k = 0 To $iFROM - 1
			For $i = 0 To $UBound2nd - 1
				$arTmp[$k][$i] = $AR_SOURCE[$k][$i]
			Next
		Next
		$j = 0
		For $i = $iFROM To $iFROM + $ANZ - 1
			For $l = 0 To $UBound2nd - 1
				$AR_TARGET[$j][$l] = $AR_SOURCE[$i][$l]
			Next
			$j += 1
		Next
		For $i = $iFROM + $ANZ To UBound($AR_SOURCE) - 1
			For $l = 0 To $UBound2nd - 1
				$arTmp[$k][$l] = $AR_SOURCE[$i][$l]
			Next
			$k += 1
		Next
		$AR_SOURCE = $arTmp
		Return -1
	EndIf
EndFunc   ;==>_Array2DSplit

;----------------------------------------------------------------------------------------------------------------------
;	Function		_Array2DEmptyDel(ByRef $avArray [, $Col=0])
;
;	Description		Delete empty Array elements
;					Delete all emty Rows or all empty Columns
;					Works also with 1D-Array (only Rows)
;
;	Parameter		$avArray	Given Array
;		optional	$Col		set 1 to delete empty Columns; default is 0 to delete empty Rows
;
;	Return			Succes		-1	ByRef the given Array without empty Elements, resized
;					Failure		0 	and set @error = 1
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DEmptyDel(ByRef $avArray, $Col = 0)
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	Local $i, $k, $notEmpty, $val, $len
	Local $UBound2nd = UBound($avArray, 2)
	If @error = 2 Then
		Local $arTmp[1]
		For $i = 0 To UBound($avArray) - 1
			If StringLen($avArray[$i] > 0) Then
				If StringLen($arTmp[UBound($arTmp) - 1]) = 0 Then
					$arTmp[UBound($arTmp) - 1] = $avArray[$i]
				Else
					ReDim $arTmp[UBound($arTmp) + 1]
					$arTmp[UBound($arTmp) - 1] = $avArray[$i]
				EndIf
			EndIf
		Next
	Else
		If $Col = 0 Then
			Local $arTmp[1][$UBound2nd]
			For $i = 0 To UBound($avArray) - 1
				$val = ''
				For $k = 0 To $UBound2nd - 1
					$val &= $avArray[$i][$k]
				Next
				If StringLen($val) > 0 Then
					$len = 0
					For $k = 0 To UBound($arTmp, 2) - 1
						$len &= StringLen($arTmp[UBound($arTmp) - 1][$k])
					Next
					If $len = 0 Then
						For $k = 0 To $UBound2nd - 1
							$arTmp[UBound($arTmp) - 1][$k] = $avArray[$i][$k]
						Next
					Else
						ReDim $arTmp[UBound($arTmp) + 1][$UBound2nd]
						For $k = 0 To $UBound2nd - 1
							$arTmp[UBound($arTmp) - 1][$k] = $avArray[$i][$k]
						Next
					EndIf
				EndIf
			Next
		Else
			Local $arTmp[UBound($avArray)][1]
			For $k = 0 To $UBound2nd - 1
				$val = ''
				$notEmpty = 0
				For $i = 0 To UBound($avArray) - 1
					$val &= $avArray[$i][$k]
					If StringLen($val) > 0 Then
						$notEmpty = 1
						ExitLoop
					EndIf
				Next
				If $notEmpty = 1 Then
					$len = 0
					For $i = 0 To UBound($arTmp) - 1
						$len &= StringLen($arTmp[$i][UBound($arTmp, 2) - 1])
					Next
					If $len = 0 Then
						For $i = 0 To UBound($avArray) - 1
							$arTmp[$i][0] = $avArray[$i][$k]
						Next
					Else
						ReDim $arTmp[UBound($avArray)][UBound($arTmp, 2) + 1]
						For $i = 0 To UBound($avArray) - 1
							$arTmp[$i][UBound($arTmp, 2) - 1] = $avArray[$i][$k]
						Next
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	$avArray = $arTmp
	Return -1
EndFunc   ;==>_Array2DEmptyDel

;----------------------------------------------------------------------------------------------------------------------
;	Fuction			_Array2DJoin(ByRef $ARRAY, ByRef $AR2JOIN)
;
;	Description		Join 2 Arrays, 1D/2D can be mixed
;
;	Parameter		$ARRAY		1st array, will be joined with 2nd
;					$AR2JOIN	2nd array
;
;	Return			Succes		-1	ByRef $ARRAY
;					Failure		0	set @error = 1; given array(s) are not array
;
; Author			BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DJoin(ByRef $ARRAY, ByRef $AR2JOIN)
	If (Not IsArray($ARRAY)) Or (Not IsArray($AR2JOIN)) Then
		SetError(1)
		Return 0
	EndIf
	Local $UB2ndAR = UBound($ARRAY, 2), $i, $k
	If @error = 2 Then $UB2ndAR = 0
	Local $UB2nd2JOIN = UBound($AR2JOIN, 2)
	If @error = 2 Then $UB2nd2JOIN = 0
	Local $arTmp
	Select
		Case $UB2ndAR = 0 And $UB2nd2JOIN = 0
			For $i = 0 To UBound($AR2JOIN) - 1
				ReDim $ARRAY[UBound($ARRAY) + 1]
				$ARRAY[UBound($ARRAY) - 1] = $AR2JOIN[$i]
			Next
			Return -1
		Case $UB2ndAR > 0 And $UB2nd2JOIN = 0
			$arTmp = $AR2JOIN
			ReDim $AR2JOIN[UBound($AR2JOIN)][$UB2ndAR]
			For $i = 0 To UBound($arTmp) - 1
				$AR2JOIN[$i][0] = $arTmp[$i]
			Next
		Case $UB2ndAR = 0 And $UB2nd2JOIN > 0
			$arTmp = $ARRAY
			ReDim $ARRAY[UBound($ARRAY)][$UB2nd2JOIN]
			For $i = 0 To UBound($arTmp) - 1
				$ARRAY[$i][0] = $arTmp[$i]
			Next
		Case $UB2ndAR > 0 And $UB2nd2JOIN > 0
			Select
				Case $UB2ndAR < $UB2nd2JOIN
					ReDim $ARRAY[UBound($ARRAY)][$UB2nd2JOIN]
				Case $UB2ndAR > $UB2nd2JOIN
					ReDim $AR2JOIN[UBound($AR2JOIN)][$UB2ndAR]
			EndSelect
	EndSelect
	For $i = 0 To UBound($AR2JOIN) - 1
		ReDim $ARRAY[UBound($ARRAY) + 1][UBound($ARRAY, 2)]
		For $k = 0 To UBound($AR2JOIN, 2) - 1
			$ARRAY[UBound($ARRAY) - 1][$k] = $AR2JOIN[$i][$k]
		Next
	Next
	Return -1
EndFunc   ;==>_Array2DJoin

;----------------------------------------------------------------------------------------------------------------------
;	Fuction			_Array2DDelete(ByRef $ARRAY, $iDEL)
;
;	Description		Delete one row on a given index in an 1D/2D -Array
;
;	Parameter		$ARRAY		the array, where one row will deleted
;					$iDEL		Row-Index to delete
;
;	Return			Succes		-1	ByRef $ARRAY
;					Failure		0	set @error = 1; given array are not array
;									set @error = 2; index is out of range
;
; Author			BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DDelete(ByRef $ARRAY, $iDEL)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	If ($iDEL < 0) Or ($iDEL > UBound($ARRAY) - 1) Then
		SetError(2)
		Return 0
	EndIf
	Local $i, $k, $l
	Local $UBound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		Local $arTmp[UBound($ARRAY) - 1]
		$k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If $i <> $iDEL Then
				$arTmp[$k] = $ARRAY[$i]
				$k += 1
			EndIf
		Next
	Else
		Local $arTmp[UBound($ARRAY) - 1][$UBound2nd]
		$k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If $i <> $iDEL Then
				For $l = 0 To $UBound2nd - 1
					$arTmp[$k][$l] = $ARRAY[$i][$l]
				Next
				$k += 1
			EndIf
		Next
	EndIf
	$ARRAY = $arTmp
	Return -1
EndFunc   ;==>_Array2DDelete

;----------------------------------------------------------------------------------------------------------------------
;
;	Function		_Array2DSearch(ByRef $avArray, $vWhat2Find [, $iDim=-1 [, $iStart=0 [, $iEnd=0 [, $iCaseSense=0 [, $fPartialSearch=False [, $1stFound=False]]]]]])
;
;	Description		Finds all Entry's like $vWhat2Find in an 1D/2D Array
;					Works with all occurences in 2nd Dimension
;					Search in all occurences or only in a given column
;					To set numeric values for default, you can use -1
;
;	Parameter		$avArray		The array to search
;					$vWhat2Find		What to search $avArray for
;		optional	$iDim			Index of Dimension to search; default -1 (all)
;		optional	$iStart			Start array index for search; default 0
;		optional	$iEnd			End array index for search; default 0
;		optional	$iCaseSense		If set to 1 then search is case sensitive; default 0
;		optional	$fPartialSearch	If set to True then executes a partial search. default False
;		optional	$1stFound		If set to True, only one match will be searched; default False
;
;	Return			Succes			Array with Index of matches, Array[0] includes the count of matches
;									In an 2D Array you got for every match [iRow|iCol]
;									Array[0] = 0 if no element found
;									If option 1stFound is set, Array[0] = FoundIndex; if no element found Array[0] = -1
;					Failure			0 and set @error
;									@error = 1	given array is not array
;									@error = 2	given dim is out of range
;									@error = 4	$iStart is out of range
;									@error = 8  $iEnd is out of range
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DSearch(ByRef $avArray, $vWhat2Find, $iDim = -1, $iStart = 0, $iEnd = 0, $iCaseSense = 0, $fPartialSearch = False, $1stFound = False)
	Local $error = 0, $1D, $arFound[1] = [0], $i, $k
	If $1stFound Then $arFound[0] = -1
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	Local $UBound2nd = UBound($avArray, 2)
	If @error = 2 Then $1D = True
	If ($iEnd = 0) Or ($iEnd = -1) Then $iEnd = UBound($avArray) - 1
	If $iStart = -1 Then $iStart = 0
	If $iCaseSense = -1 Then $iCaseSense = 0
	If $iCaseSense <> 0 Then $iCaseSense = 1
	Select
		Case ($iDim > $UBound2nd) Or ($iDim < -1)
			$error += 2
		Case ($iStart < 0) Or ($iStart > UBound($avArray) - 1)
			$error += 4
		Case ($iEnd < $iStart) Or ($iEnd > UBound($avArray) - 1)
			$error += 8
	EndSelect
	If $error <> 0 Then
		SetError($error)
		Return 0
	EndIf
	If $fPartialSearch <> True Then $fPartialSearch = False
	If $1D Then
		For $i = $iStart To $iEnd
			Select
				Case $iCaseSense = 0 And (Not $fPartialSearch)
					If $avArray[$i] = $vWhat2Find Then
						If $1stFound Then
							$arFound[0] = $i
							Return $arFound
						Else
							ReDim $arFound[UBound($arFound) + 1]
							$arFound[UBound($arFound) - 1] = $i
							$arFound[0] += 1
						EndIf
					EndIf
				Case $iCaseSense = 1 And (Not $fPartialSearch)
					If $avArray[$i] == $vWhat2Find Then
						If $1stFound Then
							$arFound[0] = $i
							Return $arFound
						Else
							ReDim $arFound[UBound($arFound) + 1]
							$arFound[UBound($arFound) - 1] = $i
							$arFound[0] += 1
						EndIf
					EndIf
				Case $iCaseSense = 0 And $fPartialSearch
					If StringInStr($avArray[$i], $vWhat2Find) Then
						If $1stFound Then
							$arFound[0] = $i
							Return $arFound
						Else
							ReDim $arFound[UBound($arFound) + 1]
							$arFound[UBound($arFound) - 1] = $i
							$arFound[0] += 1
						EndIf
					EndIf
				Case $iCaseSense = 1 And $fPartialSearch
					If StringInStr($avArray[$i], $vWhat2Find, 1) Then
						If $1stFound Then
							$arFound[0] = $i
							Return $arFound
						Else
							ReDim $arFound[UBound($arFound) + 1]
							$arFound[UBound($arFound) - 1] = $i
							$arFound[0] += 1
						EndIf
					EndIf
			EndSelect
		Next
	Else
		For $i = $iStart To $iEnd
			If $iDim = -1 Then
				Select
					Case $iCaseSense = 0 And (Not $fPartialSearch)
						For $k = 0 To $UBound2nd - 1
							If $avArray[$i][$k] = $vWhat2Find Then
								If $1stFound Then
									$arFound[0] = $i & '|' & $k
									Return $arFound
								Else
									ReDim $arFound[UBound($arFound) + 1]
									$arFound[UBound($arFound) - 1] = $i & '|' & $k
									$arFound[0] += 1
								EndIf
							EndIf
						Next
					Case $iCaseSense = 1 And (Not $fPartialSearch)
						For $k = 0 To $UBound2nd - 1
							If $avArray[$i][$k] == $vWhat2Find Then
								If $1stFound Then
									$arFound[0] = $i & '|' & $k
									Return $arFound
								Else
									ReDim $arFound[UBound($arFound) + 1]
									$arFound[UBound($arFound) - 1] = $i & '|' & $k
									$arFound[0] += 1
								EndIf
							EndIf
						Next
					Case $iCaseSense = 0 And $fPartialSearch
						For $k = 0 To $UBound2nd - 1
							If StringInStr($avArray[$i][$k], $vWhat2Find) Then
								If $1stFound Then
									$arFound[0] = $i & '|' & $k
									Return $arFound
								Else
									ReDim $arFound[UBound($arFound) + 1]
									$arFound[UBound($arFound) - 1] = $i & '|' & $k
									$arFound[0] += 1
								EndIf
							EndIf
						Next
					Case $iCaseSense = 1 And $fPartialSearch
						For $k = 0 To $UBound2nd - 1
							If StringInStr($avArray[$i][$k], $vWhat2Find, 1) Then
								If $1stFound Then
									$arFound[0] = $i & '|' & $k
									Return $arFound
								Else
									ReDim $arFound[UBound($arFound) + 1]
									$arFound[UBound($arFound) - 1] = $i & '|' & $k
									$arFound[0] += 1
								EndIf
							EndIf
						Next
				EndSelect
			Else
				Select
					Case $iCaseSense = 0 And (Not $fPartialSearch)
						If $avArray[$i][$iDim] = $vWhat2Find Then
							If $1stFound Then
								$arFound[0] = $i & '|' & $iDim
								Return $arFound
							Else
								ReDim $arFound[UBound($arFound) + 1]
								$arFound[UBound($arFound) - 1] = $i & '|' & $iDim
								$arFound[0] += 1
							EndIf
						EndIf
					Case $iCaseSense = 1 And (Not $fPartialSearch)
						If $avArray[$i][$iDim] == $vWhat2Find Then
							If $1stFound Then
								$arFound[0] = $i & '|' & $iDim
								Return $arFound
							Else
								ReDim $arFound[UBound($arFound) + 1]
								$arFound[UBound($arFound) - 1] = $i & '|' & $iDim
								$arFound[0] += 1
							EndIf
						EndIf
					Case $iCaseSense = 0 And $fPartialSearch
						If StringInStr($avArray[$i][$iDim], $vWhat2Find) Then
							If $1stFound Then
								$arFound[0] = $i & '|' & $iDim
								Return $arFound
							Else
								ReDim $arFound[UBound($arFound) + 1]
								$arFound[UBound($arFound) - 1] = $i & '|' & $iDim
								$arFound[0] += 1
							EndIf
						EndIf
					Case $iCaseSense = 1 And $fPartialSearch
						If StringInStr($avArray[$i][$iDim], $vWhat2Find, 1) Then
							If $1stFound Then
								$arFound[0] = $i & '|' & $iDim
								Return $arFound
							Else
								ReDim $arFound[UBound($arFound) + 1]
								$arFound[UBound($arFound) - 1] = $i & '|' & $iDim
								$arFound[0] += 1
							EndIf
						EndIf
				EndSelect
			EndIf
		Next
	EndIf
	Return $arFound
EndFunc   ;==>_Array2DSearch


;----------------------------------------------------------------------------------------------------------------------
;	Function		_Array2DMirror(ByRef $ARRAY)
;
;	Description		In an array will mirrored raws and columns.
;					Raw will be column and contrary.
;					Works with any occurences in 2nd Dimension (parent array)
;
;	Parameter		$ARRAY		2D-Array
;
;	Return			Succes		-1			raws and columns are mirrored
;					Failure		0 and set @error
;								@error = 1	given array is not array
;								@error = 2	given array has'nt 2 dimensions
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DMirror(ByRef $ARRAY)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	Local $i, $k
	Local $UBound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		SetError(2)
		Return 0
	EndIf
	Local $arTmp[$UBound2nd][UBound($ARRAY)]
	For $i = 0 To UBound($ARRAY) - 1
		For $k = 0 To UBound($ARRAY, 2) - 1
			$arTmp[$k][$i] = $ARRAY[$i][$k]
		Next
	Next
	$ARRAY = $arTmp
	Return -1
EndFunc   ;==>_Array2DMirror

;----------------------------------------------------------------------------------------------------------------------
;	Function		_SubArray2DGetEntry(ByRef $ARRAY, $SubRow, $ParentRow [, $SubCol=-1 [, $ParentCol=-1])
;
;	Description		For Array with Array as entry you got the determined entry
;					Works with any occurences in 2nd Dimension (parent array and sub-array too)
;					Works also with 1D-Array
;
;	Parameter		$ARRAY		Given array with array as entrys
;					$SubRow		0-based row -index of the entry inside the sub-array, you want to got
;					$ParentRow	0-based row -index of parent-array
;		optional	$SubCol		0-based column -index of sub-array, (if exists)
;		optional	$ParentCol	0-based column -index of parent-array, (if exists)
;
;	Return			Succes		value from determined sub-array
;					Failure		0 and set @error
;								@error = 1	given array is not array
;								@error = 2	row -index for parent-array out of range
;								@error = 3	col -index for parent-array out of range
;								@error = 4	col -index for parent-array is given, but array is 1D
;								@error = 5	row -index for sub-array out of range
;								@error = 6	col -index for sub-array out of range
;								@error = 7	col -index for sub-array is given, but array is 1D
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _SubArray2DGetEntry(ByRef $ARRAY, $SubRow, $ParentRow, $SubCol = -1, $ParentCol = -1)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	If ($ParentRow < 0) Or ($ParentRow > UBound($ARRAY) - 1) Then
		SetError(2)
		Return 0
	EndIf
	Local $Ub2ndParent = UBound($ARRAY, 2)
	If @error Then
		If $ParentCol <> -1 Then
			SetError(4)
			Return 0
		EndIf
	ElseIf ($ParentCol < -1) Or ($ParentCol > $Ub2ndParent - 1) Then
		SetError(3)
		Return 0
	EndIf
	Local $arSub
	Switch $ParentCol
		Case -1
			$arSub = $ARRAY[$ParentRow]
		Case Else
			$arSub = $ARRAY[$ParentRow][$ParentCol]
	EndSwitch
	If ($SubRow < 0) Or ($SubRow > UBound($arSub) - 1) Then
		SetError(5)
		Return 0
	EndIf
	Local $Ub2ndSub = UBound($arSub, 2)
	If @error Then
		If $SubCol <> -1 Then
			SetError(7)
			Return 0
		Else
			Return $arSub[$SubRow]
		EndIf
	Else
		If ($SubCol < 0) Or ($SubCol > $Ub2ndSub) Then
			SetError(6)
			Return 0
		Else
			Return $arSub[$SubRow][$SubCol]
		EndIf
	EndIf
EndFunc   ;==>_SubArray2DGetEntry

;----------------------------------------------------------------------------------------------------------------------
;	Function		_SubArray2DSetEntry(ByRef $ARRAY, $Entry, $SubRow, $ParentRow [, $SubCol=-1 [, $ParentCol=-1])
;
;	Description		For Array with Array as entry you set the determined entry
;					Works with any occurences in 2nd Dimension (parent array and sub-array too)
;					Works also with 1D-Array
;
;	Parameter		$ARRAY		Given array with array as entrys
;					$Entry		Value you want to set in the sub-array
;					$SubRow		0-based row -index of the entry inside the sub-array, you want to set
;					$ParentRow	0-based row -index of parent-array
;		optional	$SubCol		0-based column -index of sub-array, (if exists)
;		optional	$ParentCol	0-based column -index of parent-array, (if exists)
;
;	Return			Succes		-1			value is set
;					Failure		0 and set @error
;								@error = 1	given array is not array
;								@error = 2	row -index for parent-array out of range
;								@error = 3	col -index for parent-array out of range
;								@error = 4	col -index for parent-array is given, but array is 1D
;								@error = 5	row -index for sub-array out of range
;								@error = 6	col -index for sub-array out of range
;								@error = 7	col -index for sub-array is given, but array is 1D
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _SubArray2DSetEntry(ByRef $ARRAY, $Entry, $SubRow, $ParentRow, $SubCol = -1, $ParentCol = -1)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	If ($ParentRow < 0) Or ($ParentRow > UBound($ARRAY) - 1) Then
		SetError(2)
		Return 0
	EndIf
	Local $Ub2ndParent = UBound($ARRAY, 2)
	If @error Then
		If $ParentCol <> -1 Then
			SetError(4)
			Return 0
		EndIf
	ElseIf ($ParentCol < -1) Or ($ParentCol > $Ub2ndParent - 1) Then
		SetError(3)
		Return 0
	EndIf
	Local $arSub
	Switch $ParentCol
		Case -1
			$arSub = $ARRAY[$ParentRow]
		Case Else
			$arSub = $ARRAY[$ParentRow][$ParentCol]
	EndSwitch
	If ($SubRow < 0) Or ($SubRow > UBound($arSub) - 1) Then
		SetError(5)
		Return 0
	EndIf
	Local $Ub2ndSub = UBound($arSub, 2)
	If @error Then
		If $SubCol <> -1 Then
			SetError(7)
			Return 0
		Else
			$arSub[$SubRow] = $Entry
		EndIf
	Else
		If ($SubCol < 0) Or ($SubCol > $Ub2ndSub) Then
			SetError(6)
			Return 0
		Else
			$arSub[$SubRow][$SubCol] = $Entry
		EndIf
	EndIf
	Switch $ParentCol
		Case -1
			$ARRAY[$ParentRow] = $arSub
		Case Else
			$ARRAY[$ParentRow][$ParentCol] = $arSub
	EndSwitch
	Return -1
EndFunc   ;==>_SubArray2DSetEntry

;----------------------------------------------------------------------------------------------------------------------
; Function		_Array2DSortByCountSameEntries(ByRef $ARRAY [, $iCol=0 [, $DESCENDING=1]])
;
; Description	- Sorts an 1D/2D Array by count of same entries (2D - in a given column)
;				- Count de- or ascending
;
; Parameter		$ARRAY:			Array to sort
;	optional	$iCol:			Column with same entries to sort (default 0)
;	optional	$DESCENDING:	Sort ascending[0]/descending[1] (default 1)
;
; Return		Success			-1		sorted array
;				Failure			0		@error = 1, given array is not array
;
; Requirements	_ArraySort_2ary() with #include <array.au3>
;
; Author		BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DSortByCountSameEntries(ByRef $ARRAY, $iCol = 0, $DESCENDING = 1)
	If (Not IsArray($ARRAY)) Then
		SetError(1)
		Return 0
	EndIf
	If $DESCENDING <> 1 Then $DESCENDING = 0
	Local $UBound2nd = UBound($ARRAY, 2)
	Local $aTMP
	If @error = 2 Then
		Dim $aTMP[UBound($ARRAY)][2]
		For $i = 0 To UBound($ARRAY) - 1
			$aTMP[$i][0] = 1
			$aTMP[$i][1] = $ARRAY[$i]
		Next
		Local $k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If ($i > 0) And ($i < UBound($ARRAY) - 1) Then
				If $ARRAY[$i] <> $aTMP[$k][1] Then
					For $x = $k To $i - 1
						$aTMP[$x][0] = $i - $k
					Next
					$k = $i
				EndIf
			ElseIf $i = UBound($ARRAY) - 1 Then
				If $ARRAY[$i] <> $aTMP[$k][1] Then
					For $x = $k To $i - 1
						$aTMP[$x][0] = $i - $k
					Next
					$k = $i
				Else
					For $x = $k To $i
						$aTMP[$x][0] = $i - $k + 1
					Next
				EndIf
			EndIf
		Next
		_ArraySort_2ary($aTMP, 0, $iCol, $DESCENDING)
		For $i = 0 To UBound($ARRAY) - 1
			$ARRAY[$i] = $aTMP[$i][1]
		Next
	Else
		$aTMP = $ARRAY
		ReDim $aTMP[UBound($ARRAY)][$UBound2nd + 1]
		For $i = 0 To UBound($ARRAY) - 1
			$aTMP[$i][$UBound2nd] = 1
		Next
		$k = 0
		For $i = 0 To UBound($ARRAY) - 1
			If ($i > 0) And ($i < UBound($ARRAY) - 1) Then
				If $ARRAY[$i][$iCol] <> $aTMP[$k][$iCol] Then
					For $x = $k To $i - 1
						$aTMP[$x][$UBound2nd] = $i - $k
					Next
					$k = $i
				EndIf
			ElseIf $i = UBound($ARRAY) - 1 Then
				If $ARRAY[$i][$iCol] <> $aTMP[$k][$iCol] Then
					For $x = $k To $i - 1
						$aTMP[$x][$UBound2nd] = $i - $k
					Next
					$k = $i
				Else
					For $x = $k To $i
						$aTMP[$x][$UBound2nd] = $i - $k + 1
					Next
				EndIf
			EndIf
		Next
		_ArraySort_2ary($aTMP, $UBound2nd, $iCol, $DESCENDING)
		For $i = 0 To UBound($ARRAY) - 1
			For $k = 0 To $UBound2nd - 1
				$ARRAY[$i][$k] = $aTMP[$i][$k]
			Next
		Next
	EndIf
	Return -1
EndFunc   ;==>_Array2DSortByCountSameEntries

;===============================================================================
;
; Function Name:  _Array2DPop($ARRAY)
; Description:    Gibt das letzte Element eines 1D/2D-Arrays zurück und löscht dieses
;                 gleichzeitig vom Array
; Return:         Erfolg:   1D = 1D-Array mit dem letzten Element
;                           2D = 1D-Array mit jeweils einem Eintrag pro Spalte des letzten Elements
;                                Array[0] enthält die Anzahl der Elemente
;                 Fehler:   Leerstring und @error = 1 ; Variable ist kein Array
; Author(s):      Cephas <cephas at clergy dot net>
; Modified:       BugFix (bugfix@autoit.de)  ==> 2D-Anpassung
;
;===============================================================================
Func _Array2DPop(ByRef $ARRAY)
	Local $LastValue = ''
	Local $UBound2nd = UBound($ARRAY, 2), $aOut[1]
	If @error = 1 Then ; kein Array
		SetError(1)
		Return ''
	ElseIf @error = 2 Then ; Array hat keine 2. Dim
		$UBound2nd = 1
		$aOut[0] = $ARRAY[UBound($ARRAY) - 1]
		$LastValue = $aOut
	Else
		ReDim $aOut[$UBound2nd + 1]
		$aOut[0] = 0
		For $i = 0 To $UBound2nd - 1
			$aOut[$i + 1] = $ARRAY[UBound($ARRAY) - 1][$i]
			$aOut[0] += 1
		Next
		$LastValue = $aOut
	EndIf
	If UBound($ARRAY) = 1 Then
		$ARRAY = ''
	Else
		If $UBound2nd = 1 Then
			ReDim $ARRAY[UBound($ARRAY) - 1]
		Else
			ReDim $ARRAY[UBound($ARRAY) - 1][$UBound2nd]
		EndIf
	EndIf
	Return $LastValue
EndFunc   ;==>_Array2DPop

;=====================================================================================
;
; Function Name:    _Array2DPush($ARRAY, $Value [, $Direction=0])
; Description:      Fügt einem Array Werte hinzu ohne die Arraygröße zu verändern.
;                   Werte können vom Ende (Standard) oder vom Anfang des Arrays zugefügt werden.
;                   Entsprechend der Anzahl der einzufügenden Werte wird eine gleiche Anzahl Elemente
;                   aus dem Array 'herausgeschoben' (ge-pusht)
; Parameter(s):     $ARRAY       - Array
;                   $Value       - Der einzufügende Wert, oder mehrere Werte als Array
;                   $Direction   - 0 = Linksseitiges Schieben (Einfügen vom Ende) (Standard)
;                                  1 = Rechtsseitiges Schieben (Einfügen vom Anfang)
; Requirement(s):   None
; Return Value(s):  On Success -  Returns 1
;                   On Failure -  -1 und SetError
;                                    @error = 1 kein Array
;                                    @error = 2 Einfügearray größer als Originalarray
;                                    @error = 3 Einfügearray und Originalarray haben unterschiedliche Dimensionen                                    @error = 4 $Value ist Einzelwert, 2D-Array erwartet
;                                    @error = 5 $Value ist 1D-Array, 2D-Array erwartet
; Author(s):        Helias Gerassimou(hgeras)
; Modified:         BugFix (bugfix@autoit.de) ==> 2D-Anpassung
;
;======================================================================================
Func _Array2DPush(ByRef $ARRAY, $Value, $Direction = 0)
	Local $i, $j, $k
	Local $arStatVal = IsArray($Value)
	Local $UBound1st = UBound($ARRAY)
	If @error = 1 Then ; kein Array
		SetError(1)
		Return -1
	EndIf
	Local $UBound2nd = UBound($ARRAY, 2)
	Local $UbValue
	If @error = 2 Then ; Array hat keine 2. Dim
		If $arStatVal Then ; Einfügewert ist Array
			$UbValue = UBound($Value)
			If $UbValue > $UBound1st Then ; Einfügearray größer als Originalarray
				SetError(2)
				Return -1
			EndIf
			If UBound($Value, 2) > 0 Then
				SetError(3) ; hier keine 2. Dim zulässig
				Return -1
			EndIf
			For $k = 0 To $UbValue - 1
				If $Direction = 0 Then
					For $i = 0 To ($UBound1st - 2)
						$ARRAY[$i] = $ARRAY[$i + 1]
					Next
					$i = ($UBound1st - 1)
					$ARRAY[$i] = $Value[$k]
				Else
					For $i = ($UBound1st - 1) To 1 Step -1
						$ARRAY[$i] = $ARRAY[$i - 1]
					Next
					$ARRAY[$i] = $Value[$UbValue - 1 - $k]
				EndIf
			Next
		Else ; Einfügewert ist Einzelwert
			If $Direction = 0 Then ; einfügen Einzelwert vom Ende
				For $i = 1 To $UBound1st - 1
					$ARRAY[$i - 1] = $ARRAY[$i]
				Next
				$ARRAY[$UBound1st - 1] = $Value
			Else ; einfügen Einzelwert vom Anfang
				For $i = $UBound1st - 1 To 1 Step -1
					$ARRAY[$i] = $ARRAY[$i - 1]
				Next
				$ARRAY[0] = $Value
			EndIf
		EndIf
	Else ; Array ist 2D
		Local $UbValue2nd = UBound($Value, 2)
		If @error = 1 Then ; Einfügewert ist kein Array
			SetError(4)
			Return -1
		ElseIf @error = 2 Then ; Einfügearray nicht 2D
			SetError(5)
			Return -1
		ElseIf UBound($Value) > $UBound1st Then ; Einfügearray größer als Originalarray
			SetError(2)
			Return -1
		ElseIf $UBound2nd <> $UbValue2nd Then ; 2. Dim nicht identische Größe
			SetError(3)
			Return -1
		EndIf
		$UbValue = UBound($Value)
		For $k = 0 To $UbValue - 1
			If $Direction = 0 Then
				For $i = 0 To ($UBound1st - 2)
					For $j = 0 To $UBound2nd - 1
						$ARRAY[$i][$j] = $ARRAY[$i + 1][$j]
					Next
				Next
				$i = ($UBound1st - 1)
				For $j = 0 To $UBound2nd - 1
					$ARRAY[$i][$j] = $Value[$k][$j]
				Next
			Else
				For $i = ($UBound1st - 1) To 1 Step -1
					For $j = 0 To $UBound2nd - 1
						$ARRAY[$i][$j] = $ARRAY[$i - 1][$j]
					Next
				Next
				For $j = 0 To $UBound2nd - 1
					$ARRAY[$i][$j] = $Value[$UbValue - 1 - $k][$j]
				Next
			EndIf
		Next
	EndIf
	Return 1
EndFunc   ;==>_Array2DPush
