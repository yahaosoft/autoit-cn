;=========================================================
;   建立数据结构 struct
;   struct {
;       域             var1;
;       无符号字符   var2;
;       无符号域    var3;
;       字符			var4[128];
;	}
;=========================================================
$str		= "int var1;ubyte var2;uint var3;char var4[128]"
$a			= DllStructCreate($str)
if @error Then
	MsgBox(0,"","写入 DllStructCreate 错误" & @error);
	exit
endif

;=========================================================
;	在 struct 中设定数据
;	struct.var1	= -1;
;	struct.var2	= 255;
;	struct.var3	= INT_MAX; -1 will be typecasted to (unsigned int)
;	strcpy(struct.var4,"Hello");
;	struct.var4[0]	= 'h';
;=========================================================
DllStructSetData($a,"var1",-1)
DllStructSetData($a,"var2",255)
DllStructSetData($a,"var3",-1)
DllStructSetData($a,"var4","Hello")
DllStructSetData($a,"var4",Asc("h"),1)

;=========================================================
;	显示写入 struct 的信息
;=========================================================
MsgBox(0,"Dll数据结构","数据结构大小: " & DllStructGetSize($a) & @CRLF & _
		"数据结构指针: " & DllStructGetPtr($a) & @CRLF & _
		"数据:" & @CRLF & _
		DllStructGetData($a,1) & @CRLF & _
		DllStructGetData($a,2) & @CRLF & _
		DllStructGetData($a,3) & @CRLF & _
		DllStructGetData($a,4))

;=========================================================
;	如果需要，释放为 struct 分派的内存
;=========================================================
$a=0
