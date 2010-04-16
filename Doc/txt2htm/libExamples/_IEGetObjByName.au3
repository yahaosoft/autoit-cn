; *******************************************************
; 例 1 - 打开带表单示例的浏览器, 获取指向名为"ExampleForm"的元素的对象. 在此例中,
;     结果使用$oForm = _IEFormGetObjByName($oIE, "ExampleForm")辨认
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEGetObjByName ($oIE, "ExampleForm")