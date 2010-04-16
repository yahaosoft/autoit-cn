; *******************************************************
; 例 1 - 打开带表单实例的浏览器, 获取表单引用, 按值选中和不选复选框.
;     由于未指定$s_Name, 将操作表单中所有<input type=checkbox>
;     元素的集合.
;     说明: 可能需要向下滚动页面以查看变化
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckboxSelect ($oForm, "gameBasketball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameFootball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameTennis", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameBaseball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameBasketball", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameFootball", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameTennis", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, "gameBaseball", "", 0, "byValue")
	Sleep(1000)
Next

; *******************************************************
; 例 2 - 打开带表单实例的浏览器, 获取表单引用, 按索引选中和不选复选框.
;     由于未指定$s_Name, , 将操作表单中所有<input type=checkbox>
;     元素的集合.
;     说明: 可能需要向下滚动页面以查看变化
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckboxSelect ($oForm, 3, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 2, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 1, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 0, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 3, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 2, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 1, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 0, "", 0, "byIndex")
	Sleep(1000)
Next

; *******************************************************
; 例 3 - 打开带表单实例的浏览器, 获取表单实例, 按索引选中和不选
;     在共享checkboxG2Example名称的组中的复选框
;     说明: 可能需要向下滚动页面以查看变化
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckboxSelect ($oForm, 0, "checkboxG2Example", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 1, "checkboxG2Example", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 0, "checkboxG2Example", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckboxSelect ($oForm, 1, "checkboxG2Example", 0, "byIndex")
	Sleep(1000)
Next