Set oAutoIt = WScript.CreateObject("AutoItX3.Control")
oAutoIt.ControlListView "C:\Program Files\NSIS", "", "SysListView321", "SelectAll", "", ""
oAutoIt.ControlListView "C:\Program Files\NSIS", "", "SysListView321", "Deselect", "2", "5"
