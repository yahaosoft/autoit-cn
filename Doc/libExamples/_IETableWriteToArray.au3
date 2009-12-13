; *******************************************************
; 例 1 - 打开带有表示例的浏览器, 获取页(索引1)上第二张表的引用, 并将其内容读入二维数组
; *******************************************************
;
#include <IE.au3>
$oIE = _IE_Example ("table")
$oTable = _IETableGetCollection ($oIE, 1)
$aTableData = _IETableWriteToArray ($oTable)

; *******************************************************
; 例 2 - 同例 1, 变换输出数组的位置并以_ArrayDisplay()显示结果
; *******************************************************
;
#include <IE.au3>
#include <Array.au3>
$oIE = _IE_Example ("table")
$oTable = _IETableGetCollection ($oIE, 1)
$aTableData = _IETableWriteToArray ($oTable, True)
_ArrayDisplay($aTableData)