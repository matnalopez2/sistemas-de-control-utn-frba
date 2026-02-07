clear all
clc
close all

s = tf('s');
G = 5 / (s*(s*0.5+2))

% rlocus(G)

Gc = 1.6
M = feedback(Gc*G, 1)
wo = 2*sqrt(3)
[p, z] = pzmap(M)
p
