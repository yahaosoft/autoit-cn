; *******************************************************
; 例 1 - 打开浏览器的基本示例, 获取指向ID为"line1"的DIV元素的对象.
;     将该元素的内部文本显示到控制台.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oDiv = _IEGetObjById ($oIE, "line1")
ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)