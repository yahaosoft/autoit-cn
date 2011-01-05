ProgressOn("进度条", "每秒递增", "0 %")
For $i = 10 to 100 step 10
	sleep(1000)
	ProgressSet( $i, $i & " %")
Next
ProgressSet(100 , "完成", "全部完成")
sleep(500)
ProgressOff()
