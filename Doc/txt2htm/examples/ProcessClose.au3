ProcessClose("notepad.exe")

$PID = ProcessExists("notepad.exe")	; 检查指定进程是否存在,存在则返回 PID,不存在则返回 0.
If $PID Then ProcessClose($PID)
