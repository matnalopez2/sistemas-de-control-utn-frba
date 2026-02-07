%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio#4. TP#8b
%%%% Sistemas de Control
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

Kv=4;
G=tf([1 .1],[1 0 1])
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 4. Bode G(s)');
margin(G)
grid
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 4. Bode Gc(w)G(w). Controlador PI');
Z=3; % Propongo el cero en esta frecuencia para conseguir un buen margen de fase
Kp=Kv/(0.1*Z); % Surge del Kv pedido
Gc=tf(Kp*[1 Z],[1 0])
margin(Gc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 4. Bode M(s)');
M=feedback(Gc*G,1)
bode(M)
grid
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 4. Respuesta al escalón');
step(M,20);
grid
F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 4. Respuesta a la rampa');
[y,t]=step(M*tf(1,[1 0]),20);
plot(t,t,'r',t,y,'b')
grid
F6=figure(6);
set(F6,'position',[300 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 4. Nyquist');
nyquist(Gc*G)
axis([-4 4 -4 4])
grid