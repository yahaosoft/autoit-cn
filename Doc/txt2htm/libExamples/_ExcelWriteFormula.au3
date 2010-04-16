; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后使用一个循环写入单元格. 
;            将公式写入指定Excel对象工作表单元格中, 然后保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 0 To 20 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;写入单元格
Next

_ExcelWriteFormula($oExcel, "=Average(R1C1:R20C1)", 1, 2) ;使用 R1C1 引用

MsgBox(0, "退出", "按[确定]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1)  ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出
