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

H = 1;

numG = [0 0 2];
denG = [1 4 2]; %(s*s + 4*s + 2);

G = tf(numG,denG);


% Del Mason:

G_1 = 1/s;

%% Resolución

[A,B,C,D] = utilsMati.generales.tf2ss_mati(numG, denG);

% A = [0 1; -2 -4]
% B = [ 0; 1]
% C = [2 0]
% D = [0]

PLC = [-4+4i -4-4i];

K = acker(A,B,PLC)



An = A - B*K;
PLC_dis = eig(An)

g0 = utilsMati.realim_VE.factorEscala(A,B,C,K)
