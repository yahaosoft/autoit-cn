Local $result = StringCompare("MEL??N", "melón")
MsgBox(0, "StringCompare Result (mode 0):", $result)

$result = StringCompare("MEL??N", "melón", 1)
MsgBox(0, "StringCompare Result (mode 1):", $result)

$result = StringCompare("MEL??N", "melón", 2)
MsgBox(0, "StringCompare Result (mode 2):", $result)
