$p	= DllStructCreate("dword dwOSVersionInfoSize;dword dwMajorVersion;dword dwMinorVersion;dword dwBuildNumber;dword dwPlatformId;char szCSDVersion[128]")

;看作 p->dwOSVersionInfoSize = sizeof(OSVERSIONINFO)
DllStructSetData($p, "dwOSVersionInfoSize", DllStructGetSize($p))

;建立 Dll 调用
$ret = DllCall("kernel32.dll","int","GetVersionEx","ptr",DllStructGetPtr($p))

if Not $ret[0] Then
	MsgBox(0,"Dll调用错误","Dll调用失败")
	exit
EndIf

;获取返回值
$major		= DllStructGetData($p,"dwMajorVersion")
$minor		= DllStructGetData($p,"dwMinorVersion")
$build		= DllStructGetData($p,"dwBuildNumber")
$platform	= DllStructGetData($p,"dwPlatformId")
$version	= DllStructGetData($p,"szCSDVersion")

;释放 struct
$p =0

msgbox(0,"","重点: " & $major & @CRLF & _
			"次要: " & $minor & @CRLF & _
			"编译: " & $build & @CRLF & _
			"操作平台 ID: " & $platform & @CRLF & _
			"升级包版本: " & $version)

