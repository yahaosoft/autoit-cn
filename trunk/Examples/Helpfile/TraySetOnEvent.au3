#include <Constants.au3>
#NoTrayIcon

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.

$exit = TrayCreateItem("ÍË³ö")
TrayItemSetOnEvent(-1,"ExitEvent")

TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE,"SpecialEvent")
TraySetOnEvent($TRAY_EVENT_SECONDARYUP,"SpecialEvent")

TraySetState()

While 1
	Sleep(10)	; Idle loop
WEnd

Exit


; Functions
Func SpecialEvent()
	Select
		Case @TRAY_ID = $TRAY_EVENT_PRIMARYDOUBLE
			Msgbox(64,"SpecialEvent-Info","×ó¼üË«»÷.")
		Case @TRAY_ID = $TRAY_EVENT_SECONDARYUP
			Msgbox(64,"SpecialEvent-Info","ÓÒ¼üË«»÷.")
	EndSelect
EndFunc


Func ExitEvent()
	Exit
EndFunc
