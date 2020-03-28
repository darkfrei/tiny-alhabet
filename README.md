# tiny-alhabet
Can we crate tiny alphabet, that use as less pixels as possible?

Rules:
  1. Every symbol is unique
  2. Every symbol has same size
  3. The height and width are equals
  3. No gaps
  4. No fillings

So, we have square symbols, for example 4x4 pixels.
We are need at least one black pixel in first and last rows, at least one pixel in first and last columns.
If no gaps, then every row and every column must have at least one pixel.

Good examples:

жжжж  ж  ж   жжжж 

ж ж   ж ж     ж

жж ж  жжж    ж

 жжж  ж  ж    жжж
 
 Bad examples:
1.  Here is filling in the pixel {1,1}:
жж ж

жжж 

ж   

ж
 
2. Here is no pixel in last column:

жжж

ж ж

ж ж

жж 
 
3. Here is gap by the pixel {4, 1}
ж  ж

жж  

жжжж

ж
 
So for no gaps and no fillings we are need:

5. At least one white pixel near of every black pixel
6. At least one black pixel near of every black pixel

