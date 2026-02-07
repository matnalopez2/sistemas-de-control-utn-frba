clear all; clc; close all;

PLC = -2 + 1j* 2*sqrt(3);
s = tf('s');

G = 10 / ( s * ( s + 2 ) * ( s + 5 ) );

p1 = 0; p2 = -2; p3 = -5;

alfa = rad2deg(angle(PLC - p1))
beta = rad2deg(angle(PLC - p2))
gamma = rad2deg(angle(PLC - p3))

condFase = alfa + beta + gamma

delta = condFase - 180

b = 2*sqrt(3);
a = b/tand(delta);

z = - p2 + a
Gc = (s + z)

Gc2 = (s+0.1042)/(s+0.01)

[k, poles] = rlocfind(Gc*G*Gc2, PLC)

M = feedback(k*Gc*G*Gc2, 1)
pzmap(M)

Kv = dcgain (s*G*Gc*k*Gc2)

t = 0:0.01:50;
t = t(:);
r = t;

y = lsim(M, t, t);
plot(y, t, 'y', r, t, 'b')
grid on

% Calculo el error en permanente

e = r - y;
ess_num = mean(e(end-200:end))   % promedio de los últimos 200 samples
