; *******************************************************
; 示例 1 - 创建一个文件名为“Test.doc”的Word文件并打开, 
;              将Word的窗口连接到该文件，然后显示该文件的完整路径.
; *******************************************************

#include <Word.au3>
$NEW = _WordCreate (@ScriptDir & "\Test.doc");创建一个新的Microsoft Word文件并打开

$oWordApp = _WordAttach ("Test.doc", "FileName")
If Not @error Then
	$oDoc = _WordDocGetCollection ($oWordApp, 0)
	MsgBox(64, "示例1 文件的完整路径", $oDoc.FullName)
EndIf

; *******************************************************
; 示例 2 - 将word的窗口连接到包含"The quick brown fox"文本的文档
; *******************************************************

#include <Word.au3>
$oWordApp = _WordAttach ("The quick brown fox", "Text")