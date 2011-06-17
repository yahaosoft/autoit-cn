; *******************************************************
; 示例 1 - 创建 word 窗口, 打开文档, 设置文本,
;				按默认方式打印, 且不保存修改退出.
; *******************************************************
;
#include <Word.au3>

Local $oWordApp = _WordCreate(@ScriptDir & "\Test.doc")
Local $oDoc = _WordDocGetCollection($oWordApp, 0)
$oDoc.Range.Text = "This is some text to print."
_WordDocPrint($oDoc)
_WordQuit($oWordApp, 0)

; *******************************************************
; 示例 2 - 创建 word 窗口, 打开文档, 设置文本,
;				横向打印, 且不保存修改退出.
; *******************************************************
;
#include <Word.au3>
$oWordApp = _WordCreate(@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection($oWordApp, 0)
$oDoc.Range.Text = "This is some text to print."
_WordDocPrint($oDoc, 0, 1, 1)
_WordQuit($oWordApp, 0)

; *******************************************************
; 示例 3 - 创建 word 窗口, 打开文档, 设置文本,
;				使用名为 "My Printer" 的打印机打印, 且不保存修改退出.
; *******************************************************
;
#include <Word.au3>
$oWordApp = _WordCreate(@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection($oWordApp, 0)
$oDoc.Range.Text = "This is some text to print."
_WordDocPrint($oDoc, 0, 1, 0, 1, "My Printer")
_WordQuit($oWordApp, 0)
