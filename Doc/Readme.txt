txt2htm.au3 converts specially formatted text files to htm files which comprise the compiled help file.

The following is an example with explanations:

###Function### or ###Keyword### or ###User Defined Function###
Name goes here.  The above title could also be ###Keyword###

###Description###
One-line description.

###Syntax###
One-line syntax spec.


###Parameters###
@@ParamTable@@
Description
	ParamTables are special, two-column tables
	where the first column is only one line,
	but the second column can be many lines.
How To Denote
	Any information that appears in the second
	column must be indented with one tab.
	Each entry that is NOT indented begins a new row.
	DO NOT LEAVE ANY BLANK LINE BETWEEN HERE AND "@@END@@"
@@End@@


###ReturnValue###
@@ReturnTable@@
Success:	tab followed by info for second column as Returns 1.
Failure:	Returns 0.
@@End@@
 

###Remarks###
In general, whitespace outside of tables is ignored.
The exception is the Remarks Section:  Lines can be indented, and non-consecutive blank lines are converted
as HTML <br>'s.

You can also use <b>bold</b> and <i>italic</i> tags.  Pretty much any HTML formatting can be used, since this text is more or less copied directly over to the htm file.

Remarks go here.  Here's a standard table; each line is a new row, and columns are tab-separated:

@@StandardTable@@
row1col1	row1col2	row1col3	row1col4
row2col1	row2col2	row2col3	row2col4
@@End@@


###Related###
Foo, Bar (Option), <a href="whatever/baz.htm">Baz</a>

; the above will be converted to the following HTML:
<a href="foo.htm">Foo</a>, <a href="AutoItSetOption.htm#Bar">Bar (Option)</a>, <a href="whatever/baz.htm">Baz</a>


###See Also###
@@MsdnLink@@ stringToBeSearched

;a Link that will search on the masdn Online library will be inserted

###Example###
The example will be formatted appropriately
Indent the lines with tabs; they will be converted to spaces (4, I think) in the html output.

;or

@@IncludeExample@@

;The example under Examples or libExamples will be included.