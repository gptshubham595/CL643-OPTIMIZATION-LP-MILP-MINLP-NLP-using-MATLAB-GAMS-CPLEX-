$inlinecom /* */
/* SUDOKU, Number Placement Puzzle */

/* Based on an example written in GNU MathProg by Andrew Makhorin <mao@mai2.rcnet.ru> */

/* Sudoku, also known as Number Place, is a logic-based placement
   puzzle. The aim of the canonical puzzle is to enter a numerical
   digit from 1 through 9 in each cell of a 9x9 grid made up of 3x3
   subgrids (called "regions"), starting with various digits given in
   some cells (the "givens"). Each row, column, and region must contain
   only one instance of each numeral.

   Example:

   +-------+-------+-------+
   | 5 3 . | . 7 . | . . . |
   | 6 . . | 1 9 5 | . . . |
   | . 9 8 | . . . | . 6 . |
   +-------+-------+-------+
   | 8 . . | . 6 . | . . 3 |
   | 4 . . | 8 . 3 | . . 1 |
   | 7 . . | . 2 . | . . 6 |
   +-------+-------+-------+
   | . 6 . | . . . | 2 8 . |
   | . . . | 4 1 9 | . . 5 |
   | . . . | . 8 . | . 7 9 |
   +-------+-------+-------+

   (From Wikipedia, the free encyclopedia.) */

sets i / 1*9 /; alias (i,j,k);
Parameter givens(i,j) the "givens"

binary variable x(i,j,k) "x[i,j,k] = 1 means cell [i,j] is assigned number k"

Equations fa(i,j,k) assign pre-defined numbers using the "givens"
          fb(i,j)   each cell must be assigned exactly one number
          fc(i,k)   cells in the same row must be assigned distinct numbers
          fd(j,k)   cells in the same column must be assigned distinct numbers
          fe(i,j,k) cells in the same region must be assigned distinct numbers ;


fa(i,j,k)$givens[i,j]..  x[i,j,k] =e= ord(k)=givens(i,j);

fb(i,j)..  sum(k, x[i,j,k]) =e= 1;

fc(i,k)..  sum{j, x[i,j,k]} =e= 1;

fd{j,k}..  sum{i, x[i,j,k]}=e= 1;

set m / 1*3 /; alias (m,n); parameter s(m) / 1 0, 2 1, 3 2 /;

fe{I,J,K}$((mod(ord(i),3)=1) and (mod(ord(j),3)=1)).. sum((m,n), x[i+s(m),j+s(n),k]) =e= 1;

variable obj; equation objdef; objdef.. obj =e= 1;

model sudoku / all /;


table givens
               1 2 3 4 5 6 7 8 9
           1   5 3     7
           2   6     1 9 5
           3     9 8         6
           4   8       6       3
           5   4     8   3     1
           6   7       2       6
           7     6         2 8
           8         4 1 9     5
           9           8     7 9 ;


option limrow=0,limcol=0,solprint=off;
solve sudoku us mip min obj;

file rep; put rep 'Solution' /;
loop(i,
   PUT$(mod(ord(i),3)=1) / " +-------+-------+-------+";
   put /;
   loop(j,
      put$(mod(ord(j),3)=1) " |";
      put sum(k, x.l[i,j,k]*ord(k)):2:0 );
   put " |" )
put / " +-------+-------+-------+";