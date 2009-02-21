$bak = ClipGet()
MsgBox(0, "剪贴板包含:", $bak)

ClipPut($bak & "附加文本")
MsgBox(0, "剪贴板包含:", ClipGet())
