% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Ejercicio 4 - Guía de TP 9
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

A = [0 1 0; 0 0 1; -6 -11 -6]
B = [0 0 1]'
C = [4 5 1]
D = [0 0 0]'

%% Resolución

esCtrb = utils.realim_VE.esControlable(A, B);
esObsv = utils.realim_VE.esObservable(A, C);