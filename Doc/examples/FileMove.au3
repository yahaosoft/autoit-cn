FileMove("C:\foo.au3", "D:\mydir\bak.au3")

; 第二个例子:
;   使用标志 '1' 与 '8' (自动创造目标，显示文件列表结构)
;   从临时文件中移动所有的 txt 到 txtfiles 而且预先检查
;   目标目录结构是否存在, 如果不存在就自动创建
FileMove(@TempDir & "\*.txt", @TempDir & "\TxtFiles\", 9)
