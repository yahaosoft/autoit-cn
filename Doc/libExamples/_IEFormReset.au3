; *******************************************************
; 例 1 - 打开带有表单示例的浏览器, 填充表单字段并将表单重设回默认值
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
$oText = _IEFormElementGetObjByName ($oForm, "textExample")
_IEFormElementSetValue ($oText, "嘿! 成功了!")
_IEFormReset ($oForm)
