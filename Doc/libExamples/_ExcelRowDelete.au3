; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后使用循环写入单元格.
;            删除 1 行后, 保存并关闭文件.
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 1 To 5 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;在工作表单元格中垂直方向写入 1 至 5 信息
Next

ToolTip("准备删除数据...")
Sleep(3500)

_ExcelRowDelete($oExcel, 1, 1) ;删除行 1 数据, 仅删除 1 行

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后使用循环写入单元格.
;            删除一些行后, 保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开e

For $i = 1 To 5 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;在工作表单元格中垂直方向写入 1 至 5 信息
Next

ToolTip("准备删除数据...")
Sleep(3500)

_ExcelRowDelete($oExcel, 3, 2) ;从行 3 开始, 删除 2 行

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出