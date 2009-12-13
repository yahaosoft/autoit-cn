; *******************************************************
; 例 1 - 打开带有基本示例的浏览器, 获取链接集合, 浏览项目并显示相关链接的URL引用
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oLinks = _IELinkGetCollection ($oIE)
$iNumLinks = @extended
MsgBox(0, "链接信息", "一共找到" & $iNumLinks & "个链接")
For $oLink In $oLinks
	MsgBox(0, "链接信息", $oLink.href)
Next