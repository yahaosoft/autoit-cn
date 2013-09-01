Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

value = oAutoIt.PixelSearch(0,0, 100, 100, 0)
If oAutoIt.error = 1 Then
  WScript.Echo "Color not found"
Else
  WScript.Echo "Color found at: " & value(0) & "," & value(1)
End If

