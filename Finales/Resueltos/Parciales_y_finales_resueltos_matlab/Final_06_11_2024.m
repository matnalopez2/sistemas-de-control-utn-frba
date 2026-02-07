clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%La figura que muestra a continuacion, esquematiza un control de posicion a
%lazo abierto de una masa M, Que se desplaza por una superficie viscoza
%bm, mediante la aplicacion de una fuerza F(t) y un par de resortes
%longitudinales de constantes elasticas k1 y k2 respectivamente. Se pide: 
%1) Ganancia de la planta X2(s)/F(s) 
%2) Verificar la transferencia anterior con Mason

m=1;
k1=8;
k2=8;
b=5;

%hay que recordar que pide X2 y no X1, la respuesta es una transferencia de
%respuesta pasabajos.

%Transferencia
num= [0 0 k2];
den= [m*k2+m*k1 b*k2+b*k1 k1*k2];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
step(G)
stepinfo(G)
grid;


%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Mediante un sensor de posicion a fuerza con transferencia unitaria, se
%realimenta la posicion xm a la entrada de la planta con el objetivo de
%controlarla a lazo cerrado, y en consecuencia, de una forma mas precisa.
%Se pide:
%1) Diseñe un controlador, para que el sistema tenga error nulo al escalon,
%ts_2%<1s Mp<5% 
%2) Calcule la ganancia a lazo cerrado y verifique si el sistema cumple
%todos los requisitos de diseño solicitados. En caso de que no, indique
%porque

%Compensador:
%Propongo PID polo en cero, cero en -1 y por despeje, cero en -8
num2= [1 9 8];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

%Root locus para obtener e valor de K
F3=figure(3);
rlocus(GH) 
grid;

%Sistema ya compensado
F4=figure(4);
KD=8;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%Se cumple el ts_2%, pero no el Mp, debido a la influencia del cero en -8

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%En esta ocacion, se pretende controlar la planta del sistema de
%posicionamiento mediante una realimentacion del vector de estados. En
%consecuencia, se pide:
%1) Encuentre el modelo de estados de la planta , realice un diagrama en
%bloques
%2) Realice una realimentacion completa del vector de estados, para los
%mismos requerimientos del ejercicio anterior.
%3) Verifique si se cumplen todos los requisitos de diseño, indique cual o
%cuales son los causantes del no cumplimiento. Realice ademas un diagrama
%en bloques del sistema controlado por realimentacion del vector de estados

%Realimentacion del vector de estados
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


%Realimentacion del vector de estados
P = [-4-4i -4+4i]                     %polos a lazo cerrado
K = acker(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F5=figure(5);
step(sys);
stepinfo(sys)
grid on;

%En este caso, podemos ver como al haber desaparecido el cero en -8,
%tambien se va su influencia, por lo cual, pudo cumplirse el Mp pedido