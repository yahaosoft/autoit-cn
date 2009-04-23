;======================================================
;
; 函数名称:        _NetworkGetInternetIP
; 详细信息:        得到公网IP地址.
; 作者:            Sxd
;
;======================================================
Func _NetworkGetInternetIP()
	Local $ip
	If InetGet("http://www.aamailsoft.com/getip.php", @TempDir & "\ip.txt") Then
		$ip = FileRead(@TempDir & "\ip.txt")
		FileDelete(@TempDir & "\ip.txt")
		Return $ip
	Else
		Return "0.0.0.0"
	EndIf
EndFunc   ;==>_NetworkGetInternetIP