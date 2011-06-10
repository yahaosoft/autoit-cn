#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Example_UDF_Created()

Func Example_UDF_Created()
	Local $GUI, $hImage, $aImage, $hListView

	$GUI = GUICreate("(UDF Created) ListView Get Background Image", 600, 550)
	;=========================================================================================================
	$hListView = _GUICtrlListView_Create($GUI, "", 2, 2, 596, 500, -1, -1, True) ; 最后一个选项表示调用 CoInitializeEx
	;=========================================================================================================
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_DOUBLEBUFFER))

	; 加载图像
	$hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x0000FF, 16, 16))
	_GUICtrlListView_SetImageList($hListView, $hImage, 1)

	; 添加列
	_GUICtrlListView_InsertColumn($hListView, 0, "Column 1", 100)
	_GUICtrlListView_InsertColumn($hListView, 1, "Column 2", 100)
	_GUICtrlListView_InsertColumn($hListView, 2, "Column 3", 100)

	; 添加项目
	_GUICtrlListView_AddItem($hListView, "Row 1: Col 1", 0)
	_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 2", 1)
	_GUICtrlListView_AddSubItem($hListView, 0, "Row 1: Col 3", 2)
	_GUICtrlListView_AddItem($hListView, "Row 2: Col 1", 1)
	_GUICtrlListView_AddSubItem($hListView, 1, "Row 2: Col 2", 1)
	_GUICtrlListView_AddItem($hListView, "Row 3: Col 1", 2)

	; 建立组
	_GUICtrlListView_EnableGroupView($hListView)
	_GUICtrlListView_InsertGroup($hListView, -1, 1, "Group 1")
	_GUICtrlListView_InsertGroup($hListView, -1, 2, "Group 2")
	_GUICtrlListView_SetItemGroupID($hListView, 0, 1)
	_GUICtrlListView_SetItemGroupID($hListView, 1, 2)
	_GUICtrlListView_SetItemGroupID($hListView, 2, 2)

	; 获取图像
	Local $sURL = "http://www.autoitscript.com/autoit3/files/graphics/autoit9_wall_grey_800x600.jpg"
	Local $sFilePath = @ScriptDir & "\AutoIt.jpg"
	InetGet($sURL, $sFilePath)

	; 设置背景图像
	_GUICtrlListView_SetBkImage($hListView, $sFilePath)
	$aImage = _GUICtrlListView_GetBkImage($hListView)

	GUISetState()
	MsgBox(4160, "Information", "Background Image: " & $aImage[1])

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	;=========================================================================================================
	DllCall('ole32.dll', 'long', 'CoUinitialize') ; 必须为每个之前的 CoInitializeEx 调用此函数
	;=========================================================================================================

	GUIDelete()
	FileDelete($sFilePath)
EndFunc   ;==>Example_UDF_Created
