%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio N° 1 Final SC 19/12/19
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

ts=1.5;
Mp=5;

disp('factor de amortiguamiento:')
psi=1/sqrt(1+(pi/log(100/Mp))^2)
disp('frecuencia angular natural:')
wn=4/(psi*ts)
disp('Polos a lazo cerrado queridos')
P_LC=-psi*wn+1j*wn*sqrt(1-psi^2)
Z1=1;
Z2=3;
Gc=tf(conv([1 Z1],[1 Z2]),[1 0])
P1=0;
P2=-1;
P3=-3;
G=tf([2 4],poly([P1 P2 P3]));
H=tf(12,[1 12]);
GH=G*H;
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 19/12/2019. RL Gc(s)G(s)H(s)');
rlocus(Gc*GH);
grid
Kd=2.2 % del Rlocus
Kp=4*Kd
Ki=3*Kd
disp('Ganancia del Controlador PID:')
Gc = Kd*Gc
M=feedback(Gc*G,H)

F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 19/12/2019. step M');
step(M);
grid

F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 19/12/2019. Bode M(s)');
[y,t]=step(M*tf(1,[1 0]),3);
plot(t,t,'r',t,y,'b')
legend('Rampa Unitaria','Salida Controlada')
grid

F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 19/12/2019. margin Gc(s)G(s)H(s)');
margin(Kd*Gc*G*H);
grid

F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 19/12/2019. Bode M(s)');
bode(M);
grid