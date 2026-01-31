clc; clear;

H = 1;
G = tf (2, [1 0 0]);
s = tf('s');

M = (4*(s+4))/(s^2 + 4*s + 16)



%rlocus(M)
%step(M)


M2 = M * ((4)/(s+4))
figure(1)
step(M2)
figure(2)
rlocus(M2)