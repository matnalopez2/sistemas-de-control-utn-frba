%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio#5. TP#8b
%%%% Sistemas de Control
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

G=tf(6,poly([0 -1 -2]))
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 5. Bode G(s)');
margin(G)
grid
fim=57; % Propongo 57 para conseguir mas de 45° de MF
Z=0.1 % Propongo cero del Compensador de retraso de fase en 0.1
Aten=-16.8 % Atenuación necesaria para conseguir MF de 57°
beta=1/10^(Aten/20)
P=Z/beta  % Polo del compensador de retraso de fase
Kc=1/beta % Ganancia del Compensador
Gc=Kc*tf([1 Z],[1 P])
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 5. Bode Gc(w)G(w) con retraso de fase');
M=feedback(Gc*G,1)
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 5. Respuesta al escalón');
step(M,40);
grid
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 5. Respuesta a la rampa');
[y,t]=step(M*tf(1,[1 0]),40);
plot(t,t,'r',t,y,'b')
grid