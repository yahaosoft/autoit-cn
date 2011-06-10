#include <GuiReBar.au3>
#include <GuiToolBar.au3>
#include <GuiComboBox.au3>
#include <GuiDateTimePicker.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GuiConstantsEx.au3>

$Debug_RB = False

Global $hReBar

_Main()

Func _Main()
	Local $hgui, $btnExit, $hToolbar, $hCombo, $hDTP, $hInput
	Local Enum $idNew = 1000, $idOpen, $idSave, $idHelp

	$hgui = GUICreate("Rebar", 400, 396, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_MAXIMIZEBOX))

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 创建伸缩条控件
	$hReBar = _GUICtrlRebar_Create($hgui, BitOR($CCS_TOP, $WS_BORDER, $RBS_VARHEIGHT, $RBS_AUTOSIZE, $RBS_BANDBORDERS))


	; 在伸缩条中创建一个工具栏
	$hToolbar = _GUICtrlToolbar_Create($hgui, BitOR($TBSTYLE_FLAT, $CCS_NORESIZE, $CCS_NOPARENTALIGN))

	; 添加标准系统位图
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; 添加按钮
	_GUICtrlToolbar_AddButton($hToolbar, $idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($hToolbar, $idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $idHelp, $STD_HELP)

	; 在伸缩条中创建一个组合框
	$hCombo = _GUICtrlComboBox_Create($hgui, "", 0, 0, 120)

	_GUICtrlComboBox_BeginUpdate($hCombo)
	_GUICtrlComboBox_AddDir($hCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($hCombo)

	; 在伸缩条中创建一个日期和时间选取器
	$hDTP = _GUICtrlDTP_Create($hgui, 0, 0, 190)

	; 在伸缩条中创建一个输入框
;~ 	$hInput = GUICtrlCreateInput("Input control", 0, 0, 120, 20)
	$hInput = _GUICtrlEdit_Create($hgui, "Input control", 0, 0, 120, 20)


	; 默认添加是附加的

	; 添加含控件的带区
	_GUICtrlRebar_AddBand($hReBar, $hCombo, 120, 200, "Dir *.exe")

	; 添加含日期和时间选取器的带区
	_GUICtrlRebar_AddBand($hReBar, $hDTP, 120)

	; 添加含伸缩条开始处的工具栏的带区
	_GUICtrlRebar_AddToolBarBand($hReBar, $hToolbar, "", 0)

	;添加另一控件
;~ 	_GUICtrlReBar_AddBand($hReBar, GUICtrlGetHandle($hInput), 120, 200, "Name:")
	_GUICtrlRebar_AddBand($hReBar, $hInput, 120, 200, "Name:")


	$btnExit = GUICtrlCreateButton("Exit", 150, 360, 100, 25)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $btnExit
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
	Local $tAUTOBREAK, $tAUTOSIZE, $tNMREBAR, $tCHEVRON, $tCHILDSIZE, $tOBJECTNOTIFY

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hReBar
			Switch $iCode
				Case $RBN_AUTOBREAK
					; 通告伸缩条的父窗口在伸缩条中将出现断行父窗口决定是否产生断行
					$tAUTOBREAK = DllStructCreate($tagNMREBARAUTOBREAK, $ilParam)
					_DebugPrint("$RBN_AUTOBREAK" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tAUTOBREAK, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tAUTOBREAK, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tAUTOBREAK, "Code") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tAUTOBREAK, "uBand") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tAUTOBREAK, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tAUTOBREAK, "lParam") & @LF & _
							"-->uMsg:" & @TAB & DllStructGetData($tAUTOBREAK, "uMsg") & @LF & _
							"-->fStyleCurrent:" & @TAB & DllStructGetData($tAUTOBREAK, "fStyleCurrent") & @LF & _
							"-->fAutoBreak:" & @TAB & DllStructGetData($tAUTOBREAK, "fAutoBreak"))
					; 不使用返回值
				Case $RBN_AUTOSIZE
					; 当含 $RBS_AUTOSIZE 样式创建的伸缩条自动重设自身大小时由伸缩条控件发送
					$tAUTOSIZE = DllStructCreate($tagNMRBAUTOSIZE, $ilParam)
					_DebugPrint("$RBN_AUTOSIZE" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tAUTOSIZE, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tAUTOSIZE, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tAUTOSIZE, "Code") & @LF & _
							"-->fChanged:" & @TAB & DllStructGetData($tAUTOSIZE, "fChanged") & @LF & _
							"-->TargetLeft:" & @TAB & DllStructGetData($tAUTOSIZE, "TargetLeft") & @LF & _
							"-->TargetTop:" & @TAB & DllStructGetData($tAUTOSIZE, "TargetTop") & @LF & _
							"-->TargetRight:" & @TAB & DllStructGetData($tAUTOSIZE, "TargetRight") & @LF & _
							"-->TargetBottom:" & @TAB & DllStructGetData($tAUTOSIZE, "TargetBottom") & @LF & _
							"-->ActualLeft:" & @TAB & DllStructGetData($tAUTOSIZE, "ActualLeft") & @LF & _
							"-->ActualTop:" & @TAB & DllStructGetData($tAUTOSIZE, "ActualTop") & @LF & _
							"-->ActualRight:" & @TAB & DllStructGetData($tAUTOSIZE, "ActualRight") & @LF & _
							"-->ActualBottom:" & @TAB & DllStructGetData($tAUTOSIZE, "ActualBottom"))
					; 不使用返回值
				Case $RBN_BEGINDRAG
					; 当用户开始拖动带区时由伸缩条控件发送
					$tNMREBAR = DllStructCreate($tagNMREBAR, $ilParam)
					_DebugPrint("$RBN_BEGINDRAG" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMREBAR, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMREBAR, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMREBAR, "Code") & @LF & _
							"-->dwMask:" & @TAB & DllStructGetData($tNMREBAR, "dwMask") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tNMREBAR, "uBand") & @LF & _
							"-->fStyle:" & @TAB & DllStructGetData($tNMREBAR, "fStyle") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tNMREBAR, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tNMREBAR, "lParam"))
					Return 0 ; 允许伸缩条继续拖动操作
;~ 					Return 1 ; 非零值以中断拖动操作
				Case $RBN_CHEVRONPUSHED
					; Sent by a rebar control when a chevron is pushed
					; 当应用程序接收到此通告, 它会响应而显示带每个隐藏工具项的弹出菜单
					; 使用 NMREBARCHEVRON 结构的 rc 成员以找出弹出菜单的正确位置
					$tCHEVRON = DllStructCreate($tagNMREBARCHEVRON, $ilParam)
					_DebugPrint("$RBN_CHEVRONPUSHED" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tCHEVRON, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tCHEVRON, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tCHEVRON, "Code") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tCHEVRON, "uBand") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tCHEVRON, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tCHEVRON, "lParam") & @LF & _
							"-->Left:" & @TAB & DllStructGetData($tCHEVRON, "Left") & @LF & _
							"-->Top:" & @TAB & DllStructGetData($tCHEVRON, "Top") & @LF & _
							"-->Right:" & @TAB & DllStructGetData($tCHEVRON, "Right") & @LF & _
							"-->lParamNM:" & @TAB & DllStructGetData($tCHEVRON, "lParamNM"))
					; 不使用返回值
				Case $RBN_CHILDSIZE
					; 当带区中的子窗口重设大小时由伸缩条控件发送
					$tCHILDSIZE = DllStructCreate($tagNMREBARCHILDSIZE, $ilParam)
					_DebugPrint("$RBN_CHILDSIZE" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tCHILDSIZE, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tCHILDSIZE, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tCHILDSIZE, "Code") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tCHILDSIZE, "uBand") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tCHILDSIZE, "wID") & @LF & _
							"-->CLeft:" & @TAB & DllStructGetData($tCHILDSIZE, "CLeft") & @LF & _
							"-->CTop:" & @TAB & DllStructGetData($tCHILDSIZE, "CTop") & @LF & _
							"-->CRight:" & @TAB & DllStructGetData($tCHILDSIZE, "CRight") & @LF & _
							"-->CBottom:" & @TAB & DllStructGetData($tCHILDSIZE, "CBottom") & @LF & _
							"-->BLeft:" & @TAB & DllStructGetData($tCHILDSIZE, "BandLeft") & @LF & _
							"-->BTop:" & @TAB & DllStructGetData($tCHILDSIZE, "BTop") & @LF & _
							"-->BRight:" & @TAB & DllStructGetData($tCHILDSIZE, "BRight") & @LF & _
							"-->BBottom:" & @TAB & DllStructGetData($tCHILDSIZE, "BBottom"))
					; 不使用返回值
				Case $RBN_DELETEDBAND
					; 删除一个带区后由伸缩条控件发送
					$tNMREBAR = DllStructCreate($tagNMREBAR, $ilParam)
					_DebugPrint("$RBN_DELETEDBAND" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMREBAR, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMREBAR, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMREBAR, "Code") & @LF & _
							"-->dwMask:" & @TAB & DllStructGetData($tNMREBAR, "dwMask") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tNMREBAR, "uBand") & @LF & _
							"-->fStyle:" & @TAB & DllStructGetData($tNMREBAR, "fStyle") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tNMREBAR, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tNMREBAR, "lParam"))
					; 不使用返回值
				Case $RBN_DELETINGBAND
					; 即将删除一个带区时由伸缩条控件发送
					$tNMREBAR = DllStructCreate($tagNMREBAR, $ilParam)
					_DebugPrint("$RBN_DELETINGBAND" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMREBAR, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMREBAR, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMREBAR, "Code") & @LF & _
							"-->dwMask:" & @TAB & DllStructGetData($tNMREBAR, "dwMask") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tNMREBAR, "uBand") & @LF & _
							"-->fStyle:" & @TAB & DllStructGetData($tNMREBAR, "fStyle") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tNMREBAR, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tNMREBAR, "lParam"))
					; 不使用返回值
				Case $RBN_ENDDRAG
					; 当用户停止拖动带区时由伸缩条控件发送
					$tNMREBAR = DllStructCreate($tagNMREBAR, $ilParam)
					_DebugPrint("$RBN_ENDDRAG" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tNMREBAR, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tNMREBAR, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tNMREBAR, "Code") & @LF & _
							"-->dwMask:" & @TAB & DllStructGetData($tNMREBAR, "dwMask") & @LF & _
							"-->uBand:" & @TAB & DllStructGetData($tNMREBAR, "uBand") & @LF & _
							"-->fStyle:" & @TAB & DllStructGetData($tNMREBAR, "fStyle") & @LF & _
							"-->wID:" & @TAB & DllStructGetData($tNMREBAR, "wID") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tNMREBAR, "lParam"))
					; 不使用返回值
				Case $RBN_GETOBJECT
					; 当一个对象在含 $RBS_REGISTERDROP 样式创建的伸缩条控件的带区上拖动时由控件发送
					$tOBJECTNOTIFY = DllStructCreate($tagNMOBJECTNOTIFY, $ilParam)
					_DebugPrint("$RBN_GETOBJECT" & @LF & "--> hWndFrom:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "hWndFrom") & @LF & _
							"-->IDFrom:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "IDFrom") & @LF & _
							"-->Code:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "Code") & @LF & _
							"-->Item:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "Item") & @LF & _
							"-->piid:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "piid") & @LF & _
							"-->pObject:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "pObject") & @LF & _
							"-->Result:" & @TAB & DllStructGetData($tOBJECTNOTIFY, "Result"))
					; 不使用返回值
				Case $RBN_HEIGHTCHANGE
					; 当伸缩条控件的高度已改变时由控件发送
					; 当使用 $CCS_VERT 样式的伸缩条控件的宽度改变时会发送此通告消息
					_DebugPrint("$RBN_HEIGHTCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 不使用返回值
				Case $RBN_LAYOUTCHANGED
					; 当用户改变控件带区的布局时由伸缩条控件发送
					_DebugPrint("$RBN_LAYOUTCHANGED" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; 不使用返回值
				Case $RBN_MINMAX
					; 在最大或最小化带区前由伸缩条控件发送
					_DebugPrint("$RBN_MINMAX" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
;~ 					Return 1 ; 非零值以阻止发生的操作
					Return 0 ; 零则允许操作继续
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
