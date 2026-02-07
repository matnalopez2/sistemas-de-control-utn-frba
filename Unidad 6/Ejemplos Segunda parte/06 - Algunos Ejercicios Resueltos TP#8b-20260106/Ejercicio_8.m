%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio#8. TP#8b
%%%% Sistemas de Control
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

MG=10^(-2/20)
wx=roots([1 0 1 0 -9/MG^2])
disp('Retardo de Transporte para obtener un Margen de Ganancia de 2 dB:')
T=(pi/2-atan(wx(4)))/(wx(4))

G=tf(3,poly([0 -1]));
H=1;
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
        'NumberTitle','off','name', 'TP#9. Ejercicio 8. Bode G(s)H(s) para ver wx a -2dB');
bode(G*H)
grid