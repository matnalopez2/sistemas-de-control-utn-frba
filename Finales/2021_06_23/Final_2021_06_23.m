clc; clear; close all;

syms M m g l s 

A21 = ((M+m)*g)/(M*l);
A41 = - (m*g)/M;

B2 = -1 / (M*l);
B4 = 1/M;

A = [0 1 0 0;A21 0 0 0; 0 0 0 1; A41 0 0 0]
B = [0; B2; 0; B4]
C = [1 0 0 0;0 0 1 0]
D = [0;0]

%p = eig(A)                 % det(sI - A)
determ = det(s*eye(4) - A)  % det(sI - A)
%roots(determ)
polos = solve(determ == 0, s)
