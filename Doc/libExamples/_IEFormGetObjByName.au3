; *******************************************************
; 例 1 - 打开带表单实例的浏览器, 在此例中, 向Google搜索引擎提交一个查询.
;      说明: 表单和表单元素名可通过查看页面HTML源代码找到
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetObjByName ($oIE, "f")
$oQuery = _IEFormElementGetObjByName ($oForm, "q")
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm)