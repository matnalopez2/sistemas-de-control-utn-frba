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

M = 2;
m = 0.5;
l = 0.5;
g = 9.81;


%% Resolución

A = [0 1 0 0; 0 0 -m*g/M 0; 0 0 0 1; 0 0 g*(M+m)/(l*M) 0]
B = [0; 1/M ; 0; -1/(l*M)]
C = [1 0 0 0; 0 0 1 0]
D = [0;0]

eig(A)



utilsMati.realim_VE.esControlable(A,B);
utilsMati.realim_VE.esObservable(A,C);


PLC = [-1+1i -1-1i -5 -5]

K = acker(A,B,PLC)

An = A - B*K
eig(An)

g0 = utilsMati.realim_VE.factorEscala(A,B,C,K)






