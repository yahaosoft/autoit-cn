; *******************************************************
; 例 1 - 在文档的顶部和底部插入HTML代码
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate("http://www.autoitscript.com")
$oBody = _IETagNameGetCollection($oIE, "body", 0)
_IEDocInsertHTML($oBody, "<h2>这个HTML在顶部插入</h2>", "afterbegin")
_IEDocInsertHTML($oBody, "<h2>这个HTML在底部插入</h2>", "beforeend")

; *******************************************************
; 例 2 - 打开'basic'模式(_IE_Example)的网页例子,在名称为"IEAu3Data"的DIV内部和周围插入代码然后显示主体(Body)的HTML代码.
; *******************************************************
;
$oIE = _IE_Example ("basic")
$oDiv = _IEGetObjByName($oIE, "IEAu3Data")

_IEDocInsertHTML($oDiv, "<b>(HTML beforebegin)</b>", "beforebegin")
_IEDocInsertHTML($oDiv, "<i>(HTML afterbegin)</i>", "afterbegin")
_IEDocInsertHTML($oDiv, "<b>(HTML beforeend)</b>", "beforeend")
_IEDocInsertHTML($oDiv, "<i>(HTML afterend)</i>", "afterend")

ConsoleWrite(_IEBodyReadHTML($oIE) & @CR)

; *******************************************************
; 例 3 - 高级例子:在每一个页面顶部插入一个时钟和字符串,甚至是当你浏览到一个新的页面的时候也会显示.使用函数_IEDocInsertText,_IEDocInsertHTML 和函数 _IEPropertySet的参数"innerhtml" and "referrer"
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate("http://www.autoitscript.com")

AdlibRegister("UpdateClock", 1000) ; Update clock once per second

; idle as long as the browser window exists
While WinExists(_IEPropertyGet($oIE, "hwnd"))
    Sleep(10000)
WEnd

Exit

Func UpdateClock()
    Local $curTime = "<b>当前的时间是: </b>" & @HOUR & ":" & @MIN & ":" & @SEC
	; _IEGetObjByName预计会在浏览后返回无匹配错误
	;   (插入DIV之前), 故而临时关闭通知
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