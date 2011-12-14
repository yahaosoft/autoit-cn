Local $iFreeSpace = DriveSpaceFree(@HomeDrive & "\") ; Find the free disk space of the home drive, generally this is the C:\ drive.
MsgBox(4096, "可用空间:", $iFreeSpace & " MB")
