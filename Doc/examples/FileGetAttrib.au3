$attrib = FileGetAttrib("c:\boot.ini")
If @error Then
	MsgBox(4096,"错误", "无法获得属性.")
	Exit
Else
	If StringInStr($attrib, "R") Then
	MsgBox(0,"文件属性", "只读文件.")
	EndIf
EndIf

; 以文本形式显示全部属性信息
; 数组依赖每个大写字母是唯一的
; 练习信息字串是如何工作的...
$input = StringSplit("R,A,S,H,N,D,O,C,T",",")
$output = StringSplit("只读文件 /, 存档文件 /, 系统文件 /, 隐藏文件 /" & _
		", 普通文件 /, 目录文件 /, 脱机文件 /, 压缩文件 /, 临时文件 /",  ",")
For $i = 1 to 9
	$attrib = StringReplace($attrib, $input[$i], $output[$i], 0, 1)
	; 在 StringReplace 的最后一个参数意谓着范例的敏感性
Next
$attrib = StringTrimRight($attrib, 2) ;移除结尾斜线
MsgBox(0,"完整的文件属性:", $attrib)
