#include <Date.au3>

Global $Sec, $Min, $Hour, $Time
; 计算时间
Local $StartTicks = _TimeToTicks(@HOUR, @MIN, @SEC)
; 计算 45 分钟之后
Local $EndTicks = $StartTicks + 45 * 60 * 1000
_TicksToTime($EndTicks, $Hour, $Min, $Sec)
MsgBox(262144, '', 'New Time:' & $Hour & ":" & $Min & ":" & $Sec)

