; 二进制(Binary) ANSI 到 字符串(String) 
$buffer = StringToBinary("Hello - 你好")
MsgBox(0, "字符串的二进制数据(ANSI 编码):" , $buffer)
$buffer = BinaryToString($buffer)
MsgBox(0, "转换二进制变量为ANSI字串:" , $buffer)

; Binary UTF16-LE to String 
$buffer = StringToBinary("Hello - 你好", 2)
MsgBox(0, "字符串的二进制数据(UTF16 小编码):" , $buffer)
$buffer = BinaryToString($buffer, 2)
MsgBox(0, "转换二进制变量为UTF16-LE字串:" , $buffer)

; Binary UTF16-BE to String 
$buffer = StringToBinary("Hello - 你好", 3)
MsgBox(0, "字符串的二进制数据(UTF16 大编码):" , $buffer)
$buffer = BinaryToString($buffer, 3)
MsgBox(0, "转换二进制变量为UTF16-BE字串:" , $buffer)

; Binary UTF8 to String 
$buffer = StringToBinary("Hello - 你好", 4)
MsgBox(0, "字符串的二进制数据(UTF8 编码):" , $buffer)
$buffer = BinaryToString($buffer, 4)
MsgBox(0, "转换二进制变量为UTF8字串:" , $buffer)
