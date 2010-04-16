; *******************************************************
; 例 1 - 打开浮动框架示例, 获取以"iFrameTwo"命名的浮动框架的引用
;     并替换其主体代码
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("iframe")
$oFrame = _IEFrameGetObjByName ($oIE, "iFrameTwo")
_IEBodyWriteHTML ($oFrame, "你好 我是<b>iFrame!</b>")
_IELoadWait ($oFrame)