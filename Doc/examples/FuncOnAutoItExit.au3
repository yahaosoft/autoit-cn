Opt("OnExitFunc", "endscript")
MsgBox(0,"","第一语句")

Func endscript()
	MsgBox(0,"","在最后语句之后 " & @EXITMETHOD)
EndFunc
