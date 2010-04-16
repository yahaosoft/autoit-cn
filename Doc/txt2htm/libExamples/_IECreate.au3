; *******************************************************
; 例 1 - 创建一个浏览器窗口并浏览一个网址
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("www.autoitscript.com")

; *******************************************************
; 例 2 - 新建指向三个不同URL的浏览器窗口, 如果一个不存在($f_tryAttach = 1)
;       不等待网页加载完成($f_wait = 0)
; *******************************************************
;
#include <IE.au3>
_IECreate ("www.autoitscript.com", 1, 1, 0)
_IECreate ("my.yahoo.com", 1, 1, 0)
_IECreate ("www.google.com", 1, 1, 0)

; *******************************************************
; 例 3 - 尝试使已存在的浏览器显示指定网址URL. 如果不存在, 新建浏览器并浏览该地址
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("www.autoitscript.com", 1)
; Check @extended return value to see if attach was successful
If @extended Then
	MsgBox(0, "", "已经附加到已经纯在的浏览器窗口上")
Else
	MsgBox(0, "", "创建了新的浏览器窗口")
EndIf

; *******************************************************
; 例 4 - 创建一个空浏览器窗口并使用自定义HTML将其弹出
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ()
$sHTML = "<h1>Hello World!</h1>"
_IEBodyWriteHTML ($oIE, $sHTML)

; *******************************************************
; 例 5 - 创建不可见浏览器窗口, 浏览网址, 获取信息并退出
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://sourceforge.net", 0, 0)
; 显示页面元素上名为"sfmarquee"的内部文本
$oMarquee = _IEGetObjByName ($oIE, "sfmarquee")
MsgBox(0, "SourceForge页面的信息", $oMarquee.innerText)
_IEQuit ($oIE)

; *******************************************************
; 例 6 - 创建带有新的iexplore.exe实例的浏览器窗口
;       这对于获取新对话的上下文cookie通常是必需的,
;       (会话cookies被所有相同iexplore.exe的浏览器实例共享)
; *******************************************************
;
#include <IE.au3>
ShellExecute ("iexplore.exe", "about:blank")
WinWait ("[CLASS:IEFrame]")
$oIE = _IEAttach ("about:blank", "url")
_IELoadWait ($oIE)
_IENavigate ($oIE, "www.autoitscript.com")