#include <ACN_NET.au3>

$aID = _NetworkGetIDCardInfos("110107198106012037");机器生成的
MsgBox(0, "查询的身份证号码号码为", $aID[1])
MsgBox(0, "身份证号码归属地为", $aID[2])
MsgBox(0, "身份证生日为", $aID[3])
If $aID[4] = "m" Then
	MsgBox(0, "身份证性别为", "男")
Else
	MsgBox(0, "身份证性别为", "女")
EndIf

$aID = _NetworkGetIDCardInfos("1310107198106012037");机器生成的
If @error Then
	MsgBox(0,"错误","查询出错")
	Exit
EndIf