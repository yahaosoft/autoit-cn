#include <ScreenCapture.au3>

; 捕获整个屏幕
_ScreenCapture_SetBMPFormat(0)
_ScreenCapture_Capture(@MyDocumentsDir & "\GDIPlus_Image.bmp")
