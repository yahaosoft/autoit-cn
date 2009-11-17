; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口, 打开一个现有文档, 关闭文件并退出.
; *******************************************************
#include <Word.au3>
$oWordApp = _WordCreate ("")
$oDoc = _WordDocOpen ($oWordApp, @ScriptDir & "\Test.doc")
_WordDocClose ($oDoc)
_WordQuit ($oWordApp)