#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.2.8.1
	Author:         David Nuttall

	Script Function:
	Base script to show functionality of Debug functions.

#ce ----------------------------------------------------------------------------

#include <Debug.au3>

_DebugSetup("Check Excel")
For $i = 1 To 4
	WinActivate("Microsoft Excel")
	; 与 Excel 交互
	Send("{Down}")
	_DebugOut("Moved Mouse Down")
Next
