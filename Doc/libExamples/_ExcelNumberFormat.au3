; ***************************************************************
; 示例 1 打开一个新的工作表并返回其对象标识符, 然后使用一个循环写入单元格. 格式化字符串后保存并关闭文件.
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开

;使用一个简单的循环和随机数字填充单元格
For $y = 1 To 10
	For $x = 1 To 10
		_ExcelWriteCell($oExcel, Random(1000, 10000), $x, $y)  ;向文件写入随机数字信息
	Next
Next

Sleep(3500) ; 暂停让用户观察操作

$sFormat = "$#,##0.00" ;应用到指定范围的格式化字符串(使其带有$现金符号)
_ExcelNumberFormat($oExcel, $sFormat, 1, 1, 5, 5) ;第1行第一列开始，第5行第五列结束

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel)  ; 关闭工作表, 退出

; ***************************************************************
; 示例 2 打开一个新的工作表并返回其对象标识符, 然后使用一个循环写入单元格. 
;            格式化字符串后保存并关闭文件.
; *****************************************************************
#include <Excel.au3>

Local $oExcel = _ExcelBookNew() ;创建一个新的工作表并打开
Local $aFormatExamples[5] = ["Format Examples", "yyyy-mm-dd", "hh:mm:ss", "$#,##0.00", "$#,##0.00$"] ;创建用于表头的数组

For $i = 0 To UBound($aFormatExamples) - 1 ;使用循环来写表头
	_ExcelWriteCell($oExcel, $aFormatExamples[$i], 1, $i + 1) ; +1到$i以便0基索引与行匹配
Next

;使用一个简单的循环和随机数字填充单元格
For $y = 2 To 5 ;在第二列开始
	For $x = 2 To 11
		_ExcelWriteCell($oExcel, Random(1000, 10000), $x, $y) ;向文件写入随机数字信息
	Next
Next

ToolTip("准备应用指定的格式...")
Sleep(3500) ; 暂停让用户观察操作

; 使用一个简单的循环格式化
; 每列应用不同类型新的格式
For $i = 1 To UBound($aFormatExamples) -1
    _ExcelNumberFormat($oExcel, $aFormatExamples[$i], 2, $i+1, 11, $i+1)
Next

$oExcel.Columns.AutoFit ;自动匹配列以便更好观察
$oExcel.Rows.AutoFit ;自动匹配行以便更好观察

MsgBox(0, "退出", "按[确认]保存文件并退出")
_ExcelBookSaveAs($oExcel, @TempDir & "\Temp.xls", "xls", 0, 1) ; 在临时目录保存文件, 如果文件已存在则覆盖原文件
_ExcelBookClose($oExcel) ; 关闭工作表, 退出
