Integer Variable a,b,c,d;
Free Variable z;
Equations
Con1,
Con2,
Con3,
Con4,
Con5,
Obj;

Con1.. a+b+c+d =g=  100;
Con2.. b+2*c =g= 50;
Con3.. b+c =l= 70;
Con4.. 2*c-d =e= 20;
Con5.. a+b+c+d =l= 200;
Obj..    2*(a+b) + 2*(c+d) =e= z;

Model MIPproblem / all /;

solve MIPproblem using mip maximizing z;

display a.l, b.l, c.l,d.l,z.l;