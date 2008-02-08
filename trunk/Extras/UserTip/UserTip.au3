#cs ----------------------------------------------------------------------------

 AutoIt 版本: 3.2.3.6(第四版)
 脚本作者: thesnow
	Email: rundll32@126.com
	QQ/TM: 133333542
 脚本版本: 0.1
 脚本功能: Autoit相关技巧.

#ce ----------------------------------------------------------------------------

; 脚本开始 - 在这后面添加您的代码.
If FileExists(@ScriptDir & "\TIP.TXT") <> 1 Then
	MsgBox(32,"出现错误!","TIP.TXT 丢失,请重新安装本程序. T_T")
	Exit
EndIf
$win = "Autoit TIP"
If WinExists($win) Then Exit
AutoItWinSetTitle($win)	
#compiler_allow_decompile=no
#include <GUIConstants.au3>
#NoTrayIcon
$OnRead=IniRead(@ScriptDir & "\TIP.TXT","TIP","OnRead","1")
$ALLTIP=IniRead(@ScriptDir & "\TIP.TXT","TIP","ALLTIP","1")

#Region 创建GUI
$gui = GUICreate("Autoit 技巧 V0.1", 628, 226, 203, 168)
GUISetIcon("shell32.dll",Random(1,200,1),$gui)
$MonthCal1 = GUICtrlCreateMonthCal(@YEAR & "/" & @MON & "/" & @MDAY, 0, 0, 283, 185)
$Group = GUICtrlCreateGroup("Autoit 技巧", 288, 0, 329, 185)
$TIP = GUICtrlCreateInput("Autoit 技巧 V0.1" & @CRLF & @CR & "版权所有(C) 2007 thesnow", 296, 16, 313, 160, 0x50200104,0x00000200)
GUICtrlSetFont(-1, 9, 400, 0, "宋体")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$UP = GUICtrlCreateButton("上一个", 392, 192, 81, 25, 0)
$NEXT = GUICtrlCreateButton("下一个", 488, 192, 81, 25, 0)
$About = GUICtrlCreateLabel("CopyRight(C)2007 thesnow ", 8, 200, 272, 17)
GUISetState(@SW_SHOW)
#EndRegion GUI创建完成
_TIP_TEXT($OnRead)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
		IniWrite(@ScriptDir & "\TIP.TXT","TIP","OnRead",$OnRead)
		Exit
	Case $UP
		if $OnRead = 1 Then 
			MsgBox(32,"没有了啦!","前面已经没有了啦!",2)
		Else
			$OnRead=$OnRead-1
			_TIP_TEXT($OnRead)
		EndIf
	Case $NEXT
		if $OnRead = $ALLTIP Then 
			MsgBox(32,"没有了啦!","后面已经没有了啦!",2)
		Else
			$OnRead=$OnRead+1
			_TIP_TEXT($OnRead)
		EndIf		
	EndSwitch
WEnd

Func _TIP_TEXT($TIPNO)
	$TIPTEXT=IniRead(@ScriptDir & "\TIP.TXT","TIP",$TIPNO,"貌似读取出现了错误!")
	$TIPTEXT=StringReplace($TIPTEXT,"{换行}",@crlf)
	GUICtrlSetData($TIP,$TIPTEXT)
	Return $TIPTEXT
EndFunc