#include <GuiConstantsEx.au3>
#include <String.au3>

_Main()

Func _Main()
	Local $WinMain, $EditText, $InputPass, $InputLevel, $EncryptButton, $DecryptButton, $string
	; GUI 和源字符串
	$WinMain = GUICreate('Encryption tool', 400, 400)
	; 创建窗口
	$EditText = GUICtrlCreateEdit('', 5, 5, 380, 350)
	; 创建主编辑控件
	$InputPass = GUICtrlCreateInput('', 5, 360, 100, 20, 0x21)
	; 创建屏蔽/居中的密码输入框
	$InputLevel = GUICtrlCreateInput(1, 110, 360, 50, 20, 0x2001)
	GUICtrlSetLimit(GUICtrlCreateUpdown($InputLevel), 10, 1)
	; 这两句让等级输入可以用 Up|Down 上下调节的功能
	$EncryptButton = GUICtrlCreateButton('Encrypt', 170, 360, 105, 35)
	; 加密按钮
	$DecryptButton = GUICtrlCreateButton('Decrypt', 285, 360, 105, 35)
	; 解密按钮
	GUICtrlCreateLabel('Password', 5, 385)
	GUICtrlCreateLabel('Level', 110, 385)
	; 简单的文本标签, 这样您会明白它有什么用处
	GUISetState()
	; 显示窗口

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $EncryptButton
				GUISetState(@SW_DISABLE, $WinMain) ; 阻止您改变任何东西
				$string = GUICtrlRead($EditText) ; 保存编辑框内容供以后使用
				GUICtrlSetData($EditText, 'Please wait while the text is Encrypted/Decrypted.') ; 友好的消息
				GUICtrlSetData($EditText, _StringEncrypt(1, $string, GUICtrlRead($InputPass), GUICtrlRead($InputLevel)))
				; 调用加密. 设置编辑框内的数据为已加密字符串
				; 函数中 1/0 表示进行加密/解密
				; 保存编辑框中的字符串以后使用
				; 然后读取密码框和等级框
				GUISetState(@SW_ENABLE, $WinMain) ; 恢复窗口
			Case $DecryptButton
				GUISetState(@SW_DISABLE, $WinMain) ; 阻止您改变任何东西
				$string = GUICtrlRead($EditText) ; 保存编辑框内容供以后使用
				GUICtrlSetData($EditText, 'Please wait while the text is Encrypted/Decrypted.') ; 友好的消息
				GUICtrlSetData($EditText, _StringEncrypt(0, $string, GUICtrlRead($InputPass), GUICtrlRead($InputLevel)))
				; 调用加密. 设置编辑框内的数据为已加密字符串
				; 函数中 1/0 表示进行加密/解密
				; 保存编辑框中的字符串以后使用
				; 然后读取密码框和等级框
				GUISetState(@SW_ENABLE, $WinMain) ; 恢复窗口
		EndSwitch
	WEnd ; 一直循环直到窗口关闭
	Exit
EndFunc   ;==>_Main
