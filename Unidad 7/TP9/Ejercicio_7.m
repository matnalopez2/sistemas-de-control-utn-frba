% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 3 - Guía de TP 9
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

% sistema críticamente amortiguado

ts = 2; %ts al 2%

A = [0 1; 3 0];
B = [0 1]';
% C = []
% D = []'

%% Resolución

esCtrb = utils.realim_VE.esControlable(A,B);

PLC = [-2.91 -2.91]

k = acker(A,B,PLC)