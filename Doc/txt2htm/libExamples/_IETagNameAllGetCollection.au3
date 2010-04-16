; *******************************************************
; 例 1 - 打开带表单示例的浏览器, 获取所有INPUT标签的集合并显示表单名和类型
; *******************************************************
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oElements = _IETagNameAllGetCollection ($oIE)
For $oElement In $oElements
	MsgBox(0, "元素信息", "Tagname: " & $oElement.tagname & @CR & "innerText: " & $oElement.innerText)
Next