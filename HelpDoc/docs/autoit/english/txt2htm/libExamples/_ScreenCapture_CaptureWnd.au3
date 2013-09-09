#include <ScreenCapture.au3>

Example()

Func Example()
	Local $hGUI

	; Create GUI
	$hGUI = GUICreate("Screen Capture", 400, 300)
	GUISetState()

	; Capture window
	_ScreenCapture_CaptureWnd(@MyDocumentsDir & "\GDIPlus_Image.jpg", $hGUI)
EndFunc   ;==>Example
