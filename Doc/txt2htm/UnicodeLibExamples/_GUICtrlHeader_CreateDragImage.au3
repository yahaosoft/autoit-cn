#include <GuiConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <WinAPI.au3>

$Debug_HDR = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $iMemo
_Main()

Func _Main()
	Local $hGUI, $hHeader, $hImage, $iMsg, $aSize, $tPos, $tRect, $hDC

	; 创建 GUI
	$hGUI = GUICreate("Header", 400, 300)
	$hHeader = _GUICtrlHeader_Create($hGUI)
	$iMemo = GUICtrlCreateEdit("", 2, 32, 396, 266, 0)
	GUISetState()

	; 添加列
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 4", 100)

	; 创建用于拖动的图像
	$hImage = _GUICtrlHeader_CreateDragImage($hHeader, 1)
	$aSize = _GUIImageList_GetIconSize($hImage)
	$hDC = _WinAPI_GetDC($hGUI)

	MemoWrite("Image drag Handle: " & "0x" & Hex($hImage))
	MemoWrite("IsPtr  = " & IsPtr($hImage) & " IsHWnd  = " & IsHWnd($hImage))

	; 在鼠标位置显示拖动图像直至用户退出
	Do
		$iMsg = GUIGetMsg()
		If $iMsg = $GUI_EVENT_MOUSEMOVE Then
			If $tPos <> 0 Then
				$tRect = DllStructCreate($tagRECT)
				DllStructSetData($tRect, "Left", DllStructGetData($tPos, "X"))
				DllStructSetData($tRect, "Top", DllStructGetData($tPos, "Y"))
				DllStructSetData($tRect, "Right", DllStructGetData($tPos, "X") + $aSize[0])
				DllStructSetData($tRect, "Bottom", DllStructGetData($tPos, "Y") + $aSize[1])
				_WinAPI_InvalidateRect($hGUI, $tRect)
			EndIf
			$tRect = _WinAPI_GetClientRect($hGUI)
			$tPos = _WinAPI_GetMousePos(True, $hGUI)
			If _WinAPI_PtInRect($tRect, $tPos) Then
				_GUIImageList_Draw($hImage, 0, $hDC, DllStructGetData($tPos, "X"), DllStructGetData($tPos, "Y"))
			EndIf
		EndIf
	Until $iMsg = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main

; 写入一行到 memo 控件
Func MemoWrite($sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
