#Include <Constants.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.

$exititem		= TrayCreateItem("ÍË³ö")

TraySetState()

$start = 0
While 1
	$msg = TrayGetMsg()
	If $msg = $exititem Then ExitLoop
	$diff = TimerDiff($start)
	If $diff > 1000 Then
		$num = -Random(0,100,1)	; negative to use ordinal numbering
		ToolTip("#icon=" & $num)
		TraySetIcon("Shell32.dll",$num)
		$start = TimerInit()
	EndIF
WEnd

Exit
