clc;
clear all;
close all;

a1=0:1:63;
b=dec2bin(a1);
COL=[];
for i=1:1:64
COL=[COL ; (str2num(b(i,1))*2-1)-j*(str2num(b(i,2))*2-1) ...
    (str2num(b(i,3))*2-1)-j*(str2num(b(i,4))*2-1)...
    (str2num(b(i,5))*2-1)-j*(str2num(b(i,6))*2-1) ];
end
COL=COL/sqrt(2);
INPUTMAT=[COL ones(size(COL,1),1)];
TARGET=COL;


ip=size(INPUTMAT,2);
op=size(TARGET,2);
n_hid=40;
lc=0.01;
W=rand(n_hid,ip)+j*rand(n_hid,ip);
V=rand(op,n_hid+1)+j*rand(op,n_hid+1);
LOSSCOL=[];

for epoch=1:1:10000
for L=1:1:64
INPUT=INPUTMAT(L,:); 
H=W*transpose(INPUT);
H=[H ;1];
HA=H./abs(H);
O=V*HA;
OA=O./abs(O);
EO=TARGET(L,:)-transpose(OA);

for l=1:1:op
[ux(l),uy(l),vx(l),vy(l)]=compute_uvxj(real(O(l)),imag(O(l)));
end
for m=1:1:op
for n=1:1:n_hid+1
     V(m,n)=V(m,n)+lc*conj(HA(n))*((ux(m)+j*uy(m))*real(EO(m))+(vx(m)+j*vy(m))*imag(EO(m)));
end 
end

for s=1:1:n_hid
for  p=1:1:op
  EH(s)=((ux(p)+j*uy(p))*real(EO(p))+(vx(p)+j*vy(p))*imag(EO(p)))*conj(V(p,s));
end
end
for t=1:1:n_hid
[ux(t),uy(t),vx(t),vy(t)]=compute_uvxj(real(H(t)),imag(H(t)));
end
X=INPUT;
for c=1:1:n_hid
for d=1:1:ip
W(c,d)=W(c,d)+lc*conj(X(d))*((ux(c)+j*uy(c))*real(EH(c))+(vx(c)+j*vy(c))*imag(EH(c)));
end
end
end
 LOSS=0;
 predicted=[];
for k=1:1:64
H=W*transpose(INPUTMAT(k,:));
H=[H ;1];
HA=H./abs(H);
O=V*HA;
OA=O./abs(O);

predicted=[predicted OA];
EO=TARGET(k,:)-transpose(OA);
LOSS=LOSS+norm(EO);
end
LOSSCOL=[LOSSCOL LOSS];  
end
plot(LOSSCOL);
xlabel('Eppoch');
ylabel('Error');



stem(real(TARGET(k,:))); hold on;
stem(real(transpose(OA))); hold on;
legend('TARGET', 'PREDICTED');