; *******************************************************
; 示例 1 - 创建空的 word 窗口并添加一个新的空文档
; *******************************************************
;
#include <Word.au3>

Local $oWordApp = _WordCreate("")
Local $oDoc = _WordDocAdd($oWordApp)
