; sorting with selfcreated items by DllCall

#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>

Global $giCurCol = -1
Global $giSortDir = 1
Global $gbSet = False
Global $giCol = -1

Example()

Func Example()

	$giCurCol = -1
	$giSortDir = 1
	$gbSet = False
	$giCol = -1

	Local $hGUI = GUICreate("Test", 300, 200)

	Local $idLv = GUICtrlCreateListView("Column1|Col2|Col3", 10, 10, 280, 180)
	GUICtrlRegisterListViewSort(-1, "LVSort2") ; Register the function "SortLV" for the sorting callback

	MyGUICtrlCreateListViewItem("ABC|666|10.05.2004", $idLv, -1)
	MyGUICtrlCreateListViewItem("DEF|444|11.05.2005", $idLv, -1)
	MyGUICtrlCreateListViewItem("CDE|444|12.05.2004", $idLv, -1)

	GUISetState(@SW_SHOW)

	Local $idMsg
	; Loop until the user exits.
	While 1
		$idMsg = GUIGetMsg()
		Switch $idMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $idLv
				$gbSet = False
				$giCurCol = $giCol
				GUICtrlSendMsg($idLv, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($idLv), 0)
				DllCall("user32.dll", "int", "InvalidateRect", "hwnd", ControlGetHandle($hGUI, "", $idLv), "int", 0, "int", 1)
		EndSwitch
	WEnd
EndFunc   ;==>Example

; Our sorting callback funtion
Func LVSort2($hWnd, $idItem1, $idItem2, $giColumn)
	Local $sVal1, $sVal2, $iResult

	; Switch the sorting direction
	If $giColumn = $giCurCol Then
		If Not $gbSet Then
			$giSortDir = $giSortDir * -1
			$gbSet = True
		EndIf
	Else
		$giSortDir = 1
	EndIf
	$giCol = $giColumn

	$sVal1 = GetSubItemText($hWnd, $idItem1, $giColumn)
	$sVal2 = GetSubItemText($hWnd, $idItem2, $giColumn)

	; If it is the 3rd colum (column starts with 0) then compare the dates
	If $giColumn = 2 Then
		$sVal1 = StringRight($sVal1, 4) & StringMid($sVal1, 4, 2) & StringLeft($sVal1, 2)
		$sVal2 = StringRight($sVal2, 4) & StringMid($sVal2, 4, 2) & StringLeft($sVal2, 2)
	EndIf

	$iResult = 0 ; No change of item1 and item2 positions

	If $sVal1 < $sVal2 Then
		$iResult = -1 ; Put item2 before item1
	ElseIf $sVal1 > $sVal2 Then
		$iResult = 1 ; Put item2 behind item1
	EndIf

	$iResult = $iResult * $giSortDir

	Return $iResult
EndFunc   ;==>LVSort2

; Create and insert items directly into the listview
Func MyGUICtrlCreateListViewItem($sText, $idCtrl, $iIndex)
	Local $tLvitem = DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int;")
	Local $tText = DllStructCreate("char[260]")
	Local $arText = StringSplit($sText, "|")

	If $iIndex = -1 Then $iIndex = GUICtrlSendMsg($idCtrl, $LVM_GETITEMCOUNT, 0, 0)

	DllStructSetData($tText, 1, $arText[1]) ; Save the item text in the struct

	DllStructSetData($tLvitem, 1, BitOR($LVIF_TEXT, $LVIF_PARAM))
	DllStructSetData($tLvitem, 2, $iIndex)
	DllStructSetData($tLvitem, 6, DllStructGetPtr($tText))
	; Set the lParam of the struct to the line index - unique within the listview
	DllStructSetData($tLvitem, 9, $iIndex)

	$iIndex = GUICtrlSendMsg($idCtrl, $LVM_INSERTITEMA, 0, DllStructGetPtr($tLvitem))

	If $iIndex > -1 Then
		; Insert now the rest of the column text
		For $i = 2 To $arText[0]
			DllStructSetData($tText, 1, $arText[$i])
			DllStructSetData($tLvitem, 3, $i - 1) ; Store the subitem index

			GUICtrlSendMsg($idCtrl, $LVM_SETITEMTEXTA, $iIndex, DllStructGetPtr($tLvitem))
		Next
	EndIf

	; Change the column width to fit the item text
	For $i = 0 To 2
		GUICtrlSendMsg($idCtrl, $LVM_SETCOLUMNWIDTH, $i, -1)
		GUICtrlSendMsg($idCtrl, $LVM_SETCOLUMNWIDTH, $i, -2)
	Next
EndFunc   ;==>MyGUICtrlCreateListViewItem

; Retrieve the text of a listview item in a specified column
Func GetSubItemText($idCtrl, $idItem, $iColumn)
	Local $tLvfi = DllStructCreate("uint;ptr;int;int[2];int")

	DllStructSetData($tLvfi, 1, $LVFI_PARAM)
	DllStructSetData($tLvfi, 3, $idItem)

	Local $tBuffer = DllStructCreate("char[260]")

	Local $iIndex = GUICtrlSendMsg($idCtrl, $LVM_FINDITEM, -1, DllStructGetPtr($tLvfi));

	Local $tLvi = DllStructCreate("uint;int;int;uint;uint;ptr;int;int;int;int")

	DllStructSetData($tLvi, 1, $LVIF_TEXT)
	DllStructSetData($tLvi, 2, $iIndex)
	DllStructSetData($tLvi, 3, $iColumn)
	DllStructSetData($tLvi, 6, DllStructGetPtr($tBuffer))
	DllStructSetData($tLvi, 7, 260)

	GUICtrlSendMsg($idCtrl, $LVM_GETITEMA, 0, DllStructGetPtr($tLvi));

	Local $sItemText = DllStructGetData($tBuffer, 1)

	Return $sItemText
EndFunc   ;==>GetSubItemText
