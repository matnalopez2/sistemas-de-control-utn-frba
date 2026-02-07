%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Ejemplo 6 Diseño
%%%%%
%%%%% Sistemas de Control
%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
clc

PLC = -2.5 + 3.5*1j;
Alfa = angle(PLC - (-5))*180/pi
Gamma = angle(PLC - (-0.5))*180/pi
Delta = angle(PLC - (0))*180/pi

Beta = Alfa + Gamma + Delta -180

Z1 = 0.01;
Z2 = 0.5;

Gc = tf(poly([-Z1 -Z2]),[1 0])
G = tf(0.25,poly([-0.01 -.5 -5]))
H = 1;
GcGH = Gc*G*H;
H1=figure(1);
set(H1,'NumberTitle','off','Menubar','none',...
    'name','Ejemplo de Diseño #6. Final SC 26/09/2017. Bode Gc(s)G(s)H(s)',...
    'position',[20 30 1200 800]);rlocus(GcGH)
axis([-6 0 -5 5]);
sgrid
Num = poly([-.01 -.5]);
Kd = 74.1
Kp = Num(2)*Kd
Ki = Num(3)*Kd

M = feedback(Kd*Gc*G,1)

H2=figure(2);
set(H2,'NumberTitle','off','Menubar','none',...
    'name','Ejemplo de Diseño #6. Final SC 26/09/2017. Bode Gc(s)Respuesta al Escalón',...
    'position',[60 30 1200 800]);step(M)
grid

PLC_dis = roots([1 5 18.52])












