; *******************************************************
; 例 1 - 打开带有基本示例页的浏览器, 将一个事件脚本插入到文档头部, 当点击文
;     档时创建JavaScript警告
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "document", "onclick", "alert('Someone clicked the document!');")

; *******************************************************
; 例 2 - 打开带有基本示例页的浏览器, 将一个事件脚本插入到文档头部, 当试图右击
;     文档时创建JavaScript警告并返回"false"以阻止右键菜单出现
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "document", "oncontextmenu", "alert('No Context Menu');return false")

; *******************************************************
; 例 3 - 打开带有基本示例页的浏览器, 将一个事件脚本插入到文档头部, 当试图从页
;     面离开时创建JavaScript警告并提供取消操作的选项
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
_IEHeadInsertEventScript ($oIE, "window", "onbeforeunload", _
	"alert('Example warning follows...');return 'Pending changes may be lost';")
_IENavigate($oIE, "www.autoitscript.com")

; *******************************************************
; 例 4 - 打开带有基本示例页的浏览器, 将一个事件脚本插入到文档头部, 以保护文档中
;     选取的文本
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example()
_IEHeadInsertEventScript ($oIE, "document", "ondrag", "return false;")
_IEHeadInsertEventScript ($oIE, "document", "onselectstart", "return false;")

; *******************************************************
; 例 5 - 以AutoIt主页打开浏览器, 当点击任意链接并将点击的链接地址记录到控制台时,
;     将一个事件脚本插入到防止浏览的文档头部
; *******************************************************
;
#include <IE.au3>

$oIE = _IECreate("http://www.autoitscript.com")
$oLinks = _IELinkGetCollection($oIE)
For $oLink in $oLinks
    $sLinkId = _IEPropertyGet($oLink, "uniqueid")
    _IEHeadInsertEventScript($oIE, $sLinkId, "onclick", "return false;")
    ObjEvent($oLink, "_Evt_")
Next

While 1
	Sleep(100)
WEnd

Func _Evt_onClick()
    Local $o_link = @COM_EventObj
	ConsoleWrite($o_link.href & @CR)
EndFunc
