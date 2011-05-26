Local $var = DriveGetDrive("all")
If Not @error Then
	MsgBox(4096, "", "Found " & $var[0] & " drives")
	For $i = 1 To $var[0]
		MsgBox(4096, "Drive " & $i, $var[$i])
	Next
EndIf
