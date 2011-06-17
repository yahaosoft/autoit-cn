; *******************************************************
; 示例 1 - 创建空的 word 窗口, 打开现有文档,
;				关闭文档并退出.
; *******************************************************
;
#include <Word.au3>

Local $oWordApp = _WordCreate("")
Local $oDoc = _WordDocOpen($oWordApp, @ScriptDir & "\Test.doc")
_WordDocClose($oDoc)
_WordQuit($oWordApp)
