Positive Variable x,y,z,w;
Free Variable C;
Equations

Con1,
Con2,
Con3,
Con4,
Con5,
Con6,
Con7,
Obj;

Con1.. x+y =L= 700;
Con2.. z+w =L= 700;
Con3.. x+y =G= 200;
Con4.. x+z =E= 600;
Con5.. y+w =E= 400;
Con6.. x =L= 600;
Con7.. y =L= 400;
Obj..  5*x+10*y+15*z+4*w =E= C;

Model LPproblem /
Con1,
Con2,
Con3,
Con4,
Con5,
Con6,
Con7,
Obj/;

Options LP = Cplex;

Solve LPproblem using LP minimizing C;

Display x.L,y.L,z.L,w.L,C.L;