%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio 6. TP#9
%%%% Sistemas de Control
%%%%
%%%% Diseño con Red de Retraso de Fase
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

G=tf(100,poly([0 -5 -10]))
Ms=feedback(G,1);
K=50; % Para obtener un Kv=100 y en consecuencia, error a la rampa 1/Kv de 0.01 o sea 1%
G1=K*G
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 6. Bode G1(s)');
margin(G1)
grid
fim=50; % Propongo 50 para conseguir mas de 40° de MF
wfim=2.46 % Frecuencia donde se producirá en máximo de fase
Z=wfim/10 % Propongo el cero de la red de retraso una década por debajo de wfim
Aten=-31 % Atenuación necesaria para conseguir MF de 50°
beta=1/10^(Aten/20)
P=Z/beta
Kc=K/beta
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 6. Bode Gc(w)G(w) con retraso de fase');
Gc=Kc*tf([1 Z],[1 P])
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 6. Respuesta al escalón con retraso de fase');
M=feedback(Gc*G,1)
step(M,Ms,20);
grid
legend('Compensado','Sin compensar')
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 6. respuesta a la rampa con retraso de fase');
[yi,ti]=step(M*tf(1,[1 0]),20);
[yis,tis]=step(Ms*tf(1,[1 0]),20);
plot(ti,ti,'r',ti,yi,'b',tis,yis,'g')
grid
legend('r(t)','Compensado','Sin compensar')