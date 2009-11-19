; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口, 向文档写入"this" 内容, 
;              然后查找查找"this", 用 "THIS" 替换所有找到的, 不保存退出. 
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection($oWordApp, 0)

$oDoc.Range.insertAfter ("this");向文档写入 "this" 内容
Sleep(3500);延迟以便观察变化

$oFind = _WordDocFindReplace($oDoc, "this", "THIS");查找并替换
If $oFind Then
	MsgBox(0, "查找替换", "发现并更换.")
Else
	MsgBox(0, "查找替换", "未找到.")
EndIf
_WordQuit ($oWordApp, 0)