%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejemplo#2. Teoría Unidad 6 2da. Parte
%%%% Sistemas de Control
%%%%
%%%% Red de Retraso de Fase
%%%%
%%%% Se pide MF=45°, MG>=10dB y Kv=20 1/s
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%
%%%% Sistemas de Control
%%%% Facultad Regional Buenos Aires
%%%% Universidad Tecnológica Nacional
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

K=40;
G=tf(1,poly([0 -2]));
disp('Ganancia a lazo abierto con compensación para Kv')
G1=K*G
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Bode G1(s)');
margin(G1)
grid
disp('Frecuencia de cruce de 0 dB para conseguir MF deseado:')
wc=1.53 % Frecuencia para conseguir 53° MF
disp('Cero del compensador de retardo de fase:')
Z=wc/10
disp('Atenuación (dB) necesaria en la wc deseada')
Aten=20.4
disp('Índice beta para el compensador de retardo:')
beta=10^(Aten/20)
disp('Polo del compensador de retraso de fase:')
P=Z/beta
disp('Ganancia en alta frecuencia del compensador de retraso de fase:')
Kc=K/beta
disp('Compensador de retraso:')
Gc=tf(Kc*[1 Z],[1 P])
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Bode Gc(s)G(s)');
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Respuesta en frecuencia de Gc(w)');
bode(Gc)
grid;
M1=feedback(G,1);
M2=feedback(Gc*G,1);
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Bode M(s)');
bode(M1,M2)
grid
legend('Sin compensar','Compensado RRF')
F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Respuesta al escalón');
step(M1,M2,20)
grid
legend('Sin compensar','Compensado')
F6=figure(6);
set(F6,'position',[300 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#2. Red de Retraso de Fase. Respuesta a la rampa');
[y1,t1]=step(M1*tf(1,[1 0]),20);
[y2,t2]=step(M2*tf(1,[1 0]),20);
plot(t1,t1,'k',t1,y1,'b',t2,y2,'r');
grid
xlabel('time(s)')
ylabel('Amplitude')
legend('Rampa unitaria','Sin compensar','Compensado')