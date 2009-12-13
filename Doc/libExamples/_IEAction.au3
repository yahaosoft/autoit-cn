; ***************************************************************
; 例 1 - 打开一个带有表单实例的浏览器窗口, 获取按名称的提交按钮参考
;    并"点击". 该提交表单技术非常有用, 因为许多依赖于JavaScript
;    代码的表单及提交按钮的"onClick"事件无法使_IEFormSubmit()按
;    预期执行
; ***************************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oSubmit = _IEGetObjByName ($oIE, "submitExample")
_IEAction ($oSubmit, "click")
_IELoadWait ($oIE)

; *******************************************************
; 例 2 - 与例1相同, 不过使用给定元素焦点并使用ControlSend发送Enter来代替点击.
;    当浏览器方的点击操作阻止控件自动回应你的代码是使用该技术.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oSubmit = _IEGetObjByName ($oIE, "submitExample")
$hwnd = _IEPropertyGet($oIE, "hwnd")
_IEAction ($oSubmit, "focus")
ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")

; 等待提示窗口, 然后点击 OK
WinWait("Windows Internet Explorer", "ExampleFormSubmitted")
ControlClick("Windows Internet Explorer", "ExampleFormSubmitted", "[CLASS:Button; TEXT:OK; Instance:1;]")
_IELoadWait ($oIE)


