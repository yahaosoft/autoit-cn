; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后读取单元格内容, 保存并关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

_ExcelWriteCell($oExcel, "I Wrote to This Cell", 1, 1) ;写入单元格
$sCellValue = _ExcelReadCell($oExcel, 1, 1)
MsgBox(0, "", "单元格的值是: " & @CRLF & $sCellValue, 2)

MsgBox(0, "退出", "按[确定]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后使用循环写入单元格.
;            循环读取单元格信息, 保存后关闭文件.
; *****************************************************************

#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

For $i = 1 To 5 ;循环
	_ExcelWriteCell($oExcel, $i, $i, 1) ;写入单元格
Next

For $i = 1 To 5 ;循环
	$sCellValue = _ExcelReadCell($oExcel, $i, 1)
	MsgBox(0, "", "单元格的值是: " & @CRLF & $sCellValue, 2)
Next

MsgBox(0, "退出", "按[确定]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出