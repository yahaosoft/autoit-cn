; 包括在 " C:\ test.bmp" 中发现的位图，通过编译程序在运行时把它放入 " D:\ mydir\test.bmp"
$b = True
If $b = True Then FileInstall("C:\test.bmp", "D:\mydir\test.bmp")
