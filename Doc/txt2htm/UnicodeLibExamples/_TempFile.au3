#include <File.au3>

Local $s_TempFile, $s_FileName

; 生成 @TempDir 中唯一的文件名
$s_TempFile = _TempFile()

; 生成在特定目录中且以 tst_ 开始的唯一文件名
$s_FileName = _TempFile("C:\", "tst_", ".txt", 7)

MsgBox(4096, "Info", "Names suitable for new temporary file : " & @LF & $s_TempFile & @LF & $s_FileName)

Exit
