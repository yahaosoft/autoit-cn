#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

; 获取窗口标题的高度和窗口框架的宽度 - 当 XP 主题为 ON/OFF 时可能会不同
Global $htit = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
Global $frame = _WinAPI_GetSystemMetrics($SM_CXDLGFRAME)

Local $gui = GUICreate("Test Windows regions", 350, 210)
Local $btn_default = GUICtrlCreateButton("Default region", 100, 30, 150)
Local $btn_round = GUICtrlCreateButton("Round region", 100, 60, 150)
Local $btn_buble = GUICtrlCreateButton("Buble region ", 100, 90, 150)
Local $btn_transparent = GUICtrlCreateButton("Transparent region", 100, 120, 150)
Local $btn_exit = GUICtrlCreateButton("Exit", 100, 150, 150)
GUISetState(@SW_SHOW)

Local $pos = WinGetPos($gui) ; 获取整个窗口大小 (不包括由 GUICreate 定义的客户区大小)
Global $width = $pos[2]
Global $height = $pos[3]

Local $msg, $rgn
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $btn_exit
			ExitLoop

		Case $msg = $btn_default
			$rgn = _WinAPI_CreateRectRgn(0, 0, $width, $height)
			_WinAPI_SetWindowRgn($gui, $rgn)

		Case $msg = $btn_round
			$rgn = _WinAPI_CreateRoundRectRgn(0, 0, $width, $height, $width / 3, $height / 3)
			_WinAPI_SetWindowRgn($gui, $rgn)

		Case $msg = $btn_buble
			Local $rgn1 = _WinAPI_CreateRoundRectRgn(0, 0, $width / 2, $height / 2, $width / 2, $height / 2) ; 左上
			Local $rgn2 = _WinAPI_CreateRoundRectRgn($width / 2, 0, $width, $height / 2, $width / 2, $height / 2) ; 右上
			_WinAPI_CombineRgn($rgn1, $rgn1, $rgn2, $RGN_OR)
			_WinAPI_DeleteObject($rgn2)
			$rgn2 = _WinAPI_CreateRoundRectRgn(0, $height / 2, $width / 2, $height, $width / 2, $height / 2) ; 左下
			_WinAPI_CombineRgn($rgn1, $rgn1, $rgn2, $RGN_OR)
			_WinAPI_DeleteObject($rgn2)
			$rgn2 = _WinAPI_CreateRoundRectRgn($width / 2, $height / 2, $width, $height, $width / 2, $height / 2) ; 右下
			_WinAPI_CombineRgn($rgn1, $rgn1, $rgn2, $RGN_OR)
			_WinAPI_DeleteObject($rgn2)
			$rgn2 = _WinAPI_CreateRoundRectRgn(10, 10, $width - 10, $height - 10, $width, $height) ; 中间
			_WinAPI_CombineRgn($rgn1, $rgn1, $rgn2, $RGN_OR)
			_WinAPI_DeleteObject($rgn2)
			_WinAPI_SetWindowRgn($gui, $rgn1)

		Case $msg = $btn_transparent
			_GuiHole($gui, 40, 40, 260, 170)

	EndSelect
WEnd

; 生成内部透明区域用于添加控件
Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh)
	Local $outer_rgn, $inner_rgn, $combined_rgn

	$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $width, $height)
	$inner_rgn = _WinAPI_CreateRectRgn($i_x, $i_y, $i_x + $i_sizew, $i_y + $i_sizeh)
	$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)
	_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF)
	_WinAPI_DeleteObject($outer_rgn)
	_WinAPI_DeleteObject($inner_rgn)
	_AddCtrlRegion($combined_rgn, $btn_default)
	_AddCtrlRegion($combined_rgn, $btn_round)
	_AddCtrlRegion($combined_rgn, $btn_buble)
	_AddCtrlRegion($combined_rgn, $btn_transparent)
	_AddCtrlRegion($combined_rgn, $btn_exit)
	_WinAPI_SetWindowRgn($h_win, $combined_rgn)
EndFunc   ;==>_GuiHole

; 添加控件的范围到特定的区域
; 也考虑窗口标题/框架的大小
Func _AddCtrlRegion($full_rgn, $ctrl_id)
	Local $ctrl_pos, $ctrl_rgn

	$ctrl_pos = ControlGetPos($gui, "", $ctrl_id)
	$ctrl_rgn = _WinAPI_CreateRectRgn($ctrl_pos[0] + $frame, $ctrl_pos[1] + $htit + $frame, _
			$ctrl_pos[0] + $ctrl_pos[2] + $frame, $ctrl_pos[1] + $ctrl_pos[3] + $htit + $frame)
	_WinAPI_CombineRgn($full_rgn, $full_rgn, $ctrl_rgn, $RGN_OR)
	_WinAPI_DeleteObject($ctrl_rgn)
EndFunc   ;==>_AddCtrlRegion
