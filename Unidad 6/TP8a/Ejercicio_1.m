clear all
clc
close all

% Defino polo a 5 veces de la parte real de los CC dominantes
a = 7.5
T2 = 1 / ( 2 + a)
K = (9 * a * T2) / 10
T1 = (((9 + 3*a) * T2) - 1) / ( 10 * K)

% Verifico que haya quedado según pide el enunciado
s = tf('s');
H = 1;
G = 10/(s*(s+1));
Gc = (K*(T1*s+1)/(T2*s+1));

T = feedback(Gc*G, 1);
[numT, denT] = tfdata(T,'v');
denT
disp('Los polos del a lazo cerrado son:')
PLC = roots(denT)
% [p,z] = pzmap(T)
