FileCopy("C:\*.au3", "D:\mydir\*.*")

; 拷贝一个文件夹及其内容
DirCreate("C:\new")
FileCopy("C:\old\*.*", "C:\new\")

FileCopy("C:\Temp\*.txt", "C:\Temp\TxtFiles\", 8)
; 在右边的'TxtFiles'是当前目标目录而且文件名根据源名

FileCopy("C:\Temp\*.txt", "C:\Temp\TxtFiles\", 9) ; 标志 = 1 + 8 (修改 + 产生目标目录结构)
; 从源到目标以相同的名字修改复制 txt 文件
