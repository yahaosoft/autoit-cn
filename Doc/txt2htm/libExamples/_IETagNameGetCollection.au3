; *******************************************************
; 例 1 - 打开带有表单示例的浏览器, 获取所有INPUT标签的集合并显示每个表单名和类型
; *******************************************************
#include <IE.au3>
$oIE = _IE_Example ("form")
$oInputs = _IETagNameGetCollection ($oIE, "input")
For $oInput In $oInputs
	MsgBox(0, "表单输入类型", "Form: " & $oInput.form.name & " Type: " & $oInput.type)
Next