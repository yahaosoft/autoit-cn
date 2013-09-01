Set oAutoIt = WScript.CreateObject("AutoItX3.Control")

' Get initial checksum
checksum = oAutoIt.PixelChecksum(0,0, 50,50)