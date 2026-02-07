clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%La siguiente figura esquematiza un amortiguador de vibraciones dinamico.
%Este sistema es el representaivode muchas situaciones que entrañan
%vibraciones de maquinas que contienen componentes desequilibrados. La masa
%M2 y el resorte K2 pueden elegirse de forma tal que la masa M1 no vibre en
%estado estacionario cuando es sometida a una fuerza oscilante
%f(t)=a*sin(wo*t). El sistema comienza en el equilibrio estatico (todas las
%fuerzas peso estan compensadas por deformaciones iniciales de resotes y
%amortiguadores) Se pide:
%1) Encuentre la ganancia del sistema G(s)=Y1(s)/F(s)
%2) Encuentre el modelo de estados de la planta. considerando como entrada
%la fuerza aplicada f(t) y salida la posicion de la masa M1.
%3) Mediente un diagrama de flujo de estados y ganancia de mason, verifique
%la transferencia obtenida en A
%4) Determine la relacion entre la frecuencia angular de vibracion de la
%fuerza f(t)=a*sin(wo*t), la masa M2 y el resorte K2 para conseguir que la
%masa M1 no presente ningun tipo de vibraciones en regimen permanente ante
%una fuerza vibrante f(t)=a*sin(wo*t)

%Transferencia queda fuente de corriente, capacitor paralelo (M1) inductor
%paralelo (1/K1) Resistencia paralelo (1/B), inductor serie (1/K2)
%capacitor paralelo (M2), quedando la transferencia:
%Y1(s)/F(s)=(s²*M2+K2)/(s⁴M1*M2+s³*B*M2+s²(M1*K2+M2*K1+M2*K2)+s*B*k2+K1*K2)

%Modelo de estados uso el canonico directamente o el natural, es lo mismo,
%quedando (Con el natural):

%matrices de estado
%Entrada x1=v1, x2= fki, x3=fk2 x4=v2
%A = [-b1/m1, -1/m1, -1/m1, 0; k1, 0, 0, 0; k2, 0, 0, -k2; 0, 0, 1/m2, 0]
%B = [1/m1 ; 0 ; 0 ; 0]
%C = [0, 1/k1, 0, 0]
%D = [0]
 
%El resto, es algebra.
%Para el ultimo punto: El sistema tiene un cero en s=+-j*sqrt(k2/m2), Si se
%tiene f(t)=a*sin(wo*t), con wo=sqrt(k2/m2), luego del transitorio,
%y1=0->y1=CTE (no vibra)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Con el objetivo de reducir rapidamente el transitorio de las vibraciones,
%se va a diseñar un sistema de control con un sensor de realimentacion
%unitaria H(s)=1
%1) Diseñe un controlador para Error de actuacion nulo al escalon, Mp<10%,
%Ts_2%<4s 
%2) Verificacion con simulink

M1=100;
M2=517;
K1=938;
K2=4410;
B=1500;

%G(s)=(s²*M2+K2)/(s⁴M1*M2+s³*B*M2+s²(M1*K2+M2*K1+M2*K2)+s*B*k2+K1*K2)
%Reemplazando:

num= [0 0 0.01 0 0.0853];
den= [1 15 62 128 80];

G=tf(num,den)
F1=figure(1);
zplane(num,den)

%Compensador:
%Propongo PID polo en cero, cero en -1 y cero en -10
num2= [1 11 10];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F2=figure(2);
rlocus(GH) 
grid;

F3=figure(3);
KD=60;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%Cumple con lo pedido

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Se desea realizar una realimentacion de estados para controlar la posicion
%de la masa M1 en este sistema de control de vibraciones. Sin embargo, no
%se tiene acceso a la medicion de todos los estados, solamente se puede
%medir la posicion de la masa M1 y la fuerza de control u(t) de la planta.
%1) Diseñe un control por estimacion del vector de estados, tal que se
%cumplan todos los requisitos de diseño del caso anterior.
%2) Verifique el diseño mediante simulink

A = [-B/M1, -1/M1, -1/M1, 0; K1, 0, 0, 0; K2, 0, 0, -K2; 0, 0, 1/M2, 0]
B = [1/M1 ; 0 ; 0 ; 0]
C = [0, 1/K1, 0, 0]
D = [0]

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


%compensador, usando acker, polos a lazo cerrado
%Segun el enunciado deberian ser en -1.5+-i
%Puede ser que sea un error de pessana ponerlos en el resuelto asi.
P = [-1.5+1.5i -1.5-1.5i -7 -7] 
K = acker(A,B,P)                 
An=A-B*K;            
PLC_d=eig(An)                  
go=1/(C*inv(-A+B*K)*B)

%estimador
Pest = [-5 -5 -5 -5]                     
Kest = acker(A',C',Pest)' 

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F4=figure(4);
step(sys)
stepinfo(sys)
grid on;
