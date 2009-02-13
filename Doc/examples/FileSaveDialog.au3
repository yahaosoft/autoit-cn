$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"

$var = FileSaveDialog( "选择文件.", $MyDocsFolder, "脚本 (*.aut;*.au3)", 2)
; 选项 2 = 包含有 路径/文件选择 的对话框

If @error Then
	MsgBox(4096,"","没有选择.")
Else
	MsgBox(4096,"","你选择了：" & $var)
EndIf


; 多选择项
$var = FileSaveDialog( "选择文件.", $MyDocsFolder, "脚本 (*.aut;*.au3)|文本文件 (*.ini;*.txt)", 2)
; 选项 2 = 包含 路径/文件选择 的对话框

If @error Then
	MsgBox(4096,"","没有选择.")
Else
	MsgBox(4096,"","你选择了：" & $var)
EndIf