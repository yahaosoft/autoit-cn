; *******************************************************
; 例 1 - 打开带有iFrame示例的浏览器, 获取名为"iFrameTwo"的iFrame的参考
;        并替换body区的HTML代码.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("iframe")
$oFrame = _IEFrameGetObjByName ($oIE, "iFrameTwo")
_IEBodyWriteHTML ($oFrame, "大家好!我是<b>iFrame!</b>")