﻿Local $x = BitNOT(5)

#cs 注释:
	结果为 -6,因为 32-位数字对应的:
	5 == 00000000000000000000000000000101 二进制
	-6 == 11111111111111111111111111111010 二进制
	并且第一位带符号.
#ce
