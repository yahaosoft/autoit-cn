#include <Array.au3>

Local $aArray[10] = [1, 2, 3, 4, 5, 1, 2, 3, 4, 5] ; Create a 1-dimensional array that contains duplicate values.
_ArrayDisplay($aArray, "$aArray") ; Display the current array.

Local $aArrayUnique = _ArrayUnique($aArray) ; Use default parameters to create a unique array.
_ArrayDisplay($aArrayUnique) ; Display the unique array.
