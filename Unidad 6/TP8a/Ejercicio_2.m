clear all
clc
close all

K = 8
T = 1/4

s = tf('s')
Gc = K*(T*s +1)
G = 1 / (s*(s+2))

M = feedback(Gc*G, 1);

pole(M)