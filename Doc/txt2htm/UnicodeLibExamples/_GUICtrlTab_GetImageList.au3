#include <GuiConstantsEx.au3>
#include <GuiTab.au3>
#include <WinAPI.au3>
#include <GuiImageList.au3>

$Debug_TAB = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

_Main()

Func _Main()
	Local $hGUI, $hImage, $hTab

	; 创建 GUI
	$hGUI = GUICreate("Tab Control Get Image List", 400, 300)
	$hTab = _GUICtrlTab_Create($hGUI, 2, 2, 396, 296)
	GUISetState()

	; 创建图像
	$hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 16, 16))
	_GUICtrlTab_SetImageList($hTab, $hImage)

	; 添加标签
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 1", 0)
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 2", 1)
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 3", 2)

	; 显示图像列表句柄
	MsgBox(4160, "Information", "Image list handle: 0x" & Hex(_GUICtrlTab_GetImageList($hTab)) & @CRLF & _
			"IsPtr = " & IsPtr(_GUICtrlTab_GetImageList($hTab)) & " IsHwnd = " & IsHWnd(_GUICtrlTab_GetImageList($hTab)))

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main
