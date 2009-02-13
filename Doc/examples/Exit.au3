;示例 1
Exit

;示例 2 
; 结束脚本：命令行中没有自变量
If $CmdLine[0] = 0 Then Exit(1)

;示例 3 
; 打开第一命令行中自变量指定的文件
$file = FileOpen($CmdLine[1], 0)

; 检查文件属性是否为读
If $file = -1 Then Exit(2)

; 如果文件是空的 , 那么退出 (脚本运行是成功的)
$line = FileReadLine($file)
If @error = -1 Then Exit

;在这里编码处理文件
FileClose($file)
Exit ;如果是脚本的最后行，则是可选择的
