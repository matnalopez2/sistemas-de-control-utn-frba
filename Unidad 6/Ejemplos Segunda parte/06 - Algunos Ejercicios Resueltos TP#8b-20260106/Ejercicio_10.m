%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio 10. TP#8b
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

G=tf(4,poly([-1 -1 -1]))
Ms=feedback(G,1);
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 10. Bode G(s)');
margin(G)
grid
K=10^(-10/20);
Z=0.22;
Gc=K*tf([1/Z 1],1);
%Gc=1.1905*0.4724*tf([1 1/1.1905],1)
GH=G*Gc;
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 10. Bode G(s) con controlador derivativo');
margin(GH)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 10. Bode G(s) con controlador derivativo');
M=feedback(G*Gc,1)
bode(M);
grid
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 10. Bode G(s) con controlador derivativo');
step(M,Ms);
grid
legend('Controlado','Sin Controlar')