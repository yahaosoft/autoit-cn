; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 通过数组返回工作簿中所有表名称的列表
; *****************************************************************
#include <Excel.au3>
#include <Array.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

$aArray = _ExcelSheetList($oExcel)
_ArrayDisplay($aArray, "所有工作表名")

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 创建工作簿中所有表名的数组并按表名激活每个表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

$aArray = _ExcelSheetList($oExcel)

For $i = $aArray[0] To 1 Step -1 ;递减循环操作
	_ExcelSheetActivate($oExcel, $aArray[$i]) ;使用数组返回的字符串名称
	MsgBox(0, "活动工作表", "当前活动工作表是:" & @CRLF & $aArray[$i])
Next

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 3 打开一个新的工作表并返回其对象标识符, 创建工作簿中所有表名的数组并按索引激活每个表
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

$aArray = _ExcelSheetList($oExcel)

For $i = $aArray[0] To 1 Step -1  ;递减循环操作
	_ExcelSheetActivate($oExcel, $i) ;使用数组索引
	MsgBox(0, "活动工作表", "当前活动工作表是:" & @CRLF & $aArray[$i])
Next

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出

; ***************************************************************
; 示例 4 打开一个新的工作表并返回其对象标识符, 创建工作簿中所有表名的数组并按索引激活各表.
;            在工作簿每个写入数组的表上放置一些随机数字
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

$aArray = _ExcelSheetList($oExcel)

For $i = $aArray[0] To 1 Step -1 ;递减循环操作
	_ExcelSheetActivate($oExcel, $i) ;使用数组索引
	_ExcelWriteArray($oExcel, 1, 1, $aArray, 1) ;将数组写入活动工作簿
;使用简单的循环和随机数字填充单元格
	For $y = 2 To 10
		For $x = 2 To 10
			_ExcelWriteCell($oExcel, Round(Random(1000, 10000), 0), $x, $y) ;写入随机数字
		Next
	Next
	MsgBox(0, "活动工作表", "当前活动工作表是:" & @CRLF & $aArray[$i])
Next

MsgBox(0, "退出", "按确定保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出