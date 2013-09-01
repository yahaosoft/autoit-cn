Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

' Double click at the current mouse pos
oAutoIt.MouseClick "left"
oAutoIt.MouseClick "left"

' Double click at 0,500
oAutoIt.MouseClick "left", 0, 500, 2