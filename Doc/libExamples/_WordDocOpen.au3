; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口,然后打开.
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate ("")
$oDoc = _WordDocOpen ($oWordApp, @ScriptDir & "\Test.doc")