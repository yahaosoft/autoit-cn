; *******************************************************
;示例1 - 创建一个新的空白文档Word窗口, 然后添加一些图片文件.
; *******************************************************

#include <Word.au3>
$sPath = @SystemDir & "\"
$search = FileFindFirstFile($sPath & "*.bmp")

;检查搜索是否成功
If $search = -1 Then
	MsgBox(0, "错误", "没有发现图片文件")
	Exit
EndIf

$oWordApp = _WordCreate ()
$oDoc = _WordDocGetCollection ($oWordApp, 0)

While 1
	$file = FileFindNextFile($search)
	If @error Then ExitLoop
	$oShape = _WordDocAddPicture ($oDoc, $sPath & $file, 0, 1)
	If Not @error Then $oShape.Range.InsertAfter (@CRLF)
WEnd

; 关闭搜索句柄
FileClose($search)