; *******************************************************
; 示例 1 - 打开含表示例的浏览器, 获取
;				页面上第二个表的引用 (索引 1) 并读取其内容到一个二维数组
; *******************************************************

#include <IE.au3>

Local $oIE = _IE_Example("table")
Local $oTable = _IETableGetCollection($oIE, 1)
Local $aTableData = _IETableWriteToArray($oTable)

; *******************************************************
; 示例 2 - 如同示例 1, 但变换了输出数组并显示
;				_ArrayDisplay() 的结果
; *******************************************************

#include <IE.au3>
#include <Array.au3>

$oIE = _IE_Example("table")
$oTable = _IETableGetCollection($oIE, 1)
$aTableData = _IETableWriteToArray($oTable, True)
_ArrayDisplay($aTableData)
