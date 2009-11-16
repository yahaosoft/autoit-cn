; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后重命名活动工作表名称
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

_ExcelSheetNameSet($oExcel, "Example") ;重命名活动工作表名称

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后显示工作表名称. 
;            重命名活动工作表名称, 显示重命名后活动工作表名称.
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

MsgBox(0, "工作表名称", "当前活动工作表名称是:" & @CRLF & _ExcelSheetNameGet($oExcel))

_ExcelSheetNameSet($oExcel, "Example") ;重命名活动工作表名称

MsgBox(0, "工作表名称", "重命名后, 活动工作表名称是:" & @CRLF & _ExcelSheetNameGet($oExcel))

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出
