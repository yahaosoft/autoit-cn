#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	_GDIPlus_Startup() ;initialize GDI+
	Local Const $iWidth = 300, $iHeight = 300, $iBgColor = 0x404040 ;$iBgColor format RRGGBB

	Local $hGUI = GUICreate("GDI+ example", $iWidth, $iHeight) ;create a test GUI
	GUISetBkColor($iBgColor, $hGUI) ;set GUI background color
	GUISetState()

	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
	Local $hInst = _WinAPI_LoadLibrary(@SystemDir & "\taskmgr.exe") ;maps a specified executable module into the address space of the calling process
	Local $hBitmap = _GDIPlus_BitmapCreateFromResource($hInst, 103) ;load bitmap resource 103 and convert it to GDI+ bitmap format
	Local $iW = _GDIPlus_ImageGetWidth($hBitmap), $iH = _GDIPlus_ImageGetHeight($hBitmap)
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, ($iWidth - $iW) / 2, ($iHeight - $iH) / 2) ;display image in GUI centered

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	;cleanup GDI+ resources
	_WinAPI_FreeLibrary($hInst)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
EndFunc   ;==>Example
