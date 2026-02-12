%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Ejercicio #3 Final SC 01/08/2024
%%%
%%% Sistemas de Control
%%%
%%% Dr. Ing. Franco Pessana
%%% Facultad Regional Buenos Aires
%%% Universidad Tecnológica Nacional
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

A = [0 0;1 0];
B = [1;0];
C = [0 1];
D = 0;
X0 = [1;0];

disp('Vector de realimentación de Estados en Regulador:')
K = [2 1]
disp('Autovalores de la Ecuación Característica:')
eig(A - B*K)
A_new = A - B*K
C_New = eye(2);
Sist = ss(A_new,[],C_New,D);
H1=figure(1);
set(H1,'NumberTitle','off','Menubar','none',...
    'name','Ejercicio #3. Final SC 01/08/2024. Evolución de los Estados Realimentados',...
    'position',[100 30 1200 800]);
initial(Sist,X0)
grid
