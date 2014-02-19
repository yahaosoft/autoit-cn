#include <MsgBoxConstants.au3>

Local $dBoolean = True
If IsBool($dBoolean) Then
	MsgBox($MB_SYSTEMMODAL, "", "The variable is boolean")
Else
	MsgBox($MB_SYSTEMMODAL, "", "The variable is not boolean")
EndIf
