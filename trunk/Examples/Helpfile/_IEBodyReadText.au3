
 ; ******************************************************* 
 ; 示例 - 打开带有基本示例的浏览器, 读取文本 
 ;    (移除所有HTML标记的文本)并在消息框中显示 
 ; ******************************************************* 
 ; 
 #include  <IE.au3> 
 $oIE = _IE_Example ( " basic " ) 
 $sText = _IEBodyReadText ( $oIE ) 
 MsgBox ( 0 , " Body Text ", $sText ) 
 
