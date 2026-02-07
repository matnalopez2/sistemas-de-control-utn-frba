clear all; clc; close all;

PLC = -2 + 1j * 2*sqrt(3);

s = tf('s');
G = 16 / ( s * ( s + 4 ) )

Gc = ( s + 0.05 ) / ( s + 0.01 )
[k, poles] = rlocfind(G*Gc, PLC)

Kv = dcgain (s*G*Gc*k)
ess = 1 / Kv

M = feedback(k*Gc*G, 1)

% Grafico respuesta a la rampa
t = 0:0.01:150;
t = t(:);
r = t;

y = lsim(M, r, t);
e = r - y;

figure; plot(t, r, t, y); grid on
legend('r(t)=t', 'y(t)'); xlabel('t [s]'); ylabel('amplitud');
title('Respuesta a la rampa (velocidad)');

figure; plot(t, e); grid on
xlabel('t [s]'); ylabel('e(t)'); title('Error de seguimiento a la rampa');

ess_num = mean(e(end-1000:end))   % promedio último ~10s
ess_num_last = e(end)             % último punto

