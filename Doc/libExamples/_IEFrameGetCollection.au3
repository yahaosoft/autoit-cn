; *******************************************************
; 例 1 - 打开框架集示例, 获取框架集合, 并循环显示他们的源地址
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("frameset")
$oFrames = _IEFrameGetCollection ($oIE)
$iNumFrames = @extended
For $i = 0 to ($iNumFrames - 1)
	$oFrame = _IEFrameGetCollection ($oIE, $i)
	MsgBox(0, "框架信息", _IEPropertyGet ($oFrame, "locationurl"))
Next