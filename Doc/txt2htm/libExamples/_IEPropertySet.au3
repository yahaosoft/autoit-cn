; *******************************************************
; 例 1 - 打开带有基本示例的浏览器, 检查地址栏是否可见, 如果不是则开启.
;     然后改变显示在状态栏的文本
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
If Not _IEPropertyGet ($oIE, "statusbar") Then _IEPropertySet ($oIE, "statusbar", True)
_IEPropertySet ($oIE, "statustext", "看我能干嘛")
Sleep(1000)
_IEPropertySet ($oIE, "statustext", "我们改变状态栏文本")