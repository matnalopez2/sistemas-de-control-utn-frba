clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%La trasferencia a lazo cerrado M(s) = (sK+b)/(s²+sa+b) corresponde a un 
%sistema de control con realimentación unitaria (seguidor). Se pide:
%a) Calcule la ganancia de la planta G(s) que dio origen a la 
%ganancia a lazo cerrado. Calcule, además, los errores de actuación 
%permanente a la posición y a la velocidad.
%b) Demuestre que si a, b > 0, el sistema es siempre absolutamente estable.
%c) Verifique cualitativamente la estabilidad absoluta de este sistema de 
%control con a, b > 0, empleando gráficos polares de Nyquist.

%Despejar G(s) y reemplazar en la formula la M(s) dada. Queda
%G(s)=(sK+b)/(s*(s+(a-K))
%eass=1/kp con kp=lim s->0 g(s)
%eass=1/kv con kv=lim s->0 g(s)*s
%Estabilidad:
%  s² 1 b
%  s¹ a 0
%  s⁰ b
%Por la primera columna se observa que es siempre estable para a,b>0

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%En el sistema de la figura, una fuerza f(t) produce el movimiento del 
%amortiguador de constante viscosa b que, asimismo, mueve a la varilla de 
%longitud L un pequeño ángulo θ(t) y al resorte de constante k. Se pide:
%1) Transferencia del sistema fisico θ(s)⁄X(s), que filtrado realiza el
%sistema?
%2) Modelo de estados
%3) Mason para verificacion del modelo de estados

%Queda en la modelizacion una resistencia serie, transformador (L/1)
%capacitor paralelo, resistencia paralelo, transformador (1/L) bobina
%paralelo
%Transferencia: sb/(s²jeq+s(beq+b)+keq) Pasabanda 2° orden

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Se pretende controlar el siguiente sistema de posicion (inicialmente
%inestable) con realimentacion unitaria de posicion y realimentacion de
%velocidad (Mediante un sensor de primer orden). Se pide:
%1) Encuentre los valores de las constantes K1 y K2 de forma que, el
%sistema a lazo cerrado ante una entrada de escalon unitario de posicion
%presente un sobrepaso maximo de Mp=4.32% y un Ts_2s=4s y un polo no
%dominante 7 veces mas a la izquierda de los dominantes. 
%2) Calcular el error verdadero a la velocidad con los valores obtenidos en
%el inciso anterior
%3) Verificar si se cumple todo lo pedido y en caso de que no, explicar
%porque

%Valores obtenidos por despeje:
k1=1.4;
k2=24.6;

%Transferencia
num= [0 0 k1 k1*10];
den= [1 9 k2+k1-10 10*k1];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
step(G)
stepinfo(G)
grid;

F3=figure(3);
zplane(num,den)

%No cumple, apesar de que el polo esta a 7 veces la distancia de los polos
%dominantes, este presenta un residuo de influencia, que afecta. Por otro
%lado, la aproximacion para el tiempo de asentamiento, es justamente una
%aproximacion, no una formula 100% exacta.

%Error verdadero a la velocidad, tomar R=1/s² y calcular lim s->0 s*Ev(s)
%Resultado 14.6/14 = 1.043

