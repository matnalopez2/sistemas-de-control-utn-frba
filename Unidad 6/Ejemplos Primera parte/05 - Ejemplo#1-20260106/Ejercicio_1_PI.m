%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Final Sistemas de Control. 17/02/2021                                   %
%                                                                         %
% Ejercicio#1 Realimentación Completa Vector de Estados con polo en s=0   %
% y cálculo de PI para tratar de igualar la realimentación de estados    %
%                                                                         %
% Dr. Ing. Franco Martin Pessana                                          %
%                                                                         %
% Facultad Regional Buenos Aires                                          %
% Universidad Tecnológica Nacional                                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

disp('Vector de realimentación de Estados calculado analíticamente:')
K=[11 8 20]
A=[-1 1 0;-K(1) -(3+K(2)) K(3);-1 0 0];
B=[0 0 1]';
C=[1 0 0];
D=[0];
SS=ss(A,B,C,D);
disp('Polos a lazo cerrado deseados:')
Au=eig(A);
Au
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 17/02/2021. Respuesta al escalón con estados');
step(SS);
grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Diseño Clásico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G=tf(1,conv([1 3],[1 1]));
H=1;
Gc=tf([1 4/3],[1 0]);
[NGc,DGc]=tfdata(Gc,'v');
GcGH=Gc*G*H;
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#1. Final SC 17/02/2021. Lugar de raíces de Gc(s)G(s)H(s)');
rlocus(GcGH)
grid
disp('Constante proporcional del PI:')
KP=3 % De rlocus o bien, analíticamente por cond. de magnitud
disp('Constante de integración del PI:')
KI = NGc(2)*KP
disp('Transferencia del Controlador PI:')
Gc=KP*Gc
disp('Transferencia a lazo cerrada controlada:')
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
         'NumberTitle','off','name', 'Ejercicio#1. Final SC 17/02/2021. Resupesta al Escalón con PI');
M=feedback(Gc*G,1)
step(M)
grid