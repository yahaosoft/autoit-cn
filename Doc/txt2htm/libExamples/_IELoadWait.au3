; *******************************************************
; 例 1 - 打开AutoIt论坛页, 切换到"View new posts"链接并使用回车键激活.
;     然后再离开前等待页面完成加载.
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com/forum/index.php")
Send("{TAB 12}")
Send("{ENTER}")
_IELoadWait ($oIE)