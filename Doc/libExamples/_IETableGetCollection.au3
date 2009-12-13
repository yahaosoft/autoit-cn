; *******************************************************
; 例 1 - 打开带表实例的浏览器, 获取页上首张表的引用(索引0)
;     并将内容读取到二维数组
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("table")
$oTable = _IETableGetCollection ($oIE, 0)
$aTableData = _IETableWriteToArray ($oTable)

; *******************************************************
; 例 2 - 打开带表实例的浏览器, 获取页上表集合的引用并显示页上的表数量
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("table")
$oTable = _IETableGetCollection ($oIE)
$iNumTables = @extended
MsgBox(0, "表单信息", "这个页面上有" & $iNumTables & "个表单")