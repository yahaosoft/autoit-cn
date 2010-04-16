; *******************************************************
; 例 1 - 打开带表单实例的浏览器, 获取表单引用, 按值选取每个单选按钮,
;     然后不选最后一项使得没有选中项.
;     说明: 可能需要向下滚动页面以查看变化
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementRadioSelect ($oForm, "vehicleAirplane", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, "vehicleTrain", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, "vehicleBoat", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, "vehicleCar", "radioExample", 1, "byValue")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, "vehicleCar", "radioExample", 0, "byValue")
	Sleep(1000)
Next

; *******************************************************
; 例 2 - 打开带表单实例的浏览器, 获取表单引用, 按索引选取每个单选按钮,
;     然后不选最后一项使得没有选中项.
;     说明: 可能需要向下滚动页面以查看变化
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementRadioSelect ($oForm, 3, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, 2, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, 1, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, 0, "radioExample", 1, "byIndex")
	Sleep(1000)
	_IEFormElementRadioSelect ($oForm, 0, "radioExample", 0, "byIndex")
	Sleep(1000)
Next