; *******************************************************
; 例 1 - 获取指定的0基索引的表单的引用,
;     此例为页面上的首个表单
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.google.com")
$oForm = _IEFormGetCollection ($oIE, 0)
$oQuery = _IEFormElementGetCollection ($oForm, 1)
_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
_IEFormSubmit ($oForm)

; *******************************************************
; 例 2 - 获取页上表单集合的引用, 然后循环显示每个信息
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com")
$oForms = _IEFormGetCollection ($oIE)
MsgBox(0, "表单总计", "现在有" & @extended & "个表单在这个页面上")
For $oForm In $oForms
	MsgBox(0, "表单信息", $oForm.name)
Next

; *******************************************************
; 例 3 - 获取页上表单集合的引用, 然后循环显示每个信息以示范表单索引的用法
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com")
$oForms = _IEFormGetCollection ($oIE)
$iNumForms = @extended
MsgBox(0, "表单总计", "现在有" & $iNumForms & "个表单在这个页面上")
For $i = 0 to $iNumForms - 1
	$oForm = _IEFormGetCollection ($oIE, $i)
	MsgBox(0, "表单信息", $oForm.name)
Next