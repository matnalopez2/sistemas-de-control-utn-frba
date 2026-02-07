clear
clc
H=1

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%El siguiente modelo fisico traslacional corresponde a un sistema de
%amortiguacion inteligente.
%1) circuito equivalente electrico
%2) modelo de estados
%3) verificacion que la respuesta al escalon es pobre
m=180;
k1=1000;
k2=1500;
b=625;

%Transferencia
num= [0 0 (k1+k2)/m (k1*k2)/(m*b)];
den= [1 (k1/b) (k1+k2)/m (k1*k2)/(m*b)];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
M=feedback(G,1);
step(M)
stepinfo(M)
grid;

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Con el objetivo de mejorar la pobre respuesta al escalon se va a diseñar
%un sistema de control con un sensor de realimentacion unitaria H=1. se
%pide entonces:
%1) Controlador con Error verdadero nulo al escalon, Mp<=10%, ts_2% <= 2s
%2) Verificar

%transferencia:
num= [0 0 13.89 13.33];
den= [1 1.6 13.89 13.33];

G=tf(num,den)
F1=figure(1);
bode(G)

F3=figure(3);
zplane(num,den)

%Compensador:
%Propongo PID polo en cero, polo en -1 y 1.87
num2= [1 2.87 1.87];
den2= [1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F4=figure(4);
rlocus(GH) 
grid;

F5=figure(5);
KD=0.564;
M=feedback(KD*GH,1);
step(M); 
grid;

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Se desea realizar una estimacion completa del vector de estados para
%controlar la posicion del chasis de la moto
%1) Diseñe sistema de control por estimacion del vector de estados con
%Mp<=10%, Ts_2% <=2s

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
P = [-4+4i -4-4i -0.96]                     %polos a lazo cerrado
K = place(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
%step(sys)
grid on;
