; *******************************************************
; 例 1 - 创建浏览器窗口并导航到一个网址,
;     等待5秒导航到另一个
;     等待5秒导航到另一个
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("www.autoitscript.com")
Sleep(5000)
_IENavigate ($oIE, "http://www.autoitscript.com/forum/index.php?")
Sleep(5000)
_IENavigate ($oIE, "http://www.autoitscript.com/forum/index.php?showforum=9")

; *******************************************************
; 例 2 - 创建浏览器窗口并导航到一个网址, 在移动到下一行前不等待页面完成加载
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("www.autoitscript.com", 0)
MsgBox(0, "_IENavigate()", "这个MsgBox立刻就执行了")