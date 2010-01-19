#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

GUICreate("My GUI")  ; 创建一个居中显示的 GUI 窗口

$nEdit = GUICtrlCreateEdit ("line 0", 10,10)
GUICtrlCreateButton ("Ok", 20,200,50)

GUISetState ()

For $n=1 To 5
GUICtrlSetData ($nEdit, "line "& $n)
Next

; 运行界面，直到窗口被关闭
Do
	$msg = GUIGetMsg()
	If $msg >0 Then
        $a=GUICtrlRecvMsg($nEdit, $EM_GETSEL)
        If @error = 0 Then
	        GUICtrlSetState($nEdit,$GUI_FOCUS)	; 控件将会得到编辑框输入/选择焦点. 
            ; 调用本函数时未指定 wParam 和 lParam类型 这两个参数则函数将返回一个含有两个元素的数组
		    MsgBox(0,"当前选择",StringFormat("start=%d end=%d", $a[0], $a[1]))
		Else
			MsgBox(0,"当前选择","start=0 end=0")
		EndIf
	EndIf
Until $msg = $GUI_EVENT_CLOSE
