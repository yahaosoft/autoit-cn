; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后声明一个数组, 
;            将数组写入到指定Excel对象工作表单元格中.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew()  ;创建一个新的工作表并打开

;Declare the Array
Local $aArray[5] = ["LocoDarwin", "Jon", "big_daddy", "DaleHolm", "GaryFrost"]

_ExcelWriteArray($oExcel, 1, 1, $aArray) ; 横向写入数组
_ExcelWriteArray($oExcel, 5, 1, $aArray, 1) ; 从第5行开始, 纵向写入数组

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1)  ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

