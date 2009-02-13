; ÉèÖÃ ctrl+alt+t ¿ìËÙ¼ü
FileCreateShortcut(@WindowsDir & "\Explorer.exe",@DesktopDir & "\Shortcut Test.lnk",@WindowsDir,"/e,c:\", "This is an Explorer link;-)", @SystemDir & "\shell32.dll", "^!t", "15", @SW_MINIMIZE)
