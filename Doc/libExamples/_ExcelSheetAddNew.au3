; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后添加一个新表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

_ExcelSheetAddNew($oExcel, "New Sheet Example")

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出