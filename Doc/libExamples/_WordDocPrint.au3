; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口, 打开一个文档, 设置文本, 
;              默认值打印, 不保存退出. 
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection ($oWordApp, 0)

Sleep(3500);延迟以便观察变化
$oDoc.Range.Text = "这是准备打印的文本."
Sleep(3500);延迟以便观察变化

_WordDocPrint ($oDoc)
_WordQuit ($oWordApp, 0)

; *******************************************************
; 示例 2 - 创建一个新的空白文档Word窗口, 打开一个文档, 设置文本, 
;				打印设置使用(纵向/横向)打印, 不保存退出.
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection ($oWordApp, 0)

Sleep(3500);延迟以便观察变化
$oDoc.Range.Text = "这是准备打印的文本."
Sleep(3500);延迟以便观察变化

_WordDocPrint ($oDoc, 0, 1, 1)
_WordQuit ($oWordApp, 0)

; *******************************************************
; 示例 3 - 创建一个新的空白文档Word窗口, 打开一个文档, 设置文本, 
;			   选择名为"My Printer"的打印机进行打印, 不保存退出.
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection ($oWordApp, 0)

Sleep(3500);延迟以便观察变化
$oDoc.Range.Text = "这是准备打印的文本."
Sleep(3500);延迟以便观察变化

_WordDocPrint ($oDoc, 0, 1, 0, 1, "My Printer")
_WordQuit ($oWordApp, 0)