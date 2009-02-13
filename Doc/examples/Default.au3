WinMove("[active]","",default, default, 200,300)	; 仅仅调整工作窗囗大小 (没有动作)

MyFunc2(Default,Default)

Func MyFunc2($Param1 = Default, $Param2 = '两个', $Param3 = Default)
    If $Param1 = Default Then $Param1 = '任何人'
    If $Param3 = Default Then $Param3 = '三'

    MsgBox(0, '参数', '1 = ' & $Param1 & @LF & _
        '2 = ' & $Param2 & @LF & _
        '3 = ' & $Param3)
EndFunc
