#include <GuiConstantsEx.au3>
#include <GuiHeader.au3>
#include <WindowsConstants.au3>

$Debug_HDR = False ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hHeader

_Main()

Func _Main()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("Header", 400, 300)
	$hHeader = _GUICtrlHeader_Create($hGUI)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 添加列
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 4", 100)

	; 清除所有的筛选器
	_GUICtrlHeader_ClearFilterAll($hHeader)

	MsgBox(4096, "Information", "About to Destroy Header")

	_GUICtrlHeader_Destroy($hHeader)

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iCode
	Local $tNMHDR, $tNMHEADER, $tNMHDFILTERBTNCLICK, $tNMHDDISPINFO

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hHeader
			Switch $iCode
				Case $HDN_BEGINDRAG ; 在标题控件的某项上拖动操作开始时由标题控件发送
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_BEGINDRAG" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					Return False ; 允许标题控件自动管理拖放操作
;~ 						Return True  ; 表示外部 (手动) 的拖放管理允许控件的所有者
					; 提供自定义服务作为拖放过程的一部分
				Case $HDN_BEGINTRACK, $HDN_BEGINTRACKW ; 通告标题控件的父窗口用户已经拖动控件上的分隔符
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_BEGINTRACK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					Return False ; 允许跟踪分隔符
;~ 						Return True  ; 阻止跟踪
				Case $HDN_DIVIDERDBLCLICK, $HDN_DIVIDERDBLCLICKW ; 通告标题控件的父窗口用户双击了控件的分隔符区域
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_DIVIDERDBLCLICK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_ENDDRAG ; 在标题控件的某项上拖动操作结束时由标题控件发送
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ENDDRAG" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					Return False ; 允许控件自动放置和重新排序项目
;~ 						Return True  ; 阻止项目被放置
				Case $HDN_ENDTRACK, $HDN_ENDTRACKW ; 通告标题控件的父窗口用户已结束拖动分隔符
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ENDTRACK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_FILTERBTNCLICK ; 当筛选器按钮被点击或为响应 $HDM_SETITEM 消息时通告标题控件的父窗口
					$tNMHDFILTERBTNCLICK = DllStructCreate($tagNMHDFILTERBTNCLICK, $ilParam)
					_DebugPrint("$HDN_FILTERBTNCLICK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Item") & @LF & _
							"-->Left:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Left") & @LF & _
							"-->Top:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Top") & @LF & _
							"-->Right:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Right") & @LF & _
							"-->Bottom:" & @TAB & DllStructGetData($tNMHDFILTERBTNCLICK, "Bottom"))
;~ 						Return True  ; $HDN_FILTERCHANGE 通告将被发送给标题控件的父窗口
					; 此通告为父窗口提供了一个同步其用户界面元素的机会
					Return False ; 如果您不想发送此通告
				Case $HDN_FILTERCHANGE ; 通告标题控件的父窗口标题控件筛选器的属性正在被改变或编辑
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_FILTERCHANGE" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_GETDISPINFO, $HDN_GETDISPINFOW ; 当控件需要关于回调标题项的信息时发送给标题控件的所有者
					$tNMHDDISPINFO = DllStructCreate($tagNMHDDISPINFO, $ilParam)
					_DebugPrint("$HDN_GETDISPINFO" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHDDISPINFO, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHDDISPINFO, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHDDISPINFO, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHDDISPINFO, "Item"))
;~ 						Return LRESULT
				Case $HDN_ITEMCHANGED, $HDN_ITEMCHANGEDW ; 通告标题控件的父窗口标题项的属性已改变
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ITEMCHANGED" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_ITEMCHANGING, $HDN_ITEMCHANGINGW ; 通告标题控件的父窗口标题项的属性即将改变
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ITEMCHANGING" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					Return False ; 允许改变
;~ 						Return True  ; 阻止它们
				Case $HDN_ITEMCLICK, $HDN_ITEMCLICKW ; 通告标题控件的父窗口用户点击了控件
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ITEMCLICK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_ITEMDBLCLICK, $HDN_ITEMDBLCLICKW ; 通告标题控件的父窗口用户双击了控件
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_ITEMDBLCLICK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					; 没有返回值
				Case $HDN_TRACK, $HDN_TRACKW ; 通告标题控件的父窗口用户正拖动标题控件上的分隔符
					$tNMHEADER = DllStructCreate($tagNMHEADER, $ilParam)
					_DebugPrint("$HDN_TRACK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMHEADER, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMHEADER, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMHEADER, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tNMHEADER, "Item") & @LF & _
							"-->Button:" & @TAB & DllStructGetData($tNMHEADER, "Button"))
					Return False ; 继续跟踪分隔符
;~ 						Return True  ; 结束跟踪
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
