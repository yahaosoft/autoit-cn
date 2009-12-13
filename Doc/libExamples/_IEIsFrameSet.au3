; *******************************************************
; 例 1 - 显示框架集合示例, 获取框架集, 检查框架数量,
;       显示框架数量或iFrames百分数
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("frameset")
$oFrames = _IEFrameGetCollection ($oIE)
$iNumFrames = @extended
If $iNumFrames > 0 Then
	If _IEIsFrameSet ($oIE) Then
		MsgBox(0, "框架信息", "在这个框架集合中有" & $iNumFrames & "个框架")
	Else
		MsgBox(0, "框架信息", "页面有" & $iNumFrames & "个框架")
	EndIf
Else
	MsgBox(0, "框架信息", "页面内没有框架")
EndIf