%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%% Ejercicio#3. TP#8b
%%%% Sistemas de Control
%%%% 
%%%% Diseño con red de adelanto de fase
%%%%
%%%% Dr. Ing. Franco Pessana
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

G=tf(10,poly([0 -1 -10]))
Ms=feedback(G,1);
K=4;
G1=K*G
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none',...
'NumberTitle','off','name', 'TP#9. Ejercicio 3. Bode G1(s)');
margin(G1)
grid
fim=45; % Propongo 45° a 17.7° para conseguir mas de 45° de MF
alfa=(1-sin(fim*pi/180))/(1+sin(fim*pi/180))
G1wm=-20*log10(1/sqrt(alfa)) % Ganancia a la frecuencia del máximo de fase del compensador
wm=2.96 % Frecuencia angular donde fim es máximo
Z=sqrt(alfa)*wm % Cero del Compensador de adelanto de fase
P=Z/alfa % Polo del compensador de adelanto de fase
Kc=K/alfa % Ganancia del Compensador
Gc=Kc*tf([1 Z],[1 P])
F2=figure(2);
set(F2,'position',[140 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 3. Bode Gc(w)G(w) Red de adelanto');
M=feedback(Gc*G,1)
margin(Gc*G)
grid
F4=figure(4);
set(F4,'position',[180 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 3. Respuesta al escalón');
step(Ms,M);
grid
legend('Sin compensar','compensado RAF')
F5=figure(5);
set(F5,'position',[220 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 3. Respuesta a la rampa');
[ys,ts]=step(Ms*tf(1,[1 0]),20);
[y,t]=step(M*tf(1,[1 0]),20);
plot(t,t,'r',t,y,'b',ts,ys,'g');
legend('r=t','compensado','sin compensar')
grid
F6=figure(6);
set(F6,'position',[260 20 900 650],'Menubar','none',...
            'NumberTitle','off','name', 'TP#9. Ejercicio 3. Respuesta a lazo cerrado');
bode(M)
grid