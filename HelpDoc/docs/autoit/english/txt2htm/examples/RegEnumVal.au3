#include <MsgBoxConstants.au3>

Local $sVar = ""

For $i = 1 To 100
	$sVar = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", $i)
	If @error <> 0 Then ExitLoop
	MsgBox($MB_SYSTEMMODAL, "Value Name  #" & $i & " under in AutoIt3 key", $sVar)
Next
