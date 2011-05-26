Local $p = DllStructCreate("dword dwOSVersionInfoSize;dword dwMajorVersion;dword dwMinorVersion;dword dwBuildNumber;dword dwPlatformId;char szCSDVersion[128]")

;think of this as p->dwOSVersionInfoSize = sizeof(OSVERSIONINFO)
DllStructSetData($p, "dwOSVersionInfoSize", DllStructGetSize($p))

;make the DllCall
Local $ret = DllCall("kernel32.dll", "int", "GetVersionEx", "ptr", DllStructGetPtr($p))

If Not $ret[0] Then
	MsgBox(0, "DllCall Error", "DllCall Failed")
	Exit
EndIf

;get the returned values
Local $major = DllStructGetData($p, "dwMajorVersion")
Local $minor = DllStructGetData($p, "dwMinorVersion")
Local $build = DllStructGetData($p, "dwBuildNumber")
Local $platform = DllStructGetData($p, "dwPlatformId")
Local $version = DllStructGetData($p, "szCSDVersion")

;free the struct
$p = 0

MsgBox(0, "", "Major: " & $major & @CRLF & _
		"Minor: " & $minor & @CRLF & _
		"Build: " & $build & @CRLF & _
		"Platform ID: " & $platform & @CRLF & _
		"Version: " & $version)

