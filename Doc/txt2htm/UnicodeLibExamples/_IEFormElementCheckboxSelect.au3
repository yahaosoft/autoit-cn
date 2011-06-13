; *******************************************************
; 示例 1 - 打开含表单示例的浏览器, 获取到表单的引用, 通过
;				byValue 模式选择或取消选择复选框.  由于没有指定 $s_Name, 所以会作用于
;				表单中所有 <input type=checkbox> 元素的集合上
;				注意: 您可能需要往下滚动页面来查看发生的变化
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("form")
Local $oForm = _IEFormGetObjByName($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckBoxSelect($oForm, "gameBasketball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameFootball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameTennis", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameBaseball", "", 1, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameBasketball", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameFootball", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameTennis", "", 0, "byValue")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, "gameBaseball", "", 0, "byValue")
	Sleep(1000)
Next

; *******************************************************
; 示例 2 - 打开含表单示例的浏览器, 获取到表单的引用, 通过
;				byIndex 模式选择或取消选择复选框.  由于没有指定 $s_Name, 所以会作用于
;				表单中所有 <input type=checkbox> 元素的集合上
;				注意: 您可能需要往下滚动页面来查看发生的变化
; *******************************************************

#include <IE.au3>

$oIE = _IE_Example("form")
$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckBoxSelect($oForm, 3, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 2, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 1, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 0, "", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 3, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 2, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 1, "", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 0, "", 0, "byIndex")
	Sleep(1000)
Next

; *******************************************************
; 示例 3 - 打开含表单示例的浏览器, 获取到表单的引用, 通过
;				byIndex 模式选择或取消选择名称为 checkboxG2Example 的组里面的复选框
;				注意: 您可能需要往下滚动页面来查看发生的变化
; *******************************************************

#include <IE.au3>

$oIE = _IE_Example("form")
$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
For $i = 1 To 5
	_IEFormElementCheckBoxSelect($oForm, 0, "checkboxG2Example", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 1, "checkboxG2Example", 1, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 0, "checkboxG2Example", 0, "byIndex")
	Sleep(1000)
	_IEFormElementCheckBoxSelect($oForm, 1, "checkboxG2Example", 0, "byIndex")
	Sleep(1000)
Next
