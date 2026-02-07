%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Final Sistemas de Control. 17/02/2021                                   %
%                                                                         %
% Ejercicio#2 Realimentación Múltiple y Estabilidad                       %
%                                                                         %
% Dr. Ing. Franco Martin Pessana                                          %
%                                                                         %
% Facultad Regional Buenos Aires                                          %
% Universidad Tecnológica Nacional                                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% Diseño de controlador clásico. Ejercicio#2
%%% Final 24/02/2021 %%%

clear
clc

G=tf(10,poly([0 -1 -10]));
K=2.22;
Kt=K-1;
G1=feedback(G,Kt*tf([1 0],1));
H=1;
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#2. Final SC 17/02/2021. LR de P(s)');
P=tf(10*[1 1],[1 11 0 0]);
rlocus(P);
grid
disp('Ganancia a lazo cerrado controlada')
M=feedback(K*G1,H)
[N_M,D_M]=tfdata(M,'v');
disp('Polos a lazo cerrado finales:')
P_LC=roots(D_M)
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#2. Final SC 17/02/2021. Respuesta al escalón');
step(M)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'Ejercicio#2. Final SC 17/02/2021. Respuesta a la rampa');
[y,t]=step(M*tf(1,[1 0]),6);
plot(t,t,'b',t,y,'r')
xlabel('t (sec)')
grid