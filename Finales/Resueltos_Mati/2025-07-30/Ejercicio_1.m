% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio X 
% Realizado por: Matías Nahuel López
% 
% Universidad Tecnológica Nacional
% Facultad Regional de Buenos Aires
% 
% Legajo: 153.327-7
% Contacto: matias@matnalopez.com.ar
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inicialización

% Generales
clear; clc; close all;
s = tf('s');

% Para gráficos
T_inicio    = 0;
delta_t     = 0.01;
T_final     = 8;
t           = (T_inicio:delta_t:T_final)';


%% Datos del problema

syms M m g l s


%% Resolución

A = [0 1 0 0; 0 0 -m*g/M 0; 0 0 0 1; 0 0 g*(M+m)/(l*M) 0];
B = [0; 1/M ; 0; -1/(l*M)];
C = [1 0 0 0; 0 0 1 0];
D = [0;0];


eig(A)



% A,B,C,D ya definidos como sym

n = size(A,1);

G = simplify( C * ((s*eye(n) - A)\B) + D );   % evita inv(), usa \

G1 = simplify(G(1))   % theta/u
G2 = simplify(G(2))   % x/u

% opcional: numerador/denominador simbólicos
[num1, den1] = numden(G1);
[num2, den2] = numden(G2);

G1, G2












