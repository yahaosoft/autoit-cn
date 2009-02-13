; 设置热键 ctrl+alt+t
FileCreateShortcut(@WindowsDir & "\Explorer.exe",@DesktopDir & "\Shortcut Test.lnk",@WindowsDir,"/e,c:\", "This is an Explorer link;-)", @SystemDir & "\shell32.dll", "^!t", "15", @SW_MINIMIZE)

; 读入快捷键的路径
$details = FileGetShortcut(@DesktopDir & "\Shortcut Test.lnk")
MsgBox(0, "路径:", $details[0])
