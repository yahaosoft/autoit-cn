; *******************************************************
; 示例 1 - 打开含表单示例的浏览器, 设置文本表单元素的值
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("form")
Local $oForm = _IEFormGetObjByName($oIE, "ExampleForm")
Local $oText = _IEFormElementGetObjByName($oForm, "textExample")
_IEFormElementSetValue($oText, "Hey! This works!")

; *******************************************************
; 示例 2 - 获取到指定表单元素的引用并设置它的值.
;				这里, 提交查询到谷歌搜索引擎
; *******************************************************

#include <IE.au3>

$oIE = _IECreate("http://www.google.com")
$oForm = _IEFormGetObjByName($oIE, "f")
Local $oQuery = _IEFormElementGetObjByName($oForm, "q")
_IEFormElementSetValue($oQuery, "AutoIt IE.au3")
_IEFormSubmit($oForm)

; *******************************************************
; 示例 3 - 登录 Hotmail
; *******************************************************

#include <IE.au3>

; 创建浏览器窗口并导航到 hotmail
$oIE = _IECreate("http://www.hotmail.com")

; 获取到登录表单和用户名, 密码和登录字段的指针
Local $o_form = _IEFormGetObjByName($oIE, "f1")
Local $o_login = _IEFormElementGetObjByName($o_form, "login")
Local $o_password = _IEFormElementGetObjByName($o_form, "passwd")
Local $o_signin = _IEFormElementGetObjByName($o_form, "SI")

Local $username = "your username here"
Local $password = "your password here"

; 设置字段值并提交表单
_IEFormElementSetValue($o_login, $username)
_IEFormElementSetValue($o_password, $password)
_IEAction($o_signin, "click")

; *******************************************************
; 示例 4 - 设置 INPUT TYPE=FILE 元素的值
;				(由于安全限制而阻止使用 _IEFormElementSetValue)
; *******************************************************

#include <IE.au3>

$oIE = _IE_Example("form")
$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
Local $oInputFile = _IEFormElementGetObjByName($oForm, "fileExample")

; 把输入焦点定位到这个字段然后发送文本字符串
_IEAction($oInputFile, "focus")
Send("C:\myfile.txt")

; *******************************************************
; 示例 5 - 设置 INPUT TYPE=FILE 元素的值
;				和前一个示例相同, 不过这里操作于不可见窗口
;				(由于安全限制而阻止使用 _IEFormElementSetValue)
; *******************************************************
;
#include <IE.au3>

$oIE = _IE_Example("form")

; 隐藏浏览器窗口来演示发送文本到不可见窗口
_IEAction($oIE, "invisible")

$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
$oInputFile = _IEFormElementGetObjByName($oForm, "fileExample")

; 把输入焦点定位到这个字段然后发送文本字符串
_IEAction($oInputFile, "focus")
Local $hIE = _IEPropertyGet($oIE, "hwnd")
ControlSend($hIE, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "C:\myfile.txt")

MsgBox(0, "Success", "Value set to C:\myfile.txt")
_IEAction($oIE, "visible")
