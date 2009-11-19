; *******************************************************
; 示例 1 - 创建一个空的Word窗口，添加一个新的空白文档, 然后获得文档的集合
; *******************************************************

#include <Word.au3>
$oWordApp = _WordCreate ()
_WordDocAdd ($oWordApp)
$oDocuments = _WordDocGetCollection ($oWordApp)
MsgBox(0, "文档数", @extended)
_WordQuit ($oWordApp)