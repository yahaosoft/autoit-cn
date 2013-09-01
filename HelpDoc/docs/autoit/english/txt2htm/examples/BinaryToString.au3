#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Define the string that will be converted later.
	; NOTE: This string may show up as ?? in the help file and even in some editors.
	; This example is saved as UTF-8 with BOM.  It should display correctly in editors
	; which support changing code pages based on BOMs.
	Local Const $sString = "Hello - ??"

	; Temporary variables used to store conversion results.  $bBinary will hold
	; the original string in binary form and $sConverted will hold the result
	; afte it's been transformed back to the original format.
	Local $bBinary = Binary(""), $sConverted = ""

	; Convert the original UTF-8 string to an ANSI compatible binary string.
	$bBinary = StringToBinary($sString)

	; Convert the ANSI compatible binary string back into a string.
	$sConverted = BinaryToString($bBinary)

	; Display the resulsts.  Note that the last two characters will appear
	; as ?? since they cannot be represented in ANSI.
	DisplayResults($sString, $bBinary, $sConverted, "ANSI")

	; Convert the original UTF-8 string to an UTF16-LE binary string.
	$bBinary = StringToBinary($sString, 2)

	; Convert the UTF16-LE binary string back into a string.
	$sConverted = BinaryToString($bBinary, 2)

	; Display the resulsts.
	DisplayResults($sString, $bBinary, $sConverted, "UTF16-LE")

	; Convert the original UTF-8 string to an UTF16-BE binary string.
	$bBinary = StringToBinary($sString, 3)

	; Convert the UTF16-BE binary string back into a string.
	$sConverted = BinaryToString($bBinary, 3)

	; Display the resulsts.
	DisplayResults($sString, $bBinary, $sConverted, "UTF16-BE")

	; Convert the original UTF-8 string to an UTF-8 binary string.
	$bBinary = StringToBinary($sString, 4)

	; Convert the UTF8 binary string back into a string.
	$sConverted = BinaryToString($bBinary, 4)

	; Display the resulsts.
	DisplayResults($sString, $bBinary, $sConverted, "UTF8")
EndFunc   ;==>Example

; Helper function which formats the message for display.  It takes the following parameters:
; $sOriginal - The original string before conversions.
; $bBinary - The original string after it has been converted to binary.
; $sConverted- The string after it has been converted to binary and then back to a string.
; $sConversionType - A human friendly name for the encoding type used for the conversion.
Func DisplayResults($sOriginal, $bBinary, $sConverted, $sConversionType)
	MsgBox($MB_SYSTEMMODAL, "", "Original:" & @CRLF & $sOriginal & @CRLF & @CRLF & "Binary:" & @CRLF & $bBinary & @CRLF & @CRLF & $sConversionType & ":" & @CRLF & $sConverted)
EndFunc   ;==>DisplayResults
