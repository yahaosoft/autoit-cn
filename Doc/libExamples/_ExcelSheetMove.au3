; *****************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后通过表的索引移动表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开
_ExcelSheetMove($oExcel, 2) ;移动第二页表到第一页表位置(基于整数/索引)

MsgBox(0, "退出", "提示 第二页表 Sheet2 已经在第一页表 Sheet1 位置" & @CRLF & @CRLF & "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; *****************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后通过表的字符串名称移动表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开
_ExcelSheetMove($oExcel, "Sheet2") ;移动第二页表到第一页表位置(基于字符串/名称)
MsgBox(0, "退出", "提示 第二页表 Sheet2 已经在第一页表 Sheet1 位置" & @CRLF & @CRLF & "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 3 打开一个新的工作表并返回其对象标识符, 然后通过表的索引值移动表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开
;添加一些表，并做一些整理
$sSheetName4 = "Sheet4"
$sSheetName5 = "Sheet5"
_ExcelSheetAddNew($oExcel, $sSheetName4)  ;添加表 
_ExcelSheetMove($oExcel, $sSheetName4, 4, False) ;移动 $sSheetName4 到第四页表的位置(如果失败, 将其放置在相关表后面)

_ExcelSheetAddNew($oExcel, $sSheetName5) ;添加表 
_ExcelSheetMove($oExcel, $sSheetName5, 5, False) ;移动 $sSheetName5 到第五页表的位置(如果失败, 将其放置在相关表后面)

MsgBox(0, "提示", "注意工作表的顺序" & @CRLF & @CRLF & "按确定继续")

_ExcelSheetMove($oExcel, $sSheetName5, "Sheet3", True) ;移动第五页表到表名为'Sheet3'的位置
MsgBox(0, "退出", "'" & $sSheetName5 & "'" & " 当 $fBefore 参数为: True (相对与 'Sheet3')" & @CRLF & @CRLF & "按确定继续")
_ExcelSheetMove($oExcel, $sSheetName5, "Sheet3", False) ;移动第五页表到表名为'Sheet3'的位置
MsgBox(0, "退出", "'" & $sSheetName5 & "'" & " 当 $fBefore 参数为: False (相对与 'Sheet3')" & @CRLF & @CRLF & "按确定保存文件并退出")

_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出