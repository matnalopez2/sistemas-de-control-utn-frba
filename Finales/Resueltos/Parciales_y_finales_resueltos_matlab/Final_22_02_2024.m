clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%Para la siguiente funcion transferencia de una planta quimica inestable a
%lazo abierto, se pide:
%1) Modelo de estados, diagrama en bloques
%2) Realimentando las variables de estado elegidas, se pide ts_2%<2.5seg
%y Mp<5%
%3) Verificacion con matlab

num= [0 0 0 1 1.5];
den= [1 11 4 -60];

G=tf(num,den)
F1=figure(1);
zplane(num,den)

F2=figure(2);
step(G)

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
%Propongo polos en -2-2i -2+2i y el tercero en -10, 5 veces mas alejado que
%los dominantes para evitar interferencia (Mejor respuesta con polos en
%1.6+-j1.6 y el tercero en -8)
P = [-1.6+1.6i -1.6-1.6i -8] %polos a lazo cerrado
K = acker(A,B,P) %Calculo la matrix K
An=A-B*K            
PLC_d=eig(An) %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo, (ganancia 1)
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F3=figure(3);
step(sys)
stepinfo(sys)
grid on;

%No cumple Mp por ubicacion de los polos del compensador con respecto a la
%ubicacion de los polos dominantes (creo)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%En la figura, se observa el modelo Maxwell-Voigt de una pared
%arterial.etc. Se pide:
%1) Calcular la ganancia del sistema
%2) Verificar lo anterior con diagrama en bloques
%3) Modelo de estados del sistema y diagrama en bloques, verificando la
%transferencia obtenida
%4) Diagrama de Bode, tipo de respuesta?

%Pongo datos para probar nada mas, no los da el enunciado
k1=1;
k2=1;
b=1;

num2= [b k2];
den2= [k1*b+k2*b k1*k2];

G2=tf(num2,den2)
F3=figure(3);
zplane(num2,den2)

F4=figure(4);
bode(G2)
%HAciendo el bode, se obtiene una red de retardo de fase (Un polo y un
%cero)

%Para la parte de variables de estados, quedan en funcion de la entrada, no
%se puede con variabes de estado naurales, se tiene que hacer con canonica
%controlable
%Voy a la forma (b1*s+b0)/(s+a0) y de ahi resuelvo por diagrama, quedando=
%(b1+b0/s)/(1+a0/s) y reemplazo

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Verdadero o falso
%1) Cualquier sistema realimentado negativamente tiene error vardadero nulo
%ante una entrada delta de dirac
%2) Un sistema rotacional compuesto por 2 momentos de inercia J1 y J2
%acoplados con un tren de engranajes tiene 2 variables de estado
%3) En una realimentacion completa de un vector de estados la matriz de
%controlabilidad debe tener un rango igual a la cantidad de estados de la
%planta y la señal de control u(t) estra restringida en su magnitud.
%4) Una red de adelanto de fase con transferencia D(s)=(s+zc)/(s+pc) es tal
%que zc > pc

%1) Falso, no necesariamente es cero
%2) Falso, es una sola variable de estado
%3) Verdadero,la matriz de controlabilidad debe tener un rango igual al 
%número de estados de la planta, lo que garantiza que cada estado sea 
%controlable
%4) Falso, es zc<zp

%%%%%%%%% Ejercicio 4 %%%%%%%%%%%
%Para el diagrama en bloques del sistema de control con realimentacion
%multiple, siendo G=K/(s*(s+2)) se pide:
%1) Mediante el criterio de Routh-Hurwitz, determine el rango de valores de
%K que permiten la estabilidad absoluta del sistema
%2) Verifique con Nyquist