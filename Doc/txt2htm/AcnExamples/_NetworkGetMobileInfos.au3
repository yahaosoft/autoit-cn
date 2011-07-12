#include <ACN_NET.au3>

$aMobile = _NetworkGetMobileInfos("13942587746");随便按了个号码
MsgBox(0, "查询的手机号码为", $aMobile[1])
MsgBox(0, "手机号码归属地为", $aMobile[2])


$aMobile = _NetworkGetMobileInfos("1439425877466");随便按了个号码
If @error Then
	MsgBox(0,"错误","查询出错")
	Exit
EndIf