;修改当前目录中全部.au 3文件属性为只读和系统文件
If Not FileSetAttrib("*.au3", "+RS") Then
    MsgBox(4096,"错误", "属性设置问题.")
EndIf

;修改 C:\ 目录中全部.bmp文件属性为可写与存档
If Not FileSetAttrib("C:\*.bmp", "-R+A", 1) Then
    MsgBox(4096,"错误", "属性设置问题.")
EndIf