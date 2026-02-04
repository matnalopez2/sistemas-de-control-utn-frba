%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejemplo#1. Teoría Unidad 6 2da. Parte
%%%% Sistemas de Control
%%%%
%%%% Red de Adelanto de Fase
%%%%
%%%% Se pide MF=50°, MG>=10dB y Kv=20 1/s
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
close all

K=2;
G=tf(10,poly([0 -1]));
disp('Ganancia a lazo abierto con compensación para Kv')
G1=K*G
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Bode G1(s)');
margin(G1)
grid
fim=48; % Fase propuesta, 10.8° mas de lo necesario
disp('Valor de alfa para el MF deseado:')
alfa=(1-sin(fim*pi/180))/(1+sin(fim*pi/180))
disp('Atenuación a la frecuencia wm donde se producirá el máximo de fase:')
G1_wc=-20*log10(1/sqrt(alfa))
disp('A partir del Bode de G1(w), la wc=wm es:')
wc=7.19
disp('Valor absoluto del cero del compensador de adelanto de fase:')
Z=sqrt(alfa)*wc
disp('Valor absoluto del polo del compensador de adelanto de fase:')
P=Z/alfa
disp('Ganancia en alta frecuencia del compensador de adelanto de fase:')
Kc=K/alfa
disp('Compensador de adelanto:')
Gc=tf(Kc*[1 Z],[1 P])
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Bode Gc(s)G(s)');
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Respuesta en frecuencia de Gc(w)');
bode(Gc)
grid;
M1=feedback(G,1);
M2=feedback(Gc*G,1);
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Bode M(s)');
bode(M1,M2)
grid
legend('Sin compensar','Compensado RAF')
F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Respuesta al escalón');
step(M1,M2,6)
grid
legend('Sin compensar','Compensado')
F6=figure(6);
set(F6,'position',[300 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#1. Red de Adelanto de Fase. Respuesta a la rampa');
[y1,t1]=step(M1*tf(1,[1 0]),4);
[y2,t2]=step(M2*tf(1,[1 0]),4);
plot(t1,t1,'k',t1,y1,'b',t2,y2,'r');
grid
xlabel('time(s)')
ylabel('Amplitude')
legend('Rampa unitaria','Sin compensar','Compensado')
