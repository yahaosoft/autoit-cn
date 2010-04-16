; *******************************************************
; 例 1 - 打开'basic'模式(_IE_Example)的网页例子,在第一段标签内部和周围插入文字并且在控制台显示主体(body)HTML代码.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oP = _IETagNameGetCollection($oIE, "p", 0)

_IEDocInsertText($oP, "(Text beforebegin)", "beforebegin")
_IEDocInsertText($oP, "(Text afterbegin)", "afterbegin")
_IEDocInsertText($oP, "(Text beforeend)", "beforeend")
_IEDocInsertText($oP, "(Text afterend)", "afterend")

ConsoleWrite(_IEBodyReadHTML($oIE) & @CR)

; *******************************************************
; 例子 2 - 在文档的顶部和底部插入文字.
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("basic")
$oBody = _IETagNameGetCollection($oIE, "body", 0)
_IEDocInsertText($oBody, "这个文本是在顶部插入的", "afterbegin")
_IEDocInsertText($oBody, "注意那个<b>Tags</b> 是在显示之前 <encoded> 的", "beforeend")


; *******************************************************
; 例子 3 - 高级例子:在每一个页面顶部插入一个时钟和字符串,
; 甚至是当你浏览到一个新的页面的时候也会显示.使用函数_IEDocInsertText,
; _IEDocInsertHTML 和函数 _IEPropertySet的参数"innerhtml" and "referrer"
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate("http://www.autoitscript.com")

AdlibRegister("UpdateClock", 1000) ; 每分钟更新时钟

; idle as long as the browser window exists
While WinExists(_IEPropertyGet($oIE, "hwnd"))
    Sleep(10000)
WEnd

Exit

Func UpdateClock()
    Local $curTime = "<b>当前时间是: </b>" & @HOUR & ":" & @MIN & ":" & @SEC
    ; _IEGetObjByName is expected to return a NoMatch error after navigation 
	;   (before DIV is inserted), so temporarily turn off notification
    _IEErrorNotify(False)
    Local $oAutoItClock = _IEGetObjByName($oIE, "AutoItClock")
    If Not IsObj($oAutoItClock) Then ; Insert DIV element if it wasn't found
        ;
        ; 得到BODY对象,插入DIV,得到DIV对象,更新时间
        $oBody = _IETagNameGetCollection($oIE, "body", 0)
        _IEDocInsertHTML($oBody, "<div id='AutoItClock'></div>", "afterbegin")
        $oAutoItClock = _IEGetObjByName($oIE, "AutoItClock")
        _IEPropertySet($oAutoItClock, "innerhtml", $curTime)
        ;
        ;检查对象的文本,如不是空白的就插入到clock后面
        _IELoadWait($oIE)
        $sReferrer = _IEPropertyGet($oIE, "referrer")
        If $sReferrer Then _IEDocInsertText($oAutoItClock, _
			"  Referred by: " & $sReferrer, "afterend")
    Else
        _IEPropertySet($oAutoItClock, "innerhtml", $curTime) ; update time
    EndIf
    _IEErrorNotify(True)
EndFunc