#include  <Crypt.au3>

; 哈希数据并使用哈希值验证密码示例

; 这是正确密码的 MD5 哈希值
Local $bPasswordHash = "0xCE950A8D7D367B5CE038E636893B49DC"

Local $sPassword = InputBox("Login", "Please type the correct password.", "Yellow fruit that is popular among monkeys")

If _Crypt_HashData($sPassword, $CALG_MD5) = $bPasswordHash Then
	MsgBox(64, "Access Granted", "Password correct!")
Else
	MsgBox(16, "Access Denied", "You entered the wrong password!")
EndIf

