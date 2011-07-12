#include-once
; #INDEX# =======================================================================================================================
; Title .........: ACN_NET
; AutoIt Version: 3.2.13++
; Language:       English
; Description:    Functions that assist with network.
; ===============================================================================================================================



; #VARIABLES# ===================================================================================================================
; ==============================================================================================================================
; #CURRENT# =====================================================================================================================
; _Thunder
; _Flashget
; _CMD_SetLocalIP
; _API_Get_NetworkAdapterMAC
; _NetworkGetInternetIP
; _InetIsOffline()
; _NetworkAdapterInfo
; _WMI_SetNetworkAdapterInfo


;==============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;==============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _Thunder
; Description ...: 调用迅雷下载
; Syntax.........: _Thunder($url[, $Filename[, $Path[, $comment[, $ReferUrl[, $startmode[, $Orgin[, $OrginThread]]]]]]])
; Parameters ....: 	$url          - 下载地址
; 					$Filename:	  - 保存的文件名
; 					$Path:		  - 保存的路径
; 					$comment:	  - 下载任务注释
; 					$ReferUrl:	  - 引用的URL
; 					$startmode:	  - 开始模式,True(立即)/False(手动)
; 					$Orgin:		  - 只从原始地址下载(True/False)
; 					$OrginThread: - 从原始地址下载线程数
; Return values .: 成功  - 返回1
;                  失败  - 返回0
; Author ........: thesnoW(rundll32@126.com)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Thunder($Url, $Filename = "", $Path = "", $comment = "", $ReferUrl = "", $startmode = True, $Orgin = False, $OrginThread = 10)
	Local $obj = ObjCreate("ThunderAgent.Agent")
	If IsObj($obj) = 0 Then Return 0
	$obj.AddTask($Url, $Filename, $Path, $comment, $ReferUrl, $startmode, $Orgin, $OrginThread);添加下载任务
	$obj.CommitTasks() ;提交任务.
	Return 1
EndFunc   ;==>_Thunder

; #FUNCTION# ====================================================================================================================
; Name...........: _Flashget
; Description ...: 调用网际快车下载
; Syntax.........: _Flashget($url[, $Path[, $flashgetpath]])
; Parameters ....: 	$url          - 下载地址
; 					$Path:		  - 保存的路径
; 					$flashgetpath:- 网际快车的路径
; Return values .: 成功  - 返回1
;                  失败  - 返回0,网际快车未安装
; Author ........: thesnoW(rundll32@126.com)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Flashget($url, $Path = "", $flashgetpath = "")
	If $flashgetpath = "" Then
		$flashgetpath = RegRead("HKEY_CURRENT_USER\Software\FlashGetX\General", "AppPath")
		If $flashgetpath = "" Then
			$flashgetpath = RegRead("HKEY_CURRENT_USER\Software\FlashGet\General", "AppPath")
		EndIf
		If $flashgetpath = "" Then Return 0
	EndIf
	ShellExecute($flashgetpath, $Url & " " & $Path)
	Return 1
EndFunc   ;==>_Flashget

; #FUNCTION# ====================================================================================================================
; Name...........: _CMD_SetLocalIP
; Description ...: 设置IP地址.
; Syntax.........: _CMD_SetLocalIP("连接名称","IP地址",["子网掩码"[, "默认网关"[, "DNS"]]])
; Parameters ....: 	$ConName          - 连接名称
; 					$IpADD:          IP地址
; 					$SubMask:        子网掩码
; 					$GateWay:        默认网关
; 					$ConDNS:         DNS(域名解析)
; Return values .: none
; Author ........: thesnoW(rundll32@126.com)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _CMD_SetLocalIP($ConName, $IpADD, $SubMask, $GateWay, $ConDNS)
	If $SubMask = "" Then $SubMask = "255.255.255.0"
	If $ConName = "" And $IpADD <> "" Then
		RunWait(@ComSpec & ' /C netsh -c interface ip set address "本地连接" static ' & $IpADD & " " & $SubMask & " " & $GateWay, "", @SW_HIDE)
	EndIf
	If $ConName <> "" And $IpADD <> "" Then
		RunWait(@ComSpec & ' /C netsh -c interface ip set address ' & '"' & $ConName & '"' & ' static ' & $IpADD & " " & $SubMask & " " & $GateWay, "", @SW_HIDE)
	EndIf
	If $ConDNS <> "" Then
		RunWait(@ComSpec & ' /C netsh -c interface ip set dns ' & '"' & $ConName & '"' & ' static ' & $ConDNS & ' primary', "", @SW_HIDE)
	EndIf
EndFunc   ;==>_CMD_SetLocalIP

; #FUNCTION# ====================================================================================================================
; Name...........: _NetworkGetInternetIP
; Description ...: 得到公网IP地址.
; Syntax.........: _NetworkGetInternetIP()
; Parameters ....: 
; Return values .: 	成功 - 返回公网IP
;					失败 - 返回 0.0.0.0 ,可能是无法连接外网或者取得IP的地址已挂.
; Author ........: Sxd
; Modified.......:
; Remarks .......: 此函数是采用http://www.aamailsoft.com/getip.php的数据,不保证长期有效.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _NetworkGetInternetIP()
	Local $ip
	If InetGet("http://www.aamailsoft.com/getip.php", @TempDir & "\ip.txt") Then
		$ip = FileRead(@TempDir & "\ip.txt")
		FileDelete(@TempDir & "\ip.txt")
		Return $ip
	Else
		FileDelete(@TempDir & "\ip.txt")
		Return "0.0.0.0"
	EndIf
EndFunc   ;==>_NetworkGetInternetIP

; #FUNCTION# ====================================================================================================================
; Name...........: _API_Get_NetworkAdapterMAC
; Description ...: 根据API得到MAC.
; Syntax.........: _API_Get_NetworkAdapterMAC($sIP)
; Parameters ....: 	$sIP          - IP地址
; Return values .: 	成功 - 返回MAC地址
;					失败 - 返回 00:00:00:00:00:00
; Author ........: jiexunpc
; Modified.......:
; Remarks .......: 此函数是采用发送ARP方式,如果有错误的路由绑定或交换机绑定.可能得到错误的MAC.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _API_Get_NetworkAdapterMAC($sIP)
	Local $MAC, $MACSize
	Local $i, $s, $r, $iIP

	$MAC = DllStructCreate("byte[6]")
	$MACSize = DllStructCreate("int")

	DllStructSetData($MACSize, 1, 6)
	$r = DllCall("Ws2_32.dll", "int", "inet_addr", "str", $sIP)
	$iIP = $r[0]
	$r = DllCall("iphlpapi.dll", "int", "SendARP", "int", $iIP, "int", 0, "ptr", DllStructGetPtr($MAC), "ptr", DllStructGetPtr($MACSize))
	$s = ""
	For $i = 0 To 5
		If $i Then $s = $s & ":"
		$s = $s & Hex(DllStructGetData($MAC, 1, $i + 1), 2)
	Next
	Return $s
EndFunc   ;==>_API_Get_NetworkAdapterMAC



; #FUNCTION# ====================================================================================================================
; Name...........: _InetIsOffline
; Description ...: 检测机器是否离线
; Syntax.........: _InetIsOffline()
; Parameters ....: 
; Return values .: 	成功 - 返回 1
;					失败 - 返回 0
; Author ........: thesnoW(rundll32@126.com)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/bb776460(VS.85).aspx
; Example .......; Yes
; ===============================================================================================================================
Func _InetIsOffline()
		Return DllCall("url.dll","bool","InetIsOffline","DWORD",0)
EndFunc

;======================================================
;
; 函数名称:        _NetworkAdapterInfo()
; 详细信息:        获得网卡信息
; 返回值说明:
; 以二维数组方式返回.例如 $info=_NetworkAdapterInfo()
; $info[0][0]=网卡数量
; $info[1][0]第一块网卡的标志1
; $info[2][0]第二块网卡的标志2
; $info[1][1]第一块网卡的网卡名称
; $info[2][1]第二块网卡的网卡名称
; $info[1][2]第一块网卡的默认网关
; $info[1][3]第一块网卡的DNS主机名称(本机名称)
; $info[1][4]第一块网卡的IP地址
; $info[1][5]第一块网卡的主DNS
; $info[1][6]第一块网卡的次DNS
; $info[1][7]第一块网卡的子网掩码
; $info[1][8]第一块网卡的MAC地址
; $info[1][9]第一块网卡的连接名称
; 注意，此UDF不会获取已经禁用的网卡。
; 如果有需要，请删除' WHERE IPEnabled != 0'和' WHERE NetConnectionStatus >0'
; 作者:            thesnow(rundll32@126.com)
;
;======================================================
Func _NetworkAdapterInfo()
	Local $colItems = ""
	Local $objWMIService
	Local $NetworkAdapterID = 0
	Local $NetworkAdapterName = ""
	Local $NetworkAdapterGateway = ""
	Local $NetworkAdapterHostName = ""
	Local $NetworkAdapterIPaddress = ""
	Local $NetworkAdapterDNS1 = ""
	Local $NetworkAdapterDNS2 = ""
	Local $NetworkAdapterSubnet = ""
	Local $NetworkAdapterMAC = ""
	Local $NetworkAdapterNetConnectionID = ""
	Local $NetworkAdapterInfo[10][10] ;最高10块网卡.
	$NetworkAdapterInfo[0][0] = 0
	$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled != 0", "WQL", 0x10 + 0x20)
	$colItem2 = $objWMIService.ExecQuery('SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionStatus >0', "WQL", 0x10 + 0x20)
	If IsObj($colItems) Then
		For $objItem In $colItems
			$NetworkAdapterName = $objItem.Description
			$NetworkAdapterGateway = $objItem.DefaultIPGateway(0)
			$NetworkAdapterHostName = $objItem.DNSHostName
			$NetworkAdapterIPaddress = $objItem.IPAddress(0)
			$NetworkAdapterDNS1 = $objItem.DNSServerSearchOrder(0)
			$NetworkAdapterDNS2 = $objItem.DNSServerSearchOrder(1)
			$NetworkAdapterSubnet = $objItem.IPSubnet(0)
			$NetworkAdapterMAC = $objItem.MACAddress
			$NetworkAdapterID += 1
			$NetworkAdapterInfo[0][0] = $NetworkAdapterID
			$NetworkAdapterInfo[$NetworkAdapterID][0] = $NetworkAdapterID
			$NetworkAdapterInfo[$NetworkAdapterID][1] = $NetworkAdapterName
			$NetworkAdapterInfo[$NetworkAdapterID][2] = $NetworkAdapterGateway
			$NetworkAdapterInfo[$NetworkAdapterID][3] = $NetworkAdapterHostName
			$NetworkAdapterInfo[$NetworkAdapterID][4] = $NetworkAdapterIPaddress
			$NetworkAdapterInfo[$NetworkAdapterID][5] = $NetworkAdapterDNS1
			$NetworkAdapterInfo[$NetworkAdapterID][6] = $NetworkAdapterDNS2
			$NetworkAdapterInfo[$NetworkAdapterID][7] = $NetworkAdapterSubnet
			$NetworkAdapterInfo[$NetworkAdapterID][8] = $NetworkAdapterMAC
		Next
	Else
		Return $NetworkAdapterInfo
	EndIf

	If IsObj($colItem2) Then
		$NetworkAdapterID = 0
		For $objItem2s In $colItem2
			$NetworkAdapterNetConnectionID = $objItem2s.NetConnectionID
			$NetworkAdapterID += 1
			$NetworkAdapterInfo[$NetworkAdapterID][9] = $NetworkAdapterNetConnectionID
		Next
		Return $NetworkAdapterInfo
	Else
		Return $NetworkAdapterInfo
	EndIf
EndFunc   ;==>_NetworkAdapterInfo

;======================================================
;
; 函数名称:		_WMI_SetNetworkAdapterInfo($HostName, $IpAdd, $SubMask, $GateWay, $DNS1, $DNS2, $IPX)
; 详细信息:		设置IP地址.
; $HostName:	计算机名称
; $IpAdd:		IP地址
; $SubMask:		子网掩码
; $GateWay:		默认网关
; $DNS1:		主DNS(域名解析)
; $DNS2:		次DNS(域名解析)
; $IPX:			IPX虚拟网络号
; 作者:			thesnow(rundll32@126.com)
;
;======================================================

Func _WMI_SetNetworkAdapterInfo($HostName, $IpADD, $SubMask, $GateWay, $DNS1, $DNS2, $IPX)
	Dim $SetDns[2], $SetIPAddress[1], $SetSubnetmask[1], $SetGateway[1]
	$SetDns[0] = $DNS1
	$SetDns[1] = $DNS2
	$SetIPAddress[0] = $IpADD
	$SetSubnetmask[0] = $SubMask
	$SetGateway[0] = $GateWay
	$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = TRUE", "WQL", 0x10 + 0x20)
	$colComputers = $objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
	$objNetworkSettings = $objWMIService.Get("Win32_NetworkAdapterConfiguration")
	For $objNetAdapter In $colComputers
		$objNetAdapter.Rename($HostName)
	Next
	If IsObj($colItems) Then
		For $objNetAdapter In $colItems
			$objNetAdapter.EnableStatic($SetIPAddress, $SetSubnetmask)
			$objNetAdapter.SetGateways($SetGateway)
			$objNetAdapter.SetDNSServerSearchOrder($SetDns)
		Next
	EndIf
	$objNetworkSettings.SetIPXVirtualNetworkNumber($IPX)
EndFunc   ;==>_WMI_SetNetworkAdapterInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _NetworkGetInternetIPInfos
; Description ...: 得到公网IP地址.
; Syntax.........: _NetworkGetInternetIPInfos([$sIP])
; Parameters ....: $sIP:	默认为获取本机外网ip与归属地,如输入ip则获取该ip归属地
; Return values .: 	成功 - 返回一个数组
;							[1]	IP
;							[2]	归属地
;					失败 - 返回 "",并设置@error为1 ,可能是无法连接外网或者取得信息的地址已挂.
; Author ........: Sxd
; Modified.......:
; Remarks .......: 此函数是采用http://www.youdao.com的数据,不保证长期有效.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _NetworkGetInternetIPInfos($sIP = "ip")
	Local $html
	$html = InetRead("http://www.youdao.com/smartresult-xml/search.s?type=ip&q=" & $sIP, 1)
	$html = BinaryToString($html)
	$aInfo = __GetInfosFromYoudaoXML($html, "ip")
	If @error Then
		Return SetError(1,0,"")
	Else
		Return $aInfo
	EndIf
EndFunc   ;==>_NetworkGetInternetIPInfos

; #FUNCTION# ====================================================================================================================
; Name...........: _NetworkGetMobileInfos
; Description ...: 手机号归属地查询.
; Syntax.........: _NetworkGetMobileInfos($iMobile)
; Parameters ....: $iMobile:	需要查询归属地的手机号码
; Return values .: 	成功 - 返回一个数组
;							[1]	手机号码
;							[2]	归属地
;					失败 - 返回 "",并设置@error为1 ,可能是无法连接外网或者取得信息的地址已挂.
; Author ........: Sxd
; Modified.......:
; Remarks .......: 此函数是采用http://www.youdao.com的数据,不保证长期有效.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _NetworkGetMobileInfos($iMobile)
	Local $html
	$html = InetRead("http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=" & $iMobile, 1)
	$html = BinaryToString($html)
	$aInfo = __GetInfosFromYoudaoXML($html, "mobile")
	If @error Then
		Return SetError(1,0,"")
	Else
		Return $aInfo
	EndIf
	
EndFunc   ;==>_NetworkGetMobileInfos

; #FUNCTION# ====================================================================================================================
; Name...........: _NetworkGetIDCardInfos
; Description ...: 身份证信息查询.
; Syntax.........: _NetworkGetIDCardInfos($sID)
; Parameters ....: $sID:	需要查询信息的身份证号码
; Return values .: 	成功 - 返回一个数组
;							[1]	身份证号码
;							[2]	归属地
;							[3]	生日
;							[4]	性别
;					失败 - 返回 "",并设置@error为1 ,可能是无法连接外网或者取得信息的地址已挂.
; Author ........: Sxd
; Modified.......:
; Remarks .......: 此函数是采用http://www.youdao.com的数据,不保证长期有效.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _NetworkGetIDCardInfos($sID)
	Local $html
	$html = InetRead("http://www.youdao.com/smartresult-xml/search.s?type=id&q=" & $sID, 1)
	$html = BinaryToString($html)
	$aInfo = __GetInfosFromYoudaoXML($html, "id")
	If @error Then
		Return SetError(1,0,"")
	Else
		Return $aInfo
	EndIf
	
EndFunc   ;==>_NetworkGetIDCardInfos

Func __GetInfosFromYoudaoXML($sXML, $sType = "ip")
	Local $rIP = "(?<=<ip>).*(?=</ip>)"
	Local $rLocation = "(?<=<location>).*(?=</location>)"
	Local $rPhonenum = "(?<=<phonenum>).*(?=</phonenum>)"
	Local $rCode = "(?<=<code>).*(?=</code>)"
	Local $rBirthday = "(?<=<birthday>).*(?=</birthday>)"
	Local $rGender = "(?<=<gender>).*(?=</gender>)"
	Local $reg
	If $sType = "ip" Then
		$reg = $rIP & "|" & $rLocation
	ElseIf $sType = "mobile" Then
		$reg = $rPhonenum & "|" & $rLocation
	ElseIf $sType = "id" Then
		$reg = $rCode & "|" & $rLocation & "|" & $rBirthday & "|" & $rGender
	EndIf
	Local $ret
	$ret = StringRegExp($sXML, $reg, 3)
	If @error Then
		Return SetError(1,0,"")
	Else
		If $ret[1] = "$location" Then $ret[1] = "未知"
		_ArrayInsert($ret, 0, UBound($ret))
		Return $ret
	EndIf
EndFunc   ;==>__GetInfosFromYoudaoXML

Func _ArrayInsert(ByRef $avArray, $iElement, $vValue = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)

	; Add 1 to the array
	Local $iUBound = UBound($avArray) + 1
	ReDim $avArray[$iUBound]

	; Move all entries over til the specified element
	For $i = $iUBound - 1 To $iElement + 1 Step -1
		$avArray[$i] = $avArray[$i - 1]
	Next

	; Add the value in the specified element
	$avArray[$iElement] = $vValue
	Return $iUBound
EndFunc   ;==>_ArrayInsert
