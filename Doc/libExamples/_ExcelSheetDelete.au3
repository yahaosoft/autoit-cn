; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后通过表的名称字符串删除表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

_ExcelSheetDelete($oExcel, "Sheet1") ;通过表的名称字符串删除表

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后通过表的索引值删除表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

_ExcelSheetDelete($oExcel, 1) ;通过表的索引值删除表

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出