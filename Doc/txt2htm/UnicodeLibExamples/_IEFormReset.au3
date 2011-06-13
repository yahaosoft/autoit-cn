; *******************************************************
; 示例 1 - 打开含表单示例的浏览器, 填写表单字段
;				并复位表单为默认值
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("form")
Local $oForm = _IEFormGetObjByName($oIE, "ExampleForm")
Local $oText = _IEFormElementGetObjByName($oForm, "textExample")
_IEFormElementSetValue($oText, "Hey! It works!")
_IEFormReset($oForm)
