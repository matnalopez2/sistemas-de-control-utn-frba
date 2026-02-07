clear all
close all
clc

% Planta
G=tf([4e4],[1 1e4 2004 4e4])

% Controlador con un polo en el origen (integrador)
Gc=zpk([],[0],[1])

% Rlocus de los polos a lazo abierto
figure();
rlocus(Gc*G)

% Polos a lazo cerrado propuestos
PLC=-3+3*i

% Calculo del criterio de fase
alpha=angle(PLC-(-1+2*i))*(180/pi)
gamma=angle(PLC-(0))*(180/pi)
beta=angle(PLC-(-1-2*i))*(180/pi)
theta=angle(PLC-(-1e4))*(180/pi)

fase_polos=alpha+gamma+beta+theta
fase_ceros = -180+fase_polos
delta = fase_ceros/2

% Calculo de los ceros
z=(imag(PLC)/tan(delta*(pi/180)))+real(-PLC)

Gc=zpk([-z -z],[0],[1])

delta_calc= angle(PLC-(-z))*(180/pi)

criterio_fase = delta_calc*2-(alpha+gamma+beta+theta)

% Rlocus completo
figure();
rlocus(Gc*G)

% Controlador propuesto
Gc=zpk([-1.9 -1.9],[0],[1.71])

% Planta realimentada y controlada
M=feedback(Gc*G,1)

% Respuesta y polos a lazo cerrado
figure();
pzmap(M)

figure();
step(M)
