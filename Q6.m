obj=@(x) -(8-x)*15*(x/2);
lb=[0];
ub=[inf];
x=fmincon(obj,0,[],[],[],[],lb,ub);
2