alphasize=3;
k=2;
dlt=0.1;
dp=50;
sample=10000;
s0 = zeros(1,10);
X00 = zeros(sample,dp);
VV = zeros(1,dp);
Nd=[];
kmer = [1,2];
m = seq2num(kmer,alphasize)
for i = 1:sample
    i
    s = s0;
    for j = 1:dp
        a = rand;
        if a<dlt
            s = flipdup(s,alphasize);
        else 
            s = randdup(s,1);
        end
        x = countfre(s,k,alphasize);
        X00(i,j) = x(m);
    end
end


VV= var(X00);
E = mean(X00);
%figure
%plot(1:dp,VV)




alphasize=3;
k=2;
M = alphasize^k;
L=10;
dlt=0.1;
q = [1-dlt,dlt];
ell=1;
D = create_k_mer_D_matrix(q,k,alphasize,ell);
G = create_k_mer_G_matrix(q,k,alphasize,ell);

var0 = zeros(M*(M+1)/2,1);
var0(1)=1;

BX=[];
Var=[];
kprime = 2*k-2;
Aflip = create_k_mer_A_matrix_noisydup(k,alphasize,ell);
Adup = create_k_mer_A_matrix([0,1],k,alphasize);
A = q(1)*Adup + q(2)*Aflip;
x0 = countfre(s0,k,alphasize);
Bflip = create_k_mer_A_matrix_noisydup(kprime,alphasize,ell);
Bdup = create_k_mer_A_matrix([0,1],kprime,alphasize);
B = q(1)*Bdup + q(2)*Bflip;
x1 = countfre(s0,kprime,alphasize);
for i= 1:dp
    var0 = var0*(L+i-1)^2/(L+i)^2 + G*(L+i-1)/(L+i)^2 * var0+D/((L+i)^2)*x1;
    x1 = (eye(alphasize^kprime)+B/(L+i))*x1;
    x0 = (eye(alphasize^k)+A/(L+i))*x0;
    BX= [BX,x0(m)];
    %var0 = (eye(4)+A/(10+i))*var0;
    Var = [Var,var0];
end
 VVV = zeros(1,dp);
 P1=zeros(1,dp);
 P2 = zeros(1,dp);
 O = zeros(M,M);
n = 1;
for i = 1:M
    for h = i:M
        O(i,h)=n;
        O(h,i)=n;
        n = n+1;
    end
end
n = O(m,m);
P1 = [];
P2 = [];
 for k = 1:dp
     comvar = (Var(n,k))-BX(k)^2;
     VVV(k) = comvar;
     P1 = [P1,BX(k)+3*sqrt(comvar)];
     P2 = [P2,BX(k)-3*sqrt(comvar)];
 end
 
figure()
plot(1:dp,VV,'*-')
hold on
plot(1:dp,VVV,'d-')
legend('Variance of $x_n^{12}$ over 10000 trials','$E[(x_n^{12})^2]-E[x_n^{12}]^2$')
xlabel('$n$','interpreter','latex')
set(legend,'Interpreter','latex')

% plot(1:dp,BX)
% hold on 
% plot(1:dp,E)
% legend('$E[\mu_n^{01}]$','Expected value of $\mu_n^{01}$ over 5000 trials')
% set(legend,'Interpreter','latex')

%%
figure()
plot(1:dp,P1,'--')
hold on 
plot(1:dp,BX)
hold on 
plot(1:dp,P2,'-.')
legend({'$\mathbf{E}[\mu_n^{12}]+3\sigma_n^{12}$','$\mathbf{E}[\mu_n^{12}]$','$\mathbf{E}[\mu_n^{12}]-3\sigma_n^{12}$'},'interpreter','latex')
xlabel('$n$','interpreter','latex')
%%
n=4500;
P =[];
m=1;
p=0;
while p>=0
    %m = BX(n)-gamma*VVV(n);
    %M = [M,m];
    gamma =(BX(n)-m)/VVV(n); 
    p = 1-1/gamma^2;
    P = [P,p];
    m = m+1;
end
plot(1:length(P)-1,P(1:end-1))
xlabel('$m$','interpreter','latex')
ylabel('$1-\frac{1}{{\gamma''}^2}$','interpreter','latex')
title('lower bound of $\mathbf{P}(T_{12}(m)<4500)$ vs $m$','interpreter','latex')
%%
figure()
plot(1:dp,VV,'*-')
hold on
plot(1:dp,VVV,'d-')
legend('Variance of $x_n^{00}$ over 5000 trials','$E[(x_n^{00})^2]-E[x_n^{00}]^2$')
xlabel('$n$','interpreter','latex')
set(legend,'Interpreter','latex')
 %%

plot(1:dp,VVV)
hold on 
plot(1:dp,BX)
% legend('$E[\mu_n^{01}]$','Expected value of $\mu_n^{01}$ over 5000 trials')
% set(legend,'Interpreter','latex')

