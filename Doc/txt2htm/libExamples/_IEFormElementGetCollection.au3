; *******************************************************
; 例 1 - 通过0基索引获取对指定表单元素的引用.
;     在此例中, 向Google搜索引擎提交一个查询
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetCollection ($oIE, 0)
$oQuery = _IEFormElementGetCollection ($oForm, 1)
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm)