; *******************************************************
; 例 1 - 打开表单示例的浏览器, 设置表单元素的文本值, 并从元素获取并显示该值
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
$oText = _IEFormElementGetObjByName ($oForm, "textExample")
$IEAu3Version = _IE_VersionInfo ()
_IEFormElementSetValue ($oText, $IEAu3Version[5])
MsgBox(0, "表单元素的值", _IEFormElementGetValue ($oText))