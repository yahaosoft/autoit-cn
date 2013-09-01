#include <Array.au3>

Local $asControls = StringSplit(WinGetClassList("[active]", ""), @CRLF)
_ArrayDisplay($asControls, "Class List of Active Window")
