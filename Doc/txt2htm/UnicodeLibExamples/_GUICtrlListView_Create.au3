#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>

$Debug_LV = False ; 检查传递给 ListView 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hListView

_Main()

Func _Main()

	Local $GUI, $hImage
	$GUI = GUICreate("(UDF Created) ListView Create", 400, 300)

	$hListView = _GUICtrlListView_Create($GUI, "", 2, 2, 394, 268)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES))
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

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

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
;~ 	Local $tBuffer
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
;~ 				Case $LVN_BEGINDRAG ; 由鼠标左键执行的拖放操作已经开始
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; 没有返回值
;~ 				Case $LVN_BEGINLABELEDIT ; 开始项目的标签编辑
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINLABELEDIT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					Return False ; 允许用户编辑标签
;~ 					;Return True  ; 阻止用户编辑标签
;~ 				Case $LVN_BEGINRDRAG ; 由鼠标右键执行的拖放操作已经开始
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINRDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; 没有返回值
;~ 				Case $LVN_BEGINSCROLL ; 滚动操作开始, 最低操作系统为 WinXP
;~ 					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @LF & _
;~ 							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
;~ 					; 没有返回值
				Case $LVN_COLUMNCLICK ; 点击了一列
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					_DebugPrint("$LVN_COLUMNCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
					; 没有返回值
;~ 				Case $LVN_DELETEALLITEMS ; 控件中的所有项即将被删除
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_DELETEALLITEMS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; 取消后续的 $LVN_DELETEITEM 消息
;~ 					;Return False ; 接收后续的 $LVN_DELETEITEM 消息
;~ 				Case $LVN_DELETEITEM ; 即将删除一项
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_DELETEITEM" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; 没有返回值
;~ 				Case $LVN_ENDLABELEDIT ; 结束编辑某项的标签
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_ENDLABELEDIT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; 如果 Text 非空, 返回 True 则设置项目标签为编辑的文本, 而返回 false 则丢弃编辑的文本
;~ 					; 如果 Text 为空, 则忽略返回值
;~ 					Return True
;~ 				Case $LVN_ENDSCROLL ; 滚动操作结束, 最低操作系统为 WinXP
;~ 					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
;~ 					_DebugPrint("$LVN_ENDSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @LF & _
;~ 							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
;~ 					; 没有返回值
;~ 				Case $LVN_GETDISPINFO ; 提供用于显示或排序列表视图项目的信息
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_GETDISPINFO" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; 没有返回值
;~ 				Case $LVN_GETINFOTIP ; 由含有 $LVS_EX_INFOTIP 扩展样式的大图标视图的列表视图控件发送
;~ 					$tInfo = DllStructCreate($tagNMLVGETINFOTIP, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_GETINFOTIP" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam"))
;~ 					; 没有返回值
;~ 				Case $LVN_HOTTRACK ; 当用户在某项上移动鼠标时由列表视图控件发送
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_HOTTRACK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return 0 ; 允许列表视图执行其正常的跟踪选择处理
;~ 					;Return 1 ; 项目将不被选择.
;~ 				Case $LVN_INSERTITEM ; 插入了一个新项目
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_INSERTITEM" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; 没有返回值
;~ 				Case $LVN_ITEMACTIVATE ; 当用户激活项目时由列表视图控件发送
;~ 					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMACTIVATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
;~ 					Return 0
;~ 				Case $LVN_ITEMCHANGED ; 改变了一项
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMCHANGED" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; 没有返回值
;~ 				Case $LVN_ITEMCHANGING ; 正在改变一项
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMCHANGING" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; 阻止改变
;~ 					;Return False ; 允许改变
				Case $LVN_KEYDOWN ; 按下了一个按键
					$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
					_DebugPrint("$LVN_KEYDOWN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->VKey:" & @TAB & DllStructGetData($tInfo, "VKey") & @LF & _
							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags"))
					; 没有返回值
;~ 				Case $LVN_MARQUEEBEGIN ; 一个边界框 (遮篷) 选区已经开始
;~ 					_DebugPrint("$LVN_MARQUEEBEGIN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
;~ 					Return 0 ; 接受消息
;~ 					;Return 1 ; 退出边界框选区
;~ 				Case $LVN_SETDISPINFO ; 更新它维持的项目信息
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_SETDISPINFO" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; 没有返回值
				Case $NM_CLICK ; 当用户用鼠标左键点击了一项时由列表视图控件发送
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; 没有返回值
				Case $NM_DBLCLK ; 当用户用鼠标左键双击了一项时由列表视图控件发送
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; 没有返回值
;~ 				Case $NM_HOVER ; 当在某项上悬停鼠标时由列表视图发送
;~ 					_DebugPrint("$NM_HOVER" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
;~ 					Return 0 ; 正常处理悬停
;~ 					;Return 1 ; 阻止处理悬停
				Case $NM_KILLFOCUS ; 控件失去了输入焦点
					_DebugPrint("$NM_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $NM_RCLICK ; 当用户用鼠标右键点击了一项时由列表视图发送
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					;Return 1 ; 不允许进行默认处理
					Return 0 ; 允许进行默认处理
				Case $NM_RDBLCLK ; 当用户用鼠标右键双击了一项时由列表视图控件发送
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; 没有返回值
				Case $NM_RETURN ; 控件有输入焦点且用户按下了回车键
					_DebugPrint("$NM_RETURN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
				Case $NM_SETFOCUS ; 控件接收到输入焦点
					_DebugPrint("$NM_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 没有返回值
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint
