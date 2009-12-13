; *******************************************************
; 例 1 - 创建基于AutoIt主页的浏览器, 获取页上第六个图像
;       (首个图像的索引为0), 并显示相关信息
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com/")
$oImg = _IEImgGetCollection ($oIE, 5)
$sInfo = "Src: " & $oImg.src & @CR
$sInfo &= "文件名: " & $oImg.nameProp & @CR
$sInfo &= "高度: " & $oImg.height & @CR
$sInfo &= "宽度: " & $oImg.width & @CR
$sInfo &= "边框: " & $oImg.border
MsgBox(0, "第六个图片的信息", $sInfo)

; *******************************************************
; 例 2 - 创建基于AutoIt主页的浏览器, 获取图像集
;       并显示每个屏幕地址
; *******************************************************
;
#include <IE.au3>
$oIE = _IECreate ("http://www.autoitscript.com/")
$oImgs = _IEImgGetCollection ($oIE)
$iNumImg = @extended
MsgBox(0, "图片信息总计", "一共有" & $iNumImg & "个图片在这个页面上")
For $oImg In $oImgs
	MsgBox(0, "图片信息", "src=" & $oImg.src)
Next