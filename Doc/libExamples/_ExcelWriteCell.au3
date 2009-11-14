; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后写入一个单元格. 保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew();创建一个新的工作表并打开

_ExcelWriteCell($oExcel, "I Wrote to This Cell", 1, 1) ;对指定的Excel工作表单元格写入信息.

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1)  ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后使用一个循环写入单元格. 保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 1 To 20 ;循环
	_ExcelWriteCell($oExcel, "I Wrote to This Cell", $i, 1) ;对指定的Excel工作表单元格写入信息.
Next

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1)  ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出


; ***************************************************************
; 示例 3 打开一个新的工作表并返回其对象标识符, 然后使用一个循环写入单元格.
;           使用 _ExcelWriteCell 写入公式, 然后保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 1 To 20 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;对指定的Excel工作表单元格写入信息.
Next

_ExcelWriteCell($oExcel, "=Average(A:A)", 1, 2) ;使用 A1 引用方式写入公式, 并非 R1C1
_ExcelWriteCell($oExcel, "=Average(A1:A20)", 1, 3) ;使用另外一种 A1 引用方式写入公式, 并非 R1C1

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1)  ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出
