obj=@(x) -2*sin(x)+(x^2)/2;
lb=0;
ub=4;
x=fminbnd(obj,lb,ub);
ans=-1*obj(x)

