; *******************************************************
; 示例 1 - 根据基于 0 的索引获取到特定表单元素的引用.
;				这里, 提交查询到谷歌搜索引擎
; *******************************************************

#include <IE.au3>

Local $oIE = _IECreate("http://www.google.com")
Local $oForm = _IEFormGetCollection($oIE, 0)
Local $oQuery = _IEFormElementGetCollection($oForm, 2)
_IEFormElementSetValue($oQuery, "AutoIt IE.au3")
_IEFormSubmit($oForm)
