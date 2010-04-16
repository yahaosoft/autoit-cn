; *******************************************************
; 例 1 - 打开带有表单示例的浏览器, 设置文本表单元素的值
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
$oForm = _IEFormGetObjByName ($oIE, "ExampleForm")
$oText = _IEFormElementGetObjByName ($oForm, "textExample")
_IEFormElementSetValue ($oText, "Hey! This works!")

; *******************************************************
; 例 2 - 获取指定表单元素的实例并设置其值.
;     在此例中, 向Google搜索引擎提交查询
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetObjByName ($oIE, "f")
$oQuery = _IEFormElementGetObjByName ($oForm, "q")
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm)

; *******************************************************
; 例 3 - 登录Hotmail
; *******************************************************
;
#include <IE.au3>
; 创建浏览器窗口并浏览hotmail
$oIE = _IECreate ("http://www.hotmail.com")

; 获取登录表单的指针和用户名, 密码及登录区
$o_form = _IEFormGetObjByName ($oIE, "f1")
$o_login = _IEFormElementGetObjByName ($o_form, "login")
$o_password = _IEFormElementGetObjByName ($o_form, "passwd")
$o_signin = _IEFormElementGetObjByName ($o_form, "SI")

$username = "这里是你的用户名"
$password = "这里是你的密码"

; 设置字段值并提交表单
_IEFormElementSetValue ($o_login, $username)
_IEFormElementSetValue ($o_password, $password)
_IEAction ($o_signin, "click")

; *******************************************************
; 例 4 - 设置一个INPUT TYPE=FILE元素的值
;     (安全限制阻止使用_IEFormElementSetValue)
; *******************************************************
;
#include <IE.au3>

$oIE = _IE_Example("form")
$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
$oInputFile = _IEFormElementGetObjByName($oForm, "fileExample")

; 将输入焦点指定到字段然后发送文本字符串
_IEAction($oInputFile, "focus")
Send("C:\myfile.txt")

; *******************************************************
; 例 5 - 设置INPUT TYPE=FILE元素的值
;     和前例相同, 但是是一个不可见窗口
;     (安全限制阻止使用_IEFormElementSetValue)
; *******************************************************
;
#include <IE.au3>

$oIE = _IE_Example("form")

; 隐藏浏览器窗口以示范向不可见窗口发送文本
_IEAction($oIE, "invisible")

$oForm = _IEFormGetObjByName($oIE, "ExampleForm")
$oInputFile = _IEFormElementGetObjByName($oForm, "fileExample")

; 将输入焦点指定到字段然后发送文本字符串
_IEAction($oInputFile, "focus")
$hIE = _IEPropertyGet($oIE, "hwnd")
ControlSend($hIE, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "C:\myfile.txt")

MsgBox(0, "成功", "值设置到C:\myfile.txt")
_IEAction($oIE, "visible")
