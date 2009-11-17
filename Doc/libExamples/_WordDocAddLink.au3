; *******************************************************
; 示例 1 - 创建一个新的空白文档Word窗口, 添加一个链接, 然后得到一个链接集合.
; *******************************************************
#include <Word.au3>
$oWordApp = _WordCreate ()
$oDoc = _WordDocGetCollection ($oWordApp, 0)
_WordDocAddLink ($oDoc, "", "www.AutoIt3.com", "", "AutoIt" & @CRLF, "Link to AutoIt")
$oLinks = _WordDocLinkGetCollection ($oDoc)
MsgBox(0, "链接集合", @extended)