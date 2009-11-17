; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后使用循环写入单元格. 
;           将单元格读入数组, 显示数组内容，然后保存并关闭文件.
; *****************************************************************

#include <Excel.au3>
#include <Array.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 1 To 5 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;在工作表单元格中垂直方向写入 1 至 5 信息
Next

For $i = 1 To 5 ;循环
	_ExcelWriteCell($oExcel, Asc($i), 1, $i + 2) ;在工作表单元格中水平方向写入信息, 出于读取目的, 需使用不同值时可使用ASC
Next

$aArray1 = _ExcelReadArray($oExcel, 1, 1, 5, 1) ;垂直方向
$aArray2 = _ExcelReadArray($oExcel, 1, 3, 5) ;水平方向
_ArrayDisplay($aArray2, "水平方向")
_ArrayDisplay($aArray1, "垂直方向")

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出