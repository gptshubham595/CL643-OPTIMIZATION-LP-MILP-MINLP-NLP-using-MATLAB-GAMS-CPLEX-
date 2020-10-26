SET 
 i index 1 /1*4/ ;
VARIABLES
 z objective value;
Positive Variable x;

EQUATIONS

OBJ ,
CON1 ,
CON2 ,
CON3 ,
CON4;

OBJ .. z =E= x('1')*x('2') + x('3')*x('4');
CON1.. x('1')**2 -x('2')**2 -x('3')**2 + x('4')**2=L=5;
CON2.. x('1')**2 +x('2')**2 +x('3')**2 + x('4')**2=l=400;
CON3.. x('1')+x('2') + x('4')=L=20;
CON4.. x('4')+x('2')-x('3')=g=0;
x.l(i) = 1;

Model NLPproblem /all/;

solve NLPproblem using NLP maximizing z;

display x.l,z.l;