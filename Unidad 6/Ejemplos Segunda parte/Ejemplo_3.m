%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejemplo#3. Teoría Unidad 6 2da. Parte
%%%% Sistemas de Control
%%%%
%%%% Red de Adelanto-Retraso de Fase
%%%%
%%%% Se pide MF=50°, MG>=10dB y Kv=10 1/s
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

Kc=20;
G=tf(2,poly([0 -1 -4]));
disp('Ganancia a lazo abierto con compensación para Kv')
G1=Kc*G
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Red de Adelanto-Retraso de Fase. Bode G1(s)');
margin(G1)
grid
disp('Frecuencia angular elegida para lograr MF de 50°:')
wc=2
disp('Frecuencia angular del cero del retrasador:')
Zrf=0.1*wc
fim=55; % Fase propuesta, 5° mas de lo necesario
disp('Valor de beta para el MF deseado:')
beta=(1+sin(fim*pi/180))/(1-sin(fim*pi/180))
disp('Frecuencia angular del polo del retrasador:')
Prf=Zrf/beta
disp('Atenuación requerida en wc:')
Aten=-6.02
inv_beta_dB=20*log10(1/beta)
disp('Frecuencia angular del cero del adelantador:')
Zaf=wc*10^((inv_beta_dB-Aten)/20)
disp('Frecuencia angular del polo del adelantador:')
Paf=beta*Zaf
disp('Compensador de Adelanto-Retraso de fase:')
Gc=tf(Kc*conv([1 Zrf],[1 Zaf]),conv([1 Prf],[1 Paf]))
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Red de Adelanto-Retraso de Fase. Bode Gc(s)G(s)');
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Gc(w). Respuesta en frecuencia de la red de Adelanto-Retraso');
bode(Gc);
grid
M1=feedback(G,1);
M2=feedback(Gc*G,1);
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Red de Adelanto-Retraso de Fase. Bode M(s)');
bode(M1,M2)
grid
legend('Sin compensar','Compensado RARF')
F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Red de Adelanto-Retraso de Fase. Respuesta al escalón');
step(M1,M2,20)
grid
legend('Sin compensar','Compensado')
F6=figure(6);
set(F6,'position',[300 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejemplo#3. Red de Adelanto-Retraso de Fase. Respuesta a la rampa');
[y1,t1]=step(M1*tf(1,[1 0]),20);
[y2,t2]=step(M2*tf(1,[1 0]),20);
plot(t1,t1,'k',t1,y1,'b',t2,y2,'r');
grid
xlabel('time(s)')
ylabel('Amplitude')
legend('Rampa unitaria','Sin compensar','Compensado')