#include <ACN_Date.au3>
$sDayName = _DateDayOfWeek()
MsgBox(4096, "一周中的一天", "今天是: " & $sDayName)