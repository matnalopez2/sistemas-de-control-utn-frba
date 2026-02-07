%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio #1, #2 y #3 Control Péndulo Invertido 
%%%
%%% Dr. Ing. Franco Pessana
%%%
%%% Final Sistemas de Control 23-06-2021
%%%
%%% FRBA
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear
clc

Ts = 1e-3; % Período de Muestreo
Tf = 5; % Tiempo final de análisis
m = 0.5;  % [Kg]
M = 2;   % [Kg]
l = 0.5; % [m]
g = 9.81; % [m/s^2]

t=0:Ts:Tf-Ts; % Vector de tiempo de análisis
r=ones(size(t)); % Señal de referecia para control por real. de estados

% Armado del Modelo de Estados
A = [0 1 0 0;...
    (m+M)*g/(M*l) 0 0 0;...
     0 0 0 1;...
     -m*g/M 0 0 0];
B = [0 -1/(M*l) 0 1/M]';
C = [1 0 0 0;0 0 1 0];
D = [0 0]';

disp('Polos del Péndulo sin Controlar (Ejercicio 1b):')
P_LA=eig(A)
[Num,Den]=ss2tf(A,B,C,D);
disp('Transferencia de la posición angular Tita(s)/U(s), (Ejercicio 2a):')
X_U=tf(Num(1,:),Den)
disp('Transferencia de la posición lineal X(s)/U(s), (Ejercicio 2a):')
X_U=tf(Num(2,:),Den)
C=[0 0 1 0]; % C nueva para calcular el modelo SISO por real. estados
P_LC=[-1+1j*sqrt(3) -1-1j*sqrt(3) -5 -5];
disp('Vector de Realimentación de estados:')
K=acker(A,B,P_LC)
disp('Ganancia de la señal de referencia:')
g0=1/(C*inv(B*K-A)*B)
C = [1 0 0 0;0 0 1 0]; % Nuevamente para ver posición angular y lineal
AN=A-B*K;
BN=g0*B;
Pend_Inv_Cont=ss(AN,BN,C,D);
[y,t]=lsim(Pend_Inv_Cont,r,t);
H1=figure(1);
set(H1,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #3. Final SC 23/06/2021. Péndulo Invertido Controlado',...
    'position',[20 30 1200 700]);
subplot(2,1,1)
plot(t,y(:,1)*180/pi)
grid
xlabel('t (s)')
ylabel('ángulo del péndulo (°)')
subplot(2,1,2)
plot(t,y(:,2))
grid
xlabel('t (s)')
ylabel('posición de Carro y Péndulo (m)')
H2=figure(2);
set(H2,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #3. Final SC 23/06/2021. Péndulo Invertido Controlado. Mp y ts 2%',...
    'position',[80 30 1200 700]);
step(Pend_Inv_Cont,5)
grid