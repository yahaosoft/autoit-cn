﻿AdlibRegister("MyAdlib")
;...
AdlibDisable()
;...
AdlibRegister("MyAdlib")	; will reenable
;...
Exit

Func MyAdlib()
	;... execution must be non blocking, avoid ...Wait(), MsgBox(), InputBox() functions
	If WinActive("Error") Then
		;...
	EndIf
EndFunc
