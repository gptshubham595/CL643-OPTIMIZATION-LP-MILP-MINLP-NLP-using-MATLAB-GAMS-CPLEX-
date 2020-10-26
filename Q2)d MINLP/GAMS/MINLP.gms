Free VARIABLE z ;
Positive Variable x,r,h;
integer variable l,b;
EQUATIONS

OBJ ,
CON1 ,
CON2 ,
CON3 ,
CON4,
CON5,
CON6,
CON7,
CON8,
CON9;

OBJ .. z =E= 2*l+b + 2*3.14*r*r*h + x**3;
CON1.. l*b+sin(h)+x=g=50;
CON2.. l+b=g=-4;
CON3.. l+b=l=300;
CON4.. l+b+x=g=20;
CON5.. r+h-x=g=0;
CON6.. r+h-x=l=120;
CON7.. x=g=3;
CON8.. h=g=1;
CON9.. r=g=1;

Model MINLPproblem /all/;

solve MINLPproblem using MINLP minimizing z;

display x.l,r.l,h.l,l.l,b.l,z.l;