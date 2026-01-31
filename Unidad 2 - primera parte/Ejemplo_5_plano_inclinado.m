clear;
clc;

%%% Datos del problema %%%
M = 100; % Kg
m = 5; % Kg
g = 9.81; % m/s^2
Tita = pi/6;
t0 = 0;
tF = 4;
At = 1e-3;

Asist = [M+m m*cos(Tita);cos(Tita) 1];
Bsist = [0 g*sin(Tita)]';

Ac = Asist\Bsist;
disp('Aceleración de la Cuña M:')
aM = Ac(1);
disp(aM)
disp('Aceleración de la masa m:')
am = Ac(2);
disp(am)

%%%% Resolución de Velocidad y posición de M %%%%
X0M = [0;0];
AM = [0 1;0 0];
BM = [0 aM]';
CM = eye(2);
DM = [0;0];
M_Est_M = ss(AM,BM,CM,DM);
t = t0:At:tF;
ut = ones(size(t));
YM = lsim(M_Est_M,ut,t,X0M)
H1 = figure(1);
set(H1,'position',[20 20 1200 700],'NumberTitle','off',...
    'Menubar','none','name','Posición, Velocidad y Aceleración de masas M y m');
subplot(2,3,1)
g = plot(t,YM(:,1),'b');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('x_M(t) (m)')
title('Posición de M')
subplot(2,3,2)
g = plot(t,YM(:,2),'r');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('v_M(t) (m/s)')
title('Velocidad de M')
subplot(2,3,3)
g = plot(t,aM*ones(size(t)),'k');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('a_M(t) (m/s^2)')
title('aceleración de M')

%%%% Resolución de Velocidad y posición de m %%%%
X0m = [0;0];
Am = [0 1;0 0];
Bm = [0 am]';
Cm = eye(2)
Dm = [0;0];
M_Est_m = ss(Am,Bm,Cm,[]);
t = t0:At:tF;
ut = ones(size(t));
Ym = lsim(M_Est_m,ut,t,X0m);

subplot(2,3,4)
g = plot(t,Ym(:,1),'b');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('x_m(t) (m)')
title('Posición de m')
subplot(2,3,5)
g = plot(t,Ym(:,2),'r');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('v_m(t) (m/s)')
title('Velocidad de m')
subplot(2,3,6)
g = plot(t,am*ones(size(t)),'k');
grid
set(g,'linewidth',1.3);
xlabel('t (s)')
ylabel('a_m(t) (m/s^2)')
title('aceleración de m')

 

