; *******************************************************
; 示例 1 - 打开含表单示例的浏览器, 填写表单字段并提交表单
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("form")
Local $oForm = _IEFormGetObjByName($oIE, "ExampleForm")
Local $oText = _IEFormElementGetObjByName($oForm, "textExample")
_IEFormElementSetValue($oText, "Hey! It works!")
_IEFormSubmit($oForm)

; *******************************************************
; 示例 2 - 获取到指定表单元素的引用并设置它的值.
;				这里, 提交查询到谷歌搜索引擎
; *******************************************************

#include <IE.au3>

$oIE = _IECreate("http://www.google.com")
$oForm = _IEFormGetObjByName($oIE, "f")
Local $oQuery = _IEFormElementGetObjByName($oForm, "q")
_IEFormElementSetValue($oQuery, "AutoIt IE.au3")
_IEFormSubmit($oForm)

; *******************************************************
; 示例 3 - 获取到指定表单元素的引用并设置它的值.
;				如果默认的 _IELoadWait 感受不佳, 那么手动调用 _IELoadWait.
; *******************************************************

#include <IE.au3>

$oIE = _IECreate("http://www.google.com")
$oForm = _IEFormGetObjByName($oIE, "f")
$oQuery = _IEFormElementGetObjByName($oForm, "q")
_IEFormElementSetValue($oQuery, "AutoIt IE.au3")
_IEFormSubmit($oForm, 0)
_IELoadWait($oIE)
