clear
clc
H=1

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%Se muestra un sistema de control de posicion de masas en una herramienta.
%La masa Ml se mueve en .... Se pide calcular:
%1) Diagrama en bloques del sistema
%2) Demostrar que el sistema tiene un diseño muy pobre, (Tiempo de
%asentamiento cercano a los 40s y sobrepaso de casi 90%)

%Queda una fuente de corriente, capacitor paralelo (Jm) Resistencia
%paralelo (1/Bm), Capacitor paralelo (J), transformador relacion 1:r
%capacitor paralelo (Ml) inductor paralelo (1/kl) resistencia paralelo
%(1/Bl)
%transferencia queda: 
%[(A*kt*r)/(La*Jeq)]/[s³+s²(La*Beq+Ra*Jeq)/(La*Jeq)+s(La*Keq+Ra*Beq+kb*kt)/(La*Jeq)+(Ra*Keq+A*kt*kp*r)/(La*Jeq)] 

%Transferencia
num= [0 0 0 40000];
den= [1 10000 2004 80000];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
M=feedback(G,1);
step(M)
stepinfo(M)
grid;

F3=figure(3);
zplane(num,den)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Se desea diseñar un controlador para este sistema de posicion de masas en
%una herramienta de forma tal que se cumplan los siguientes requisitos:
% Sobrepaso menor al 20%
% Respuesta al escalon con error verdadero nulo
% Tiempo de asentamiento Ts_2%<1.5 seg
% Luego, verificar - Simulink

%usando conceptos de polos dominantes, el de -10k no afecta, puede
%descartarse, lo extraigo (divido numerador por el polo y lo cancelo) 
%y elimino, quedando la siguiente transferencia:
num= [0 0 0 4];
den= [1 0.25 4.01];

G=tf(num,den)

%Compensador:
%Propongo PID polo en cero, cero doble en -2.1
num2= [1 4.2 4.41];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F4=figure(4);
rlocus(GH) 
grid;

F5=figure(5);
KD=2.26;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%No cumple el Ts debido el polo real a lazo cerrado

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Se desconecta la realimentacion de posicion de la masa M a la entrada
%(Manteniendo la ganancia del amplificador) con el objetivo de realizar una
%realimentacion del vector de estados de la planta, se pide:
%1) Teniendo en cuenta que se tiene: Posicion de la masa, Velocidad angular
%del motor, corriente de armadura del motor, encontrar un modelo de
%estados.
%2) Realimentar las variables de estado para los requisitos del ejercicio
%anterior 
%3) Si solo se tiene acceso a la señal de control de planta y posicion de
%masa, realizar un estimador de estado completo- Simulink

%matrices de estado
%entrada x1=ia, x2= wm, x3= vm
%A = [-ra/la, -kb/la, 0 ; kt/jeq, -beq/jeq, -keq/jeq ; 0, r, 0]
%B = [a/la; 0 ; 0]
%C = [0, 0, 1]
%D = [0]

A = [-10000, -400, 0 ; 4, 0.04, -40 ; 0, 0.1, 0]
B = [100000 ; 0 ; 0]
C = [0, 0, 1]
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

%Estimador
%elijo tercer polo en -20
P = [-4+4i -4-4i -20]              %polos a lazo cerrado
K = acker(A,B,P)                 %Calculo la matrix K
An=A-B*K;            
PLC_d=eig(An)                   %Posicion de los polos a lazo cerrado de diseño

go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F6=figure(6);
step(sys)
stepinfo(sys)
grid on;
