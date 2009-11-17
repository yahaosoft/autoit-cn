; *******************************************************
; Example 1 - Create a word window, open a document, find "this", 
;				replace all occurrences with "THIS", quit without saving changes.
; *******************************************************
#include <Word.au3>
$oWordApp = _WordCreate (@ScriptDir & "\Test.doc")
$oDoc = _WordDocGetCollection($oWordApp, 0)
$oFind = _WordDocFindReplace($oDoc, "this", "THIS")
If $oFind Then
	MsgBox(0, "查找替换", "发现并更换.")
Else
	MsgBox(0, "查找替换", "未找到.")
EndIf
_WordQuit ($oWordApp, 0)