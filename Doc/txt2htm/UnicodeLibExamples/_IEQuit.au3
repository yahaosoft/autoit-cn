; *******************************************************
; 示例 1 - 创建隐藏的浏览器窗口, 导航到
;				一个站点, 获取一些信息后退出
; *******************************************************

#include <IE.au3>

Local $oIE = _IECreate("http://sourceforge.net", 0, 0)
; 显示名称为 "sfmarquee" 的页面元素中的 innerText
Local $oMarquee = _IEGetObjByName($oIE, "sfmarquee")
MsgBox(0, "SourceForge Information", $oMarquee.innerText)
_IEQuit($oIE)
