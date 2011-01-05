; 等待该坐标区域 0,0 至50,50 的颜色发生变化

; 取得初步校验和
$checksum = PixelChecksum(0,0, 50,50)

;循环检查区域校验和;每100毫秒检查一次,以减少CPU负载
While $checksum = PixelChecksum(0,0, 50, 50)
  Sleep(100)
WEnd

MsgBox(0, "", "该坐标区域的东东被改变了!")
