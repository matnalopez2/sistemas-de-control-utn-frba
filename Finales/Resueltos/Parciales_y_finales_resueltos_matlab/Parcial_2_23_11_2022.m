clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%En el diagrama de la derecha, se muestra el esquematico de un sistema de
%frenado de emergencia de un tren. La fuerza F(s) impulsa al tren a una
%velocidad v(t). Se pide:
%1) Modelo de estados del sistema completo, variables de estado naturales
%2) Mediante diagrama de flujo de estados y mason, calcule la transferencia
%de la planta
%3) Usando Matlab, demostrar que se necesitan como 50s para detener el tren
%con oscilaciones de casi +-20m 

m=50000;
k1=40000;
k2=10000;
b1=10000;
b2=1000;
vo=80;

%matrices de estado
%Entrada x1=v1, x2= fki, x3=fk2
A = [-b1/m, -1/m, -1/m ; k1, 0, 0 ; k2, 0, -k2/b2]
B = [1/m ; 0 ; 0]
C = [1, 0, 0]
D = [0]

Ci = [1 0 0 ; 0 1 0 ; 0 0 1];     %Matriz para las posiciones iniciales
ME=ss(A,B,Ci,D);
Xo=[22.22 0 0];
F1=figure(1);
initial(ME,Xo)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Debido a la pobreperformance s edesea realizar una realimentacion competa
%del vector de estados en confuguracion regulador , busco:
%1) Respuesta lo mas rapida posible, sin oscilaciones y Ts_2s<2 seg
%2) Verificacion simulink y desplazamiento maximo
%3) Solo tengo acceso a velocidad impulsora y velocidad del tren, diseñar
%lo mismo que en "1"
%4) verificacion simulink y desplazamiento maximo

%Sin oscilacion= polos dominantes reales 

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
P = [-3 -3 -15]                  %polos a lazo cerrado
K = acker(A,B,P)                 %Calculo la matrix K
An=A-B*K;            
Ci = [1 0 0 ; 0 1 0 ; 0 0 1];     %Matriz para las posiciones iniciales
PLC_d=eig(An);                   %Posicion de los polos a lazo cerrado de diseño

X0 = [1 0 0];               
sys = ss(An, [], Ci, []); 
F2=figure(2);
initial(sys, X0)
grid on;

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%A partir de la planta inestable que se muestra en la figura, se pide:
%1) Diseñar un sistema de control que Mp<=5% y Ts_2%<1seg - Simulink
%2) Estimacion completa del vector de estados  - Simulink

num= [0 0 1];
den= [1 -4 12];

G=tf(num,den)
F3=figure(3);
zplane(num,den)

%Compensador:
%Propongo PID polo en cero, cero doble en -0.87
num2= [1 1.74 0.757];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F4=figure(4);
rlocus(GH) 
grid;

F5=figure(5);
KD=12.3;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%MP no se cumple por cero doble del PID
%TS no se cumple por PD=-0.29
%-4+-j4 no son polos dominantes, estan aproximadamente en -0.29

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
P = [-6 -6]                     %polos a lazo cerrado
K = acker(A,B,P)                 %Calculo la matrix K
An=A-B*K;            
PLC_d=eig(An)                   %Posicion de los polos a lazo cerrado de diseño

go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
step(sys)
stepinfo(sys)
grid on;
