clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%En el diagrama en bloques de la figura a continuacion, se muestra la
%planta de una turbina de vapor a controlar. La señal de referencia es una
%diferencia de potencial y la señal de salida es la velocidad angular del
%eje de la turbina. Bajo el diagrama en bloques pueden apreciarse las
%ganancias en funcion de la frecuencia angular de los distintos componentes
%de la turbina a vapor, como asi tambien de un sensor de velocidad angular
%a diferencia depotencial.
%1) Calcular la ganancia de la planta sin realimentar. Es estable el
%sistema?

%No olvidar que los valores estan en db, hay que elevarlos a por
%ejemplo=0.1^(10/20) y asi con todos, para obtener las ganancias
%corresondientes.

num1= [0 0.316];
den1= [1 0.1];
G1=tf(num1,den1)

num2= [0 0.0141];
den2= [1 0.01];
G2=tf(num2,den2)

num3= [0 0 5.62];
den3= [1 2.5 1];
G3=tf(num3,den3)

GT=G1*G2*G3

F1=figure(1);
step(GT)
%Estable

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Realice un modelo de estados de la turbina de vapor, calculando las
%matrices A B C D

%Uso modelo canonico
%Obtengo el numerador y denominador de la ganancia total:
[num,den] = tfdata(GT, 'v')

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

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Teniendo en cuenta la transferencia del sensor de velocidad angular
%indicada en la introduccion, diseñe un sistema de control tal que se
%cumplan los requisitos de diseño:
%Error nulo a la aplicacion de un escalon, factor de amortiguamiento de
%0.6, ts_2%<20%

%Por el enunciado, se obtienen polos en 0.2+-j0.27

%Compensador:
%Propongo PID polo en cero, cero en 0.1 y 0.01 para anular los de la planta
num_c= [1 0.11 0.001];
den_c= [0 1 0];
G_c=tf(num_c,den_c)

%Total
G_total=GT*G_c;
GH=G_total*H;

%Root locus para obtener e valor de K
F2=figure(2);
rlocus(GH) 
grid;

%Sistema ya compensado
F3=figure(3);
KD=10.2;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;
%Cumple con lo pedido

%%%%%%%%% Ejercicio 4 %%%%%%%%%%%
%Suponiendo que tiene acceso a todos los estados de la turbina de vapor,
%realice un control de la misma mediante una realimentacion completa del
%vector de estados, de tal manera de cumplir con los mismos requisitos  de
%diseño del ejercicio anterior. Verificar y explicar similitudes o
%diferencias

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


%Polos por el enunciado, y 2 adicionales lejos de los dominantes
P = [-0.2+0.27i -0.2-0.27i -2 -2]       %polos a lazo cerrado
K = acker(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F4=figure(4);
step(sys);
stepinfo(sys)
grid on;

%Respuesta muy parecida al de diseño clasico, solamente un poco mas lento

%%%%%%%%% Ejercicio 5 %%%%%%%%%%%
%En la realidad, no se puede tener acceso a todos los estados de la planta,
%sean logicos o fisicos, teniendo en cuenta que se puede medir solamente la
%velocidad angular del rotor, de la turbina y la señal de referencia de la
%planta, diseñe una realimentacion completa por estimacion de estados, tal
%que se cumplan los requisitos de diseño de los ejercicios 3 y 4.
%Verificar.

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


%Elijo polos del estimador
Pest = [-1 -1 -1 -1]       
K = acker(A,B,Pest)                            %Calculo la matrix K
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