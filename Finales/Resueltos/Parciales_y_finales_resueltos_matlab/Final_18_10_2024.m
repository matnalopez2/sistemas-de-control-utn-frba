clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%Dada la siguiente planta con realimentacion unitaria, se pide:
%1) Aplicando el criterio de Nyquist obtener margen de fase y ganancia
%2) Controlador serie para seguir perfectamente un escalon unitario,
%Mp<=5% y ts_2%<=4s
%3) Esquema en simulink
%4) En caso de no cumplir con lo pedido, explicar porque

%Transferencia
num= [0 0 0 6];
den= [1 3 3 1];

G=tf(num,den)
F1=figure(1);
zplane(num,den)

%Nyquist no se, uso matlab
F2=figure(2);
margin(G);
grid;

%Compensador:
%Propongo PID polo en cero, cero doble en 0.58
num2= [1 1.16 0.336];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

%Root locus para obtener e valor de K
F3=figure(3);
rlocus(GH) 
ylim([-5 5])
grid;

%Sistema ya compensado
F4=figure(4);
KD=0.2;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%No cumple el tiempo de asentamiento debido a la ubicacion de los polos
%dominantes

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Empleando la misma planta, se pide:
%1) Realimentacion del vector de estados, para lograr los mismos parametros
%solicitados 
%2) Simulink
%3) Ancho de banda

%Obtengo modelo de estados (OBTENGO ESPEJADAS) debo acomodarlas
[A B C D]=tf2ss(num,den);
A=flipud(A);
A=fliplr(A) %Matriz final A

B=flipud(B);
B=fliplr(B) %Matriz final B

C=flipud(C);
C=fliplr(C) %Matriz final C

D=flipud(D);
D=fliplr(D) %Matriz final D

%averiguo si es controlable
Co=ctrb(A,B)
Size = size(Co)
R = rank(Co)

%verifico si es menor al número de columnas de la matriz
%En caso de serlo, no es controlable
if R >= (Size(2))   %2 columnas
    disp('El sistema es controlable');
else
    disp('El sistema no es controlable');
end

%averiguo si es observable
Obs=obsv(A,C)

%verifico si es menor al número de columnas de la matriz
%En caso de serlo, no es observable
Size = size(Obs);
R = rank(Obs);
if R >= (Size(2))   %2 columnas
    disp('El sistema es observable');
else
    disp('El sistema no es observable');
end

%Estimador
%Propongo polos en -4-4i -4+4i y el tercero en -20, 5 veces mas alejado que
%los dominantes para evitar interferencia
P = [-4+4i -4-4i -20] %polos a lazo cerrado
K = acker(A,B,P) %Calculo la matrix K
An=A-B*K            
%C = [1 0  ; 0 1 ]; %Matriz para las posiciones iniciales
PLC_d=eig(An) %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo, (ganancia 1)
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F5=figure(5);
step(sys)
stepinfo(sys)
grid on;

%Ancho de banda (Uso esta funcion o calculo cuando en el bode empieza a bajar la
%transferencia) Es aproximadamente 5.44rad/seg
fb = bandwidth(sys)

%Calculo bode
An=A-B*K
Bn=go*B
[num,den]=ss2tf(An,Bn,C,D);
Gn=tf(num,den)

F6=figure(6);
step(Gn)
stepinfo(Gn)

F7=figure(7);
bode(Gn)

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Dado el siguiente servomecanismo de posicion de pide:
%1) Funcion transferencia
%2) Velocidad final de la masa al aplicarle un escalon de 10v

Ra=2;
La=0;
Jm=8e-6;
Bm=4e-6;
kb=0.02;
kt=0.02;
Bg=2e-6;
R=0.1;
M=1;
%Relaciones de transformacion=
n1=1/3;
n2=R;
%equivalentes:
Jeq=Jm+M/(n1*n1*n2*n2);
Beq=Bm+Bg/(n1*n1);

%Transferencia (Va/Vm)
num3= [0 0 kt];
den3= [La*Jeq*n1*n2 La*Beq*n1*n2+Jeq*Ra*n1*n2 Ra*Beq*n1*n2+kt*kb*n1*n2];
G3=tf(num3,den3)
F8=figure(8);
step(G3); 
stepinfo(G3)
grid;