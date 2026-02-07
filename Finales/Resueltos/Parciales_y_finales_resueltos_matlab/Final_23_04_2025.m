clear
clc
H=1

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%Dado el siguiente sistema físico compuesto por una masa M y un resorte de 
%constante elástica k,sometido a la acción de una fuerza vertical 
%(como se indica la figura) y considerando que el sistema se encontraba 
%en equilibrio dinámico al momento de aplicar la fuerza (una deformación 
%inicial del resorte compensó la fuerza peso de la masa), se pide:
%1) Ganancia del sistema
%2) Realimentar unitariamente para error nulo del escalon, Plc=-3.92+-j3.92
%con M=20kg y K=80N/m
%3) Tiempo de asentamiento al 2% y sobrepaso
%4) Margen de fase y ganancia
%5) Compensador con realimentacion completa del vector de estados
%6) Discutir diferencias, pros y cons de los sistemas

M=20;
K=80;

%Transferencia, usando posicion y fuerza, no velocidad
num= [0 0 1];
den= [M 0 K];

G=tf(num,den)
F1=figure(1);
bode(G)

%Puede observarse que es un oscilador
F2=figure(2);
M=feedback(G,1);
step(M)
stepinfo(M)
grid;

%Compensador:
%Propongo PID polo en cero, cero doble en -1.96
num2= [1 3.92 3.84];
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
KD=180;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%Margen de fase y ganancia
F5=figure(5);
margin(M)

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
P = [-3.92+3.92i -3.92-3.92i]                     %polos a lazo cerrado
K = place(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F6=figure(6);
step(sys);
stepinfo(sys)
grid on;

%Puede observarse que en el control clasico hay mas sobrepico y menor
%velocidad, debido al doble cero cerca de los polos dominantes. En cambio
%el control moderno es mejor, debido a que no tiene ceros, y tiene solo los
%PLC donde son necesitados para obtener el sistema final

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Dado el siguiente sistema mecánico traslacional que parte del equilibrio 
%(condiciones iniciales nulas), correspondiente al modelo simplificado 
%de un sistema se suspensión de un automóvil (o una moto) y 
%considerando que la deformación inicial de los resortes y el amortiguador 
%compensan los pesos de las masas del chasis m_1 y del sistema de
%suspensión m_2, se pide resolver los siguientes incisos:
%1) Modelizacion y transferencias H1 y H2
%2) Diagrama en bloques del sistema y recalculo de transferencias por Mason

%Despejando quedan:
%num1= [0 0 M2*K1 K1*B K1*K2];
%den1= [M1*M2 B*M1+B*M2 M1*K1+M2*K2+K1*M2 B*K1 K1*K2];

%num2= [0 0 B*K1 K1*K2];
%den2= [M1*M2 B*M1+B*M2 M1*K1+M2*K2+K1*M2 B*K1 K1*K2];

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Conteste verdadero (V) o falso (F) en cada una de las siguientes 
%sentencias, justificando brevemente:
%1) El margen de fase (MF) en un sistema realimentado negativamente, es la 
%cantidad de ángulo necesario para llegar a una fase de –180° de su 
%ganancia a lazo cerrado.
%2) Un PID clásico produce en una planta realimentada unitariamente, que 
%la señal de error en régimen permanente sea nula ante una entrada de 
%escalón unitario.
%3) Una planta controlada a lazo cerrado con polos complejos conjugados 
%dominantes, presentará una dinámica mas lenta que una planta idéntica 
%controlada con polo real doble dominante.
%4) La dinámica de un observador de estados completo X෠(t) es la misma que 
%la dinámica del error cometido en la estimación de estados, es decir, 
%e(t) = X(t) − X෡(t). Entiéndase dinámica como los autovalores de la 
%matriz de estado de ambos sistemas, el observador de estados y el vector 
%de error cometido respectivamente.

%1) Falso, es a lazo abierto
%2) Verdadero, agrega un polo al origen, por ende aumenta el tipo de
%sistema y se obtiene un error nulo a la policion o escalon.
%3) Falso, los sistemas con polos reales e iguales son mas lentos que los
%complejos y conjugados.
%4) Verdadero, porque comparten la matriz A
