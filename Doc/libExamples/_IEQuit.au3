; *******************************************************
; 例 1 - 创建隐藏的浏览器窗体, 导航到一个网址, 获取一些信息并退出
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://sourceforge.net", 0, 0)
; 显示这个页面中Name是"sfmarquee"元素的innerText
$oMarquee = _IEGetObjByName ($oIE, "sfmarquee")
MsgBox(0, "SourceForge的信息", $oMarquee.innerText)
_IEQuit ($oIE)