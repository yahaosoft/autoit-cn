; *******************************************************
; 示例 1 - 打开含表单示例的浏览器, 获取到表单的引用
;				根据 byValue 选择单选按钮, 然后取消选择最后一个已选择的留空项.
;				注意: 您可能需要往下滚动页面来查看发生的变化
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("form")
Local $oForm = _IEFormGetObjByName($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementRadioSelect($oForm, "vehicleAirplane", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, "vehicleTrain", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, "vehicleBoat", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, "vehicleCar", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, "vehicleCar", "radioExample", 0, "byValue")
	Sleep(1000)
Next

; *******************************************************
; 示例 2 - 打开含表单示例的浏览器, 获取到表单的引用
;				根据 byIndex 选择每个单选按钮, 然后取消选择最后一个已选择的留空项.
;				注意: 您可能需要往下滚动页面来查看发生的变化
; *******************************************************

#include <IE.au3>

$oIE = _IE_Example("form")
$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementRadioSelect($oForm, 3, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, 2, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, 1, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, 0, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect($oForm, 0, "radioExample", 0, "byIndex")
	Sleep(1000)
Next
