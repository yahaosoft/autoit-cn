; *******************************************************
; 例 1 - 打开带有基本示例的浏览器窗口, 点击带有文本"user forum"的链接
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IELinkClickByText ($oIE, "user forum")

; *******************************************************
; 例 2 - 打开浏览器到AutoIt主页, 循环页面上的链接并使用字串匹配点击带有
;     文本"wallpaper"的链接.
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate("http://www.autoitscript.com")

$sMyString = "wallpaper"
$oLinks = _IELinkGetCollection($oIE)
For $oLink in $oLinks
	$sLinkText = _IEPropertyGet($oLink, "innerText")
    If StringInStr($sLinkText, $sMyString) Then
		_IEAction($oLink, "click")
		ExitLoop
	EndIf
Next