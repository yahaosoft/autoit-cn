#include-once

;======================================================
;
; 函数名称:		SendX("string",flag)
; 详细信息:		发送汉字.
; $string:		$string 为您想输入的汉字.
; $flag:		0或者非1为剪切板模式,1为发送ASC模式
; 返回值 :		没有
; 作者:			thesnow(rundll32@126.com)
;
;======================================================
Func SendX($string, $flag)
	Local $char
	Local $code
	Local $clup
	If $flag <> 1 Then $flag = 0
	Switch $flag
		Case 0
			$clup = ClipGet()
			ClipPut($string)
			Send("+{ins}")
			ClipPut($clup)
		Case 1
			If @Unicode Then
				$clup = ClipGet()
				ClipPut($string)
				Send("+{ins}")
				ClipPut($clup)
			Else
				For $i = 1 To StringLen($string)
					$char = StringMid($string, $i, 1)
					$code = Asc($char)
					If $code > 127 Then
						$code = $code * 256
						$i = $i + 1
						$char = StringMid($string, $i, 1)
						$code = $code + Asc($char)
					EndIf
					Send("{ASC " & $code & "}")
				Next
			EndIf
	EndSwitch
EndFunc   ;==>SendX


;======================================================
;
; 函数名称:		_UnicodeHex("string",$space)
; 详细信息:		转换字符串为UNICODE编码的HEX值
; $string:		$string 为您想输入的汉字.
; $space:		$space 为数字,0,1,2,
;				[0,无空格]
;				[1,每两个字节后一个空格]
;				[2,每一个字节后一个空格]
; 返回值 :		返回HEX值.
; 作者:			thesnow(rundll32@126.com)
;
;======================================================
Func _UnicodeHex($string,$space)
	Local $char
	Local $code
	Local $all=""
	Switch $space
		Case 0
		For $i = 1 to StringLen($string)
			$char = StringMid($string, $i, 1)
			if AscW($char) =0  Then 
			$char = StringMid($string, $i, 2)	
				$i=$i+1				
			EndIf				
			$code = Hex(AscW($char),4)
			$code =StringRight($code,2) & StringLeft($code,2) 
				$all=$all & $code
		Next
		Case 1
		For $i = 1 to StringLen($string)
			$char = StringMid($string, $i, 1)
			if AscW($char) = 0 Then 
			$char = StringMid($string, $i, 2)	
				$i=$i+1				
			EndIf	
			$code = Hex(AscW($char),4)
			$code =StringRight($code,2) & StringLeft($code,2) 
			$all=$all & " " & $code
		Next
		Case 2
		For $i = 1 to StringLen($string)
			$char = StringMid($string, $i, 1)
			if AscW($char) = 0 Then 
			$char = StringMid($string, $i, 2)	
				$i=$i+1				
			EndIf
			$code = Hex(AscW($char),4)
			$code =StringRight($code,2) & " " &StringLeft($code,2) 
			$all=$all & " " & $code
		Next
		case Else
		$all=-1
	EndSwitch
	Return $all
EndFunc