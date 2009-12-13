; *******************************************************
; 例 1 - 打开带有表单示例的浏览器, 填充表单字段并提交表单
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
$oText = _IEFormElementGetObjByName ($oForm, "textExample")
_IEFormElementSetValue ($oText, "嘿! 成功了!")
_IEFormSubmit ($oForm)

; *******************************************************
; 例 2 - 获取指定表单元素的引用并设置其值.
;     在此例中, 向Google搜索引擎提交一个查询
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetObjByName ($oIE, "f")
$oQuery = _IEFormElementGetObjByName ($oForm, "q")
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm)

; *******************************************************
; 例 3 - 获取指定表单元素的引用并设置其值.
;     如果默认的_IELoadWait发生错误手动调用_IELoadWait.
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetObjByName ($oIE, "f")
$oQuery = _IEFormElementGetObjByName ($oForm, "q")
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm, 0)
_IELoadWait($oIE)