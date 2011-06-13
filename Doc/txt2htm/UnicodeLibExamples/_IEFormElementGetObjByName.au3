; *******************************************************
; 示例 1 - 根据名称获取到特定表单元素的引用.
;				这里, 提交查询到谷歌搜索引擎
; *******************************************************

#include <IE.au3>

Local $oIE = _IECreate("http://www.google.com")
Local $oForm = _IEFormGetObjByName($oIE, "f")
Local $oQuery = _IEFormElementGetObjByName($oForm, "q")
_IEFormElementSetValue($oQuery, "AutoIt IE.au3")
_IEFormSubmit($oForm)
