Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

oAutoIt.Sleep 2000  'allow time to move mouse before reporting ID
cursor = oAutoIt.MouseGetCursor()
WScript.Echo "ID = " & cursor
