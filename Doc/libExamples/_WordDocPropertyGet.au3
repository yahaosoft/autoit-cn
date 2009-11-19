; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口, 打开一个文档,
;				然后按索引读取索引中所有可读取的属性
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection ($oWordApp, 0)
For $i = 1 To 30
	ConsoleWrite("Property Index " & $i & " - " & _WordDocPropertyGet ($oDoc, $i) & @CR)
Next

; *******************************************************
; 示例 2 - 创建一个新的空白文档Word窗口, 打开一个文档,
;				然后读取标题，主题，作者名字的属性
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection ($oWordApp, 0)
ConsoleWrite("Title - " & _WordDocPropertyGet ($oDoc, "Title") & @CR)
ConsoleWrite("Subject - " & _WordDocPropertyGet ($oDoc, "Subject") & @CR)
ConsoleWrite("Author - " & _WordDocPropertyGet ($oDoc, "Author") & @CR)