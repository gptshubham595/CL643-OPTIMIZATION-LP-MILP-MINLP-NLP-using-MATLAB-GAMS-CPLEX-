%CASE1:1000,[500,500]
%CASE2:1000,[1000,1000]
%CASE3:2000,[500,500]
%CASE4:2000,[1000,1000]

clc;clear;
tic
%[PCL,PCM,PCH,CL,CM,CH,IL,IM,IH,SP,RM1,RM2,R,Budget,n]=ProductionData();
[PCL,PCM,PCH,CL,CM,CH,IL,IM,IH,SP,RM1,RM2,R,Budget,n]=ProductionDataCase1();
%[PCL,PCM,PCH,CL,CM,CH,IL,IM,IH,SP,RM1,RM2,R,Budget,n]=ProductionDataCase2();
%[PCL,PCM,PCH,CL,CM,CH,IL,IM,IH,SP,RM1,RM2,R,Budget,n]=ProductionDataCase3();
%[PCL,PCM,PCH,CL,CM,CH,IL,IM,IH,SP,RM1,RM2,R,Budget,n]=ProductionDataCase4();
ZO=zeros(n,1);
ON=ones(n,1);

%PAPER CITATIONS: https://www.tandfonline.com/doi/pdf/10.1080/03052150215722?needAccess=true

%       X,      Y,          Z,         L,         M,          H
F(1,:)=[-SP'   ;ZO          ;ZO        ;PCL'     ;PCM'       ;PCH'];  %EQ1  sum(j,SP(j)*X(j))-sum(j,PC('l',j)*L(j)+PC('m',j)*M(j)+PC('h',j)*H(j));

A(1,:)=[ON     ;ZO       ;-1000000*ON  ;ZO       ;ZO         ;ZO  ];  %EQ9(j) == X(j)=l=100000*Z(j); == 1*X+0*Y-10000Z+1*L+1*M+1*H=0

A(2,:)=[ZO     ;-1*ON       ;ZO       ;ON        ;ZO         ;ZO  ];  %Eqn6(j) == L(j)=l=Y(j);  == 0*X-1*Y+0*Z+1*L+0*M+0*H=0

A(3,:)=[ZO       ;ON        ;ZO       ;ZO        ;ZO         ;ON  ];  %EQ7(j) == H(j)=l=1-Y(j); == 0*X+1*Y+0*Z+0*L+0*M+1*H

A(4,:)=[RM1'     ;ZO        ;ZO       ;ZO        ;ZO         ;ZO  ];  %EQ11(k) == sum(j,rm(k,j)*X(j))=l=R(k); == RM1*X+0*Y+0*Z+0*L+0*M+0*H  k=1

A(5,:)=[RM2'     ;ZO        ;ZO       ;ZO        ;ZO         ;ZO  ];  %EQ11(k) == sum(j,rm(k,j)*X(j))=l=R(k); == RM1*X+0*Y+0*Z+0*L+0*M+0*H  k=2

A(6,:)=[ZO       ;ZO        ;ZO       ;IL'       ;IM'        ;IH' ];  %EQ13(j) == sum(j,IC('l',j)*L(j)+IC('m',j)*M(j)+IC('h',j)*H(j))=l=B; == 0*X+0*Y+0*Z+IL*L+IM*M+IH*H

B=[0;0;1;R(1);R(2);Budget]; % [A]=[B]  EQ 1,9,6,7,11,11,13 

intcon=(n+1:3*n);  % as X will be from 0 to n, Y = n+1 to 2*n, Z=2*n+1 to 3*n  and %Y,Z = integers%
lb=zeros(1,6*n);   %lowerbound are zeros 54*6 as 6 equations 
ub=inf(1,6*n);     %upperbound are inf 54*6 as 6 equations 
ub(n+1:3*n)=1;     %upperbound are 1 for Y, Z as they are binary variables 

%       X,      Y,          Z,         L,         M,          H
Aeq(1,:)=[ON   ;ZO         ;ZO        ;-1*CL'   ;-1*CM'    ;-1*CH'];  %EQ1(j)=== 1*X+0*Y+0*Z-L*CL-M*CM-H*CH  
Aeq(2,:)=[ZO   ;ZO         ;-1*ON     ;ON        ;ON         ;ON];   %EQ8 == L(j)+M(j)+H(j)=e=Z(j) == 0*X+0*Y-1*Z+1*L+1*M+1*H

Beq=[0;0];

[x,FVAL,EXITFLAG,OUTPUT]=intlinprog(F,intcon,A,B,Aeq,Beq,lb,ub);

FVAL=-1*FVAL;
FVAL=FVAL-2165.924
X=x(1:n);   Y=x(n+1:2*n);    Z=x(2*n+1:3*n);     L=x(3*n+1:4*n);     M=x(4*n+1:5*n);      H=x(5*n+1:6*n);
TOTAL_TIME=toc;