
 #AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 
 #include <WinHTTP.au3> 
 
 Opt ( " MustDeclareVars ", 1 ) 

 ; 初始化并获取会话句柄 
 Global $hOpen = _WinHttpOpen () 
 If @error Then 
    MsgBox ( 48 , " Error ", " Error initializing the usage of WinHTTP functions. " ) 
    Exit 1 
 EndIf 

 ; 关闭句柄 
 _WinHttpCloseHandle ( $hOpen ) 
 If  @error  Then 
    MsgBox ( 48 , " Error ", " Error closing the handle. " & @CRLF & " Error number is " & @error ) 
 Else 
    MsgBox ( 64 , " Closed ", " Handle is succesfully closed. " ) 
 EndIf 

