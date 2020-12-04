clc;
clear all;
[N,M,K,w] = NSF();

c = w';

ycoeff = c(:);
f = ycoeff;
for k=1:K
    f = [f;zeros(N*M,1)];
end
f = [f;zeros(N*M*M,1)];

X = [];
Q = [];
for k = 1:K+1
    P = zeros(M,N*M);                  %2 3 4 5 6 RHS
    Y = [];
    for j=1:M
        y = zeros(N,M);
        for i=1:N
            if w(i,j)~=0
                y(i,j) = 1;
            end
        end
        y = y';
        y = y(:);
        Y = [Y;y'];
    end
    P(:,:,k) = Y;
    Q((k-1)*M+1:k*M,:,k) = P(:,:,k);
end
X = reshape(Q,(K+1)*M,(K+1)*N*M);
b = 1*ceil(N*K/M)*ones(M,1);
b = [b;1*ceil(N/M)*ones(K*M,1)];


Q = [];
for k = 1:K+1
    P = zeros(M,N*M);                  %2 3 4 5 6 LHS
    Y = [];
    for j=1:M
        y = zeros(N,M);
        for i=1:N
            if w(i,j)~=0
                y(i,j) = -1;
            end
        end
        y = y';
        y = y(:);
        Y = [Y;y'];
    end
    
    P(:,:,k) = Y;
    Q((k-1)*M+1:k*M,:,k) = P(:,:,k);
end
dd = reshape(Q,(K+1)*M,(K+1)*N*M);
X = [X;dd];
b = [b;-1*floor(N*K/M)*ones(M,1)];
b = [b;-1*floor(N/M)*ones(K*M,1)];
%X*y-b;


Y=[];                                      %13,14,15,16
Q = [];
P = [];
for k = 1:K
    S = [];
    for i=1:N
        for j=1:M
            if w(i,j)~=0
                s = zeros(N,M);
                s(i,j) = 1;
                s = s';
                s = s(:);
                S = [S;s'];
                
                y = zeros(N,M);
                y(i,j) = -1;
                y = y';
                y = y(:);
                Y = [Y;y'];
            else
                s = zeros(1,N*M);
                S = [S;s];
                
                y = zeros(1,N*M);
                Y = [Y;y];
            end
        end
    end
    P(:,:,k) = S;
    Q((k-1)*M*N+1:k*N*M,(k-1)*M*N+1:k*N*M,k) = P(:,:,k);
end

PP = 0;
for k=1:K
    PP = PP+Q(:,:,k);
end
Q = [Y,PP];
X = [X;Q];


b = [b;zeros((K)*N*M,1)];


X = [X,zeros((N*M*K)+(M*(K+1)*2) , N*M*M)];
Q = [];                                    %17,18,19
L = [];
S = [];
a=1;
for i = 1:N
    for j = 1:M
        for jdash = 1:M
            if j~= jdash && w(i,j)~=0 && w(i,jdash)~=0
                l = zeros(N,M);
                s = zeros(N,M);
                l(i,j)= 1;
                s(i,jdash)=1;
                l = l';
                l = l(:);
                s = s';
                s = s(:);
                L = [L;l'];
                S = [S;s'];
                xx(a,a) = 1;
                pp(a) = 1;
                a=a+1;
            else
                l = zeros(1,N*M);
                s = zeros(1,N*M);
                L = [L;l];
                S = [S;s];
                xx(a,a) = 0;
                pp(a)=0;
                a=a+1;
            end
        end
    end
end
ZZ = [L,S];
for k=1:K-1
    Q((k-1)*M*M*N+1:(k)*M*M*N,(k-1)*M*N+1:(k+1)*M*N) = ZZ;
end

y = zeros(N*M*M*(K-1),N*M);


Q = [y,Q];
xxx = [];
ppp = [];
for k = 1:K-1
    xxx = [xxx;xx];
    ppp = [ppp;pp'];
end
Q = [Q,-1*xxx];
X = [X;Q];

b = [b;ppp];


Xeq = [];
Qeq = [];
for k = 1:K+1
    P = zeros(N,N*M);                  %7 8 9 10 11
    Y = [];
    for i=1:N
        y = zeros(N,M);
        for j=1:M
            if w(i,j)~=0
                y(i,j) = 1;
            end
        end
        y = y';
        y = y(:);
        Y = [Y;y'];
    end
    P(:,:,k) = Y;
    Qeq((k-1)*N+1:k*N,:,k) = P(:,:,k);
end
Xeq = reshape(Qeq,(K+1)*N,(K+1)*N*M);
beq = K*ones(N,1);
beq = [beq;1*ones(K*N,1)];


QQ = [];                             %12
for i=1:N
    for j=1:M
        if w(i,j)~=0
            qq = zeros(N,M);
            qq(i,j) = 1;
            qq = qq';
            qq = qq(:);
            QQ = [QQ;qq'];
        else
            qq = zeros(1,N*M);
            QQ = [QQ;qq];
        end
    end
end
RR = [];
for k = 1:K
    RR = [RR,QQ];
end
RR = [-1*QQ,RR];
Xeq = [Xeq;RR];
beq = [beq;zeros(N*M,1)];


Xeq = [Xeq,zeros(N*(K+1)+N*M,N*M*M)];


e = 0.001;
alpha = 1000;
[rows1,~] = size(X);
X = [X,zeros(rows1,N*M*M)];

[rows2,~] = size(Xeq);
Xeq = [Xeq,zeros(rows2,N*M*M)];


a = 1;
ww1 = zeros(1,N*M*M);
ww2 = zeros(1,N*M*M);
sl = zeros(N*M*M);
for i = 1:N
    for j = 1:M
        for jdash = 1:M
            if j~=jdash && w(i,j)~=0 && w(i,jdash)~=0
                %xx(a) = w(i,j)<=w(i,jdash);
                ww1(a) = w(i,j);
                ww2(a) = w(i,jdash);
                sl(a,a) = 0;
                epsilon(a) = e;
                a = a+1;                                                                                                            kks=0;
            else
                %xx(a) = 0;
                ww1(a) = 0;
                ww2(a) = 0;
                sl(a,a) = 0;
                epsilon(a) = 0;
                a = a+1;
            end
        end
    end
end
xx2 = N*xx;
lhs1 = [zeros(N*M*M,N*M*(K+1)),xx2,-1*sl];
rhs1 = -1*ww1'+ww2'+N;
X = [X;lhs1];
b = [b;rhs1];

lhs2 = [zeros(N*M*M,N*M*(K+1)),-1*xx2,sl];
rhs2 = ww1'-ww2'-epsilon';

X = [X;lhs2];
b = [b;rhs2];



intcon = (1:((K+1)*N*M+N*M*M));
lb = zeros(1,((K+1)*N*M)+2*N*M*M);
ub = ones(1,((K+1)*N*M+N*M*M));
f = [f;alpha*pp'] 
[c,fval,exitflag] = intlinprog(f,intcon,X,b,Xeq,beq,lb,ub);
if exitflag==-2
    X = [];
    Q = [];
    for k = 1:K+1
        P = zeros(M,N*M);                  %2 3 4 5 6 RHS
        Y = [];
        for j=1:M
            y = zeros(N,M);
            for i=1:N
                if w(i,j)~=0
                    y(i,j) = 1;
                end
            end
            y = y';
            y = y(:);
            Y = [Y;y'];
        end
        P(:,:,k) = Y;
        Q((k-1)*M+1:k*M,:,k) = P(:,:,k);
    end
    X = reshape(Q,(K+1)*M,(K+1)*N*M);
    b = 1*ceil(N*K/M)*ones(M,1);
    b = [b;1*ceil(N/M)*ones(K*M,1)];
    
    
    Q = [];
    for k = 1:K+1
        P = zeros(M,N*M);                  %2 3 4 5 6 LHS
        Y = [];
        for j=1:M
            y = zeros(N,M);
            for i=1:N
                if w(i,j)~=0
                    y(i,j) = -1;
                end
            end
            y = y';
            y = y(:);
            Y = [Y;y'];
        end
        
        P(:,:,k) = Y;
        Q((k-1)*M+1:k*M,:,k) = P(:,:,k);
    end
    dd = reshape(Q,(K+1)*M,(K+1)*N*M);
    X = [X;dd];
    b = [b;-1*floor(N*K/M)*ones(M,1)];
    b = [b;-1*floor(N/M)*ones(K*M,1)];
    %X*y-b;
    
    
    Y=[];                                      %13,14,15,16
    Q = [];
    P = [];
    for k = 1:K
        S = [];
        for i=1:N
            for j=1:M
                if w(i,j)~=0
                    s = zeros(N,M);
                    s(i,j) = 1;
                    s = s';
                    s = s(:);
                    S = [S;s'];
                    
                    y = zeros(N,M);
                    y(i,j) = -1;
                    y = y';
                    y = y(:);
                    Y = [Y;y'];
                else
                    s = zeros(1,N*M);
                    S = [S;s];
                    
                    y = zeros(1,N*M);
                    Y = [Y;y];
                end
            end
        end
        P(:,:,k) = S;
        Q((k-1)*M*N+1:k*N*M,(k-1)*M*N+1:k*N*M,k) = P(:,:,k);
    end
    
    PP = 0;
    for k=1:K
        PP = PP+Q(:,:,k);
    end
    Q = [Y,PP];
    X = [X;Q];
    
    
    b = [b;zeros((K)*N*M,1)];
    
    
    X = [X,zeros((N*M*K)+(M*(K+1)*2) , N*M*M)];
    Q = [];                                    %17,18,19
    L = [];
    S = [];
    a=1;
    for i = 1:N
        for j = 1:M
            for jdash = 1:M
                if j~= jdash && w(i,j)~=0 && w(i,jdash)~=0
                    l = zeros(N,M);
                    s = zeros(N,M);
                    l(i,j)= 1;
                    s(i,jdash)=1;
                    l = l';
                    l = l(:);
                    s = s';
                    s = s(:);
                    L = [L;l'];
                    S = [S;s'];
                    xx(a,a) = 1;
                    pp(a) = 1;
                    a=a+1;
                else
                    l = zeros(1,N*M);
                    s = zeros(1,N*M);
                    L = [L;l];
                    S = [S;s];
                    xx(a,a) = 0;
                    pp(a)=0;
                    a=a+1;
                end
            end
        end
    end
    ZZ = [L,S];
    for k=1:K-1
        Q((k-1)*M*M*N+1:(k)*M*M*N,(k-1)*M*N+1:(k+1)*M*N) = ZZ;
    end
    
    y = zeros(N*M*M*(K-1),N*M);
    
    
    Q = [y,Q];
    xxx = [];
    ppp = [];
    for k = 1:K-1
        xxx = [xxx;xx];
        ppp = [ppp;pp'];
    end
    Q = [Q,-1*xxx];
    X = [X;Q];
    
    b = [b;ppp];
    
    
    Xeq = [];
    Qeq = [];
    for k = 1:K+1
        P = zeros(N,N*M);                  %7 8 9 10 11
        Y = [];
        for i=1:N
            y = zeros(N,M);
            for j=1:M
                if w(i,j)~=0
                    y(i,j) = 1;
                end
            end
            y = y';
            y = y(:);
            Y = [Y;y'];
        end
        P(:,:,k) = Y;
        Qeq((k-1)*N+1:k*N,:,k) = P(:,:,k);
    end
    Xeq = reshape(Qeq,(K+1)*N,(K+1)*N*M);
    beq = K*ones(N,1);
    beq = [beq;1*ones(K*N,1)];
    
    
    QQ = [];                             %12
    for i=1:N
        for j=1:M
            if w(i,j)~=0
                qq = zeros(N,M);
                qq(i,j) = 1;
                qq = qq';
                qq = qq(:);
                QQ = [QQ;qq'];
            else
                qq = zeros(1,N*M);
                QQ = [QQ;qq];
            end
        end
    end
    RR = [];
    for k = 1:K
        RR = [RR,QQ];
    end
    RR = [-1*QQ,RR];
    Xeq = [Xeq;RR];
    beq = [beq;zeros(N*M,1)];
    
    
    Xeq = [Xeq,zeros(N*(K+1)+N*M,N*M*M)];
    
    
    e = 0.001;
    alpha = 1000;
    [rows1,~] = size(X);
    X = [X,zeros(rows1,N*M*M)];
    
    [rows2,~] = size(Xeq);
    Xeq = [Xeq,zeros(rows2,N*M*M)];
    
    
    a = 1;
    ww1 = zeros(1,N*M*M);
    ww2 = zeros(1,N*M*M);
    sl = zeros(N*M*M);
    for i = 1:N
        for j = 1:M
            for jdash = 1:M
                if j~=jdash && w(i,j)~=0 && w(i,jdash)~=0
                    ww1(a) = w(i,j);
                    ww2(a) = w(i,jdash);
                    sl(a,a) = 1;
                    epsilon(a) = e;
                    a = a+1;                                                                                                            kks=0;
                else
                    ww1(a) = 0;
                    ww2(a) = 0;
                    sl(a,a) = 0;
                    epsilon(a) = 0;
                    a = a+1;
                end
            end
        end
    end
    xx2 = N*xx;
    lhs1 = [zeros(N*M*M,N*M*(K+1)),xx2,-1*sl];
    rhs1 = -1*ww1'+ww2'+N;
    X = [X;lhs1];
    b = [b;rhs1];
    
    lhs2 = [zeros(N*M*M,N*M*(K+1)),-1*xx2,sl];
    rhs2 = ww1'-ww2'-epsilon';
    
    X = [X;lhs2];
    b = [b;rhs2];
      
    intcon = (1:((K+1)*N*M+N*M*M));
    lb = zeros(1,((K+1)*N*M)+2*N*M*M);
    ub = ones(1,((K+1)*N*M+N*M*M));
    
    [c,fval,exitflag] = intlinprog(f,intcon,X,b,Xeq,beq,lb,ub);
end
