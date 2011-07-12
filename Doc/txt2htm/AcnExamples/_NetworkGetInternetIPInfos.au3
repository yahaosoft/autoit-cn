#include <ACN_NET.au3>

$aSelfIP = _NetworkGetInternetIPInfos()
MsgBox(0, "本机ip为", $aSelfIP[1])
MsgBox(0, "ip归属地为", $aSelfIP[2])




$aIP = _NetworkGetInternetIPInfos("220.181.8.178")
MsgBox(0, "查询的ip为", $aIP[1])
MsgBox(0, "ip归属地为", $aIP[2])

$aIP = _NetworkGetInternetIPInfos("220.181.8.1789")
If @error Then
	MsgBox(0,"错误","查询出错")
	Exit
EndIf
