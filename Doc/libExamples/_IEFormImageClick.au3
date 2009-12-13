; *******************************************************
; 例 1 - 打开带有表单示例的浏览器, 点击带有可选文本的<input type=image>表单元素
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
_IEFormImageClick ($oIE, "AutoIt Homepage", "alt")

; *******************************************************
; 例 2 - 打开带有表单示例的浏览器, 点击带有匹配图像源地址<input type=image>表单元素
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
_IEFormImageClick ($oIE, "autoit_6_240x100.jpg", "src")

; *******************************************************
; 例 3 - 打开带有表单示例的浏览器, 点击带有匹配名称<input type=image>表单元素
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("form")
_IEFormImageClick ($oIE, "imageExample", "name")