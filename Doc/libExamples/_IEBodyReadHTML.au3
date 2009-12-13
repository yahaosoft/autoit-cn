; *******************************************************
; 例 1 - 打开带有示例的浏览器, 准备主体HTML, 添加新的HTML并写回浏览器
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$sHTML = _IEBodyReadHTML ($oIE)
$sHTML = $sHTML & "<p><font color=red size=+5>大号的 红色的 文本!</font>"
_IEBodyWriteHTML ($oIE, $sHTML)