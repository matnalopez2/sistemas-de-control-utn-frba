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

H = 1 / (0.25*s +1);

Gc1 = (+0.5*s - 1) / s;
Gc2 = (-0.5*s + 1) / s;


%% Resolución

K = 2;

L_a = K*Gc1*H;
L_b = K*Gc2*H;

% figure; nyquist(L_a); grid on; title('Nyquist L(jw) - inciso (a)');
% hold on; plot(-1,0,'rx','MarkerSize',10,'LineWidth',2); % punto -1

figure; nyquist(L_b); grid on; title('Nyquist L(jw) - inciso (b)');
hold on; plot(-1,0,'rx','MarkerSize',10,'LineWidth',2);

















