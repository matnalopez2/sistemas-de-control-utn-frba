clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%El diagrama en bloques siguiente, corresponde a un control de posición de 
%un motor de CC, con realimentación de corriente y tensión de armadura. 
%Considerando genéricas las ganancias de realimentación de corriente y 
%tensión H௜(s) y H௘(s) respectivamente, se pide calcular:
%1) Transferencias con respecto a la tension y perturbacion
%2) Considerando que se cumple.... demuestre que... se anula completamente
%el efecto de la entrada de cupla de perturbacion
%3) Teniendo en cuenta el resultado anterior, calcule nuevamente la
%transferencia.
%4) Condiciones de estabilidad

%No hay mucho secreto, resolver algebraicamentey reemplazar. en "2" se
%anula todo y condiciones de estabilidad son Mf y Mg mayores a cero.

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Dado el siguiente sistema de control de posición angular con 
%realimentación múltiple, Se pide:
%1) Calcule la transferencia del ángulo respecto al ángulo de referencia, 
%es decir Θ(s)⁄R(s), así también como el rango de valor de Kv que asegura
%la estabilidad del sistema. Se sugiere utilizar el criterio de 
%estabilidad de Ruth–Hurwitz.
%2) Realice un lugar de raíces del movimiento de polos a lazo cerrado del 
%sistema, corroborando los valores de Kv obtenidos en el inciso anterior.
%3) Para el valor de Kv = 2, calcule el sobrepaso Mp así también como el 
%tiempo de establecimiento ts al 2% del ángulo de salida, ante una entrada 
%en forma de escalón unitario.

%Basicamente usar el criterio pedido, queda algo asi

%   s³ 1 10+kv*100
%   s² 11 1000
%   s¹ (1000-11(10+Kv*100))/11
%Este ultimo debe ser mayor a cero, para que no haya cambios de signo en la
%primera columna y asi ser estable siempre
%por despeje da K>0.8

Kv=0.81; %Con este valor, debe verse criticamente amortiguado

%Transferencia
num= [0 0 0 1000];
den= [1 11 10+Kv*100 1000];

G=tf(num,den)
F1=figure(1);
zplane(num,den)

F2=figure(2);
step(G)

%Total
GH=G*H;

%Root locus para obtener el valor de K
%Tengo que modificar la formula, no puedo tirarla asi nomas al rootlocus
%Queda s³+11s²+10s+1000*(1+(Kv*100s)/(s³+11s²+10s+1000)) Y uso lo de
%adentro del parentesis
num= [0 0 100 0];
den= [1 11 10 1000];
G=tf(num,den)
GH=G*H;
F3=figure(3);
rlocus(GH) 
grid;

%Ahora para Kv=2
Kv=2;

%Transferencia
num= [0 0 0 1000];
den= [1 11 10+Kv*100 1000];

G=tf(num,den)
F4=figure(4);
zplane(num,den)

F5=figure(5);
step(G)
stepinfo(G)

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Dado el siguiente sistema físico compuesto por una masa M y un resorte de 
%constante elástica k, sometido a la acción de una fuerza vertical, y, 
%considerando que el sistema se encontraba en equilibrio dinámico al 
%momento de aplicar la fuerza (una deformación inicial del resorte 
%compensó la fuerza peso de la masa), se pide:
%1) Modelo de estados, estable?
%2) Controlador mediante realimentacion del vector de estados, para Mp<10%
%Ts_2%<2s Xfinal=40cm M=10kg K=4N/m
%3) Diagrama en bloques y verificacion

M=10;
K=4;

%Transferencia, usando posicion y fuerza, no velocidad
num= [0 0 1];
den= [M 0 K];

G=tf(num,den)
F6=figure(6);
bode(G)

%Puede observarse que es un oscilador
F7=figure(7);
M=feedback(G,1);
step(M)
stepinfo(M)
grid;

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


%Estimador
P = [-2-2.72i -2+2.72i]                     %polos a lazo cerrado
K = place(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=0.4/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F8=figure(8);
step(sys);
stepinfo(sys)
grid on;


