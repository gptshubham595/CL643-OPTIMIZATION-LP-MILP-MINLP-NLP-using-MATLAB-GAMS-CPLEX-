Integer Variable a,b,c,d;
Free Variable z,e,f,g;
Equations
Con1,
Con2,
Con3,
Con4,
Con5,
Con6,
Con7,
Con8,
Con9,
Obj;

Con1.. a+b+c+d =g=  100;
Con2.. b+2*c =g= 50;
Con3.. b+c =l= 70;
Con4.. 2*c-d =e= 20;
Con5.. a+b+c+d =l= 200;
Con6..  e+f+g=g=10;
Con7..   e+f+g=l=100;
Con8..   e-f=g=2;
Con9..   g=g=1;
Obj..    2*(a+b) + 2*(c+d)+2*e+3*f+g =e= z;

Model MIPproblem / all /;

solve MIPproblem using mip maximizing z;

display e.l,f.l,g.l,a.l, b.l, c.l,d.l,z.l;


 
 
 