; 此示例在 GPIB 总线上进行搜索并在 MsgBox 中显示结果

#include <Visa.au3>

Local $a_descriptor_list[1], $a_idn_list[1]
_viFindGpib($a_descriptor_list, $a_idn_list, 1)
