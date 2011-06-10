#include <GuiConstantsEx.au3>
#include <GuiListView.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Example1()
Example2()
Example_UDF_Created()

Func Example1()
	Local $hListView

	GUICreate("ListView Delete All Items", 400, 300)

	$hListView = GUICtrlCreateListView("col1|col2|col3", 2, 2, 394, 268)
	GUISetState()

	; 加载三列
	For $iI = 0 To 9
		GUICtrlCreateListViewItem("Item " & $iI & "|Item " & $iI & "-1|Item " & $iI & "-2", $hListView)
	Next

	MsgBox(4160, "Information", "Delete All Items")
	; 用内置函数创建项目, 传递控件 ID
	MsgBox(4160, "Deleted?", _GUICtrlListView_DeleteAllItems($hListView))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example1

Func Example2()
	Local $hListView, $aItems[10][3]

	GUICreate("ListView Delete All Items", 400, 300)

	$hListView = GUICtrlCreateListView("col1|col2|col3", 2, 2, 394, 268)
	GUISetState()

	; 加载三列
	For $iI = 0 To UBound($aItems) - 1
		$aItems[$iI][0] = "Item " & $iI
		$aItems[$iI][1] = "Item " & $iI & "-1"
		$aItems[$iI][2] = "Item " & $iI & "-2"
	Next

	_GUICtrlListView_AddArray($hListView, $aItems)

	MsgBox(4160, "Information", "Delete All Items")
	; 使用 UDF 创建的项目, 传递句柄给控件
	MsgBox(4160, "Deleted?", _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView)))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example2

Func Example_UDF_Created()
	Local $GUI, $hListView, $aItems[10][3]

	$GUI = GUICreate("(UDF Created) ListView Delete All Items", 400, 300)

	$hListView = _GUICtrlListView_Create($GUI, "col1|col2|col3", 2, 2, 394, 268)
	GUISetState()

	; 加载三列
	For $iI = 0 To UBound($aItems) - 1
		$aItems[$iI][0] = "Item " & $iI
		$aItems[$iI][1] = "Item " & $iI & "-1"
		$aItems[$iI][2] = "Item " & $iI & "-2"
	Next

	_GUICtrlListView_AddArray($hListView, $aItems)

	MsgBox(4160, "Information", "Delete All Items")
	; 这已经是个句柄
	MsgBox(4160, "Deleted?", _GUICtrlListView_DeleteAllItems($hListView))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example_UDF_Created
