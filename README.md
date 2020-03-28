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

    1111   1001   1111
    1010   1010   0100
    1101   1110   1000
    0111   1001   0111


 Bad examples:
1.  Here is filling in the pixel {1,1}:

      1101
      1110
      1000
      1000


2. Here is no pixel in last column:
 
      1110
      1010
      1010
      1100


3. Here is gap by the pixel {4, 1}:

      1001
      1100
      1111
      1000


So for no gaps and no fillings we are need:
 
  5. At least one white pixel near of every black pixel
  6. At least one black pixel near of every black pixel

