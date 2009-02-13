
; 映射 X 磁盘到 \\myserver\stuff using current user
DriveMapAdd("X:", "\\myserver\stuff")

; 获取映射信息
MsgBox(0, "驱动器 X: 映射到", DriveMapGet("X:"))

