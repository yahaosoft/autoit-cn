Set oAutoIt = WScript.CreateObject("AutoItX3.Control")
oAutoIt.ControlListView "C:\", "", "SysTreeView321", "SelectAll", "", ""
oAutoIt.ControlListView "C:\", "", "SysTreeView321", "Deselect", "2", "5"
