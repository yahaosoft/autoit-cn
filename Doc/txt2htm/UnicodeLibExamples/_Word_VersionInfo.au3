; *******************************************************
; 示例 1 - 获取并显示 Word.au3 版本信息
; *******************************************************
;
#include <Word.au3>

Local $aVersion = _Word_VersionInfo()
MsgBox(0, "Word.au3 Version", $aVersion[5] & " released " & $aVersion[4])