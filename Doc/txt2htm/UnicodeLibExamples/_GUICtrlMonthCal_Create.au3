#include <GuiConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>

$Debug_MC = False ; 检查传递给 MonthCal 函数的类名, 设置为真并使用另一控件的句柄可以看出它是否有效

Global $hMonthCal

_Main()

Func _Main()
	Local $hGUI

	; 创建 GUI
	$hGUI = GUICreate("Month Calendar Create", 400, 300)
	$hMonthCal = _GUICtrlMonthCal_Create($hGUI, 4, 4, $WS_BORDER)
	GUISetState()

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; 循环直到用户退出
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>_Main

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $tInfo

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hMonthCal
			Switch $iCode
				Case $MCN_GETDAYSTATE ; 由月历控件发送以请求关于个别日子如何显示的信息
					$tInfo = DllStructCreate($tagNMDAYSTATE, $ilParam)
					_DebugPrint("$MCN_GETDAYSTATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->Year:" & @TAB & DllStructGetData($tInfo, "Year") & @LF & _
							"-->Month:" & @TAB & DllStructGetData($tInfo, "Month") & @LF & _
							"-->DOW:" & @TAB & DllStructGetData($tInfo, "DOW") & @LF & _
							"-->Day:" & @TAB & DllStructGetData($tInfo, "Day") & @LF & _
							"-->Hour:" & @TAB & DllStructGetData($tInfo, "Hour") & @LF & _
							"-->Minute:" & @TAB & DllStructGetData($tInfo, "Minute") & @LF & _
							"-->Second:" & @TAB & DllStructGetData($tInfo, "Second") & @LF & _
							"-->MSecond:" & @TAB & DllStructGetData($tInfo, "MSecond") & @LF & _
							"-->DayState:" & @TAB & DllStructGetData($tInfo, "DayState") & @LF & _
							"-->pDayState:" & @TAB & DllStructGetData($tInfo, "pDayState"))
					; MONTHDAYSTATE 数组的地址 (DWORD 位字段保存了一个月份中每天的状态)
					; 每位 (从 1 到 31) 表示一个月份中每天的状态. 如果某位是起作用的, 则相应的日子将
					; 粗体显示; 否则显示时不进行强调.
					; 没有返回值
				Case $MCN_SELCHANGE ; 当当前选择了日期或日期范围改变时由月历控件发送
					$tInfo = DllStructCreate($tagNMSELCHANGE, $ilParam)
					_DebugPrint("$MCN_SELCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->BegYear:" & @TAB & DllStructGetData($tInfo, "BegYear") & @LF & _
							"-->BegMonth:" & @TAB & DllStructGetData($tInfo, "BegMonth") & @LF & _
							"-->BegDOW:" & @TAB & DllStructGetData($tInfo, "BegDOW") & @LF & _
							"-->BegDay:" & @TAB & DllStructGetData($tInfo, "BegDay") & @LF & _
							"-->BegHour:" & @TAB & DllStructGetData($tInfo, "BegHour") & @LF & _
							"-->BegMinute:" & @TAB & DllStructGetData($tInfo, "BegMinute") & @LF & _
							"-->BegSecond:" & @TAB & DllStructGetData($tInfo, "BegSecond") & @LF & _
							"-->BegMSeconds:" & @TAB & DllStructGetData($tInfo, "BegMSeconds") & @LF & _
							"-->EndYear:" & @TAB & DllStructGetData($tInfo, "EndYear") & @LF & _
							"-->EndMonth:" & @TAB & DllStructGetData($tInfo, "EndMonth") & @LF & _
							"-->EndDOW:" & @TAB & DllStructGetData($tInfo, "EndDOW") & @LF & _
							"-->EndDay:" & @TAB & DllStructGetData($tInfo, "EndDay") & @LF & _
							"-->EndHour:" & @TAB & DllStructGetData($tInfo, "EndHour") & @LF & _
							"-->EndMinute:" & @TAB & DllStructGetData($tInfo, "EndMinute") & @LF & _
							"-->EndSecond:" & @TAB & DllStructGetData($tInfo, "EndSecond") & @LF & _
							"-->EndMSeconds:" & @TAB & DllStructGetData($tInfo, "EndMSeconds"))
					; 没有返回值
				Case $MCN_SELECT ; 当用户在月历控件内选择了一个明确的日期时由月历控件发送
					$tInfo = DllStructCreate($tagNMSELCHANGE, $ilParam)
					_DebugPrint("$MCN_SELECT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode & @LF & _
							"-->BegYear:" & @TAB & DllStructGetData($tInfo, "BegYear") & @LF & _
							"-->BegMonth:" & @TAB & DllStructGetData($tInfo, "BegMonth") & @LF & _
							"-->BegDOW:" & @TAB & DllStructGetData($tInfo, "BegDOW") & @LF & _
							"-->BegDay:" & @TAB & DllStructGetData($tInfo, "BegDay") & @LF & _
							"-->BegHour:" & @TAB & DllStructGetData($tInfo, "BegHour") & @LF & _
							"-->BegMinute:" & @TAB & DllStructGetData($tInfo, "BegMinute") & @LF & _
							"-->BegSecond:" & @TAB & DllStructGetData($tInfo, "BegSecond") & @LF & _
							"-->BegMSeconds:" & @TAB & DllStructGetData($tInfo, "BegMSeconds") & @LF & _
							"-->EndYear:" & @TAB & DllStructGetData($tInfo, "EndYear") & @LF & _
							"-->EndMonth:" & @TAB & DllStructGetData($tInfo, "EndMonth") & @LF & _
							"-->EndDOW:" & @TAB & DllStructGetData($tInfo, "EndDOW") & @LF & _
							"-->EndDay:" & @TAB & DllStructGetData($tInfo, "EndDay") & @LF & _
							"-->EndHour:" & @TAB & DllStructGetData($tInfo, "EndHour") & @LF & _
							"-->EndMinute:" & @TAB & DllStructGetData($tInfo, "EndMinute") & @LF & _
							"-->EndSecond:" & @TAB & DllStructGetData($tInfo, "EndSecond") & @LF & _
							"-->EndMSeconds:" & @TAB & DllStructGetData($tInfo, "EndMSeconds"))
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
