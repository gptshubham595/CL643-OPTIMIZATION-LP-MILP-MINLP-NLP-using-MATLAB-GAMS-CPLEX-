obj=@(x) x(1)-x(2)+2*x(1)^2+2*x(1)*x(2)+x(2)^2;
x=fmincon(obj,[0,0],[],[],[],[],[-inf,-inf],[inf,inf]);
ans=obj(x)