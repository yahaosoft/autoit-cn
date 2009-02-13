;示例1
;获取窗口句柄与使用 WinGetPos获取窗口矩形
$hwnd	= WinGetHandle("")
$coor	= WinGetPos($hwnd)

;建立 struct
$rect	= DllStructCreate("int;int;int;int")

;生成 DllCall
DLLCall("user32.dll","int","GetWindowRect", _
		"hwnd",$hwnd, _
		"ptr",DllStructGetPtr($rect)) ; 当使用 DllStructGetPtr 调用 DllCall 时

;获取送回的矩形
$l = DllStructGetData($rect,1)
$t = DllStructGetData($rect,2)
$r = DllStructGetData($rect,3)
$b = DllStructGetData($rect,4)

;释放 struct
$rect = 0

;显示 WinGetPos 的结果和被送回的矩形
MsgBox(0,"Larry 测试 :)","WinGetPos(): (" & $coor[0] & "," & $coor[1] & _
		") (" & $coor[2] + $coor[0] & "," & $coor[3] + $coor[1] & ")" & @CRLF & _
		"GetWindowRect(): (" & $l & "," & $t & ") (" & $r & "," & $b & ")")

;示例2
; DllStructGetPtr 参考的一个项目
$a			= DllStructCreate("int")
if @error Then
	MsgBox(0,"","DllStructCreate 错误" & @error);
	exit
endif

$b	= DllStructCreate("uint",DllStructGetPtr($a,1))
if @error Then
	MsgBox(0,"","DllStructCreate 错误 " & @error);
	exit
endif

$c	= DllStructCreate("float",DllStructGetPtr($a,1))
if @error Then
	MsgBox(0,"","DllStructCreate 错误 " & @error);
	exit
endif

;设定数据
DllStructSetData($a,1,-1)

;=========================================================
;	显示相同数据的不同类型
;=========================================================
MsgBox(0,"DllStruct", _
		"int: " & DllStructGetData($a,1) & @CRLF & _
		"uint: " & DllStructGetData($b,1) & @CRLF & _
		"float: " & DllStructGetData($c,1) & @CRLF & _
		"")

; 释放内存分配
$a = 0
