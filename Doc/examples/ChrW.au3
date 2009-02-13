$text = ""
For $i = 256 to 512
	$text = $text & ChrW($i)
Next
MsgBox(0, "Unicode ×Ö·û¼¯ 256 µ½ 512", $text)
