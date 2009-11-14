; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符. 声明一个二维数组, 将二维数组写入活动工作表后保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

;声明数组
Local $aArray[5][2] = [["LocoDarwin", 1],["Jon", 2],["big_daddy", 3],["DaleHolm", 4],["GaryFrost", 5]] ;声明一个二维数组
_ExcelWriteSheetFromArray($oExcel, $aArray, 1, 1, 0, 0) ;将二维数组写入活动工作表

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出