; *******************************************************
; 例 1 - 浏览AutoIt主页, 得到文档(网页HTML)对象的引用然后显示文档的指定属性
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com")
$oDoc = _IEDocGetObj ($oIE)
MsgBox(0, "文档已经创建的数据", $oDoc.fileCreatedDate)