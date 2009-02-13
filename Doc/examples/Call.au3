; 调用没用参数的自定义函数函数"Test1".
Call("Test1")

; 调用用参数的自定义函数函数"Test2".
Call("Test2", "消息来自函数调用 Call()!")

; 示范该如何使用特别数组函数中的参数.
Global $aArgs[4]
$aArgs[0] = "CallArgArray" ; 这是必需的,否则 Call() 将不认识数组包含的参数
$aArgs[1] = "这里是字串"	; 字串参数
$aArgs[2] = 47	; 参数[2]是一个数字
Global $array[2]
$array[0] = "数组元素 0"
$array[1] = "数组元素 1"
$aArgs[3] = $array	;参数[3]是一个数组

; 我们已经建造特别的数组, 现在调用自定义函数"Test3"
Call("Test3", $aArgs)

; 测试调用一个不存在的函数.  这里显示适当的测试方法
; 检查 @error 与 @extended 两者都包含的失败值.
Local Const $sFunction = "DoesNotExist"
Call($sFunction)
If @error = 0xDEAD And @extended = 0xBEEF Then MsgBox(4096, "", "函数不存在.")

Func Test1()
	MsgBox(4096, "", "哈罗")
EndFunc

Func Test2($sMsg)
	MsgBox(4096, "", $sMsg)
EndFunc

Func Test3($sString, $nNumber, $aArray)
	MsgBox(4096, "", "字串是: " & @CRLF & $sString)
	MsgBox(4096, "", "数字是: "& @CRLF & $nNumber)
	For $i = 0 To UBound($aArray) - 1
		MsgBox(4096, "", "数组[" & $i & "] 包含:" & @CRLF & $aArray[$i])
	Next
EndFunc
