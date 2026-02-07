%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio 7. TP#8b
%%%% Sistemas de Control
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

G=tf(2,poly([-1 -1]))
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode G(s)');
margin(G)
grid
disp('constante proporcional para conseguir MF de 45°')
Kc=10^(10.6/20)
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode Gc(w)G(w) con controlador proporcional');
margin(Kc*G)
grid
F3=figure(3);
set(F3,'position',[180 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Respuesta al escalón con controlador proporcional');
M=feedback(Kc*G,1)
step(M);
grid
F4=figure(4);
set(F4,'position',[220 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode M(w) con controlador proporcional');
bode(M);
grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gc=tf(1,[1 0]);
F5=figure(5);
set(F5,'position',[260 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode Gc(w)G(w) con controlador integral sin KI');
margin(Gc*G)
grid
disp('constante Integral para conseguir MF de 45°, con 12.3 dB de atenuación')
KI=10^(-12.3/20)
disp('Tiempo de integracion')
Ti=1/KI
F6=figure(6);
set(F6,'position',[300 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode Gc(w)G(w) con controlador integral con KI');
margin(KI*Gc*G)
grid
F7=figure(7);
set(F7,'position',[340 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Respuesta al escalón con controlador Integral');
M2=feedback(KI*Gc*G,1)
step(M2);
grid
F8=figure(8);
set(F8,'position',[380 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 7. Bode M(w) con controlador Integral');
bode(M2);
grid