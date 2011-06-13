; *******************************************************
; 示例 1 - 获取并显示 IE.au3 版本信息
; *******************************************************

#include <IE.au3>

Local $aVersion = _IE_VersionInfo()
MsgBox(0, "IE.au3 Version", $aVersion[5] & " released " & $aVersion[4])
