Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

' Find all instances of the notepad window
val = oAutoIt.WinList("[CLASS:Notepad]")
For i = 1 to val(0,0)
  WScript.Echo "Title:" & val(0,i) & " - Handle:" & val(1,i)
Next

' Find all windows (may be hundreds!)
val = oAutoIt.WinList("[ALL]")
For i = 1 to val(0,0)
  WScript.Echo "Title:" & val(0,i) & " - Handle:" & val(1,i)
Next
