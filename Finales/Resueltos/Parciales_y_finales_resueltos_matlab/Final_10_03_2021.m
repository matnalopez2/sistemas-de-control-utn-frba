clear
clc
H=1;

%EXAMEN NO VERIFICADO, INCOMPLETO 2, CORRECTO SOLO 1 y 3

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%Un ferry usa diques flotantes y estabilizadores para amortiguar el efecto
%de las olas que lo golpean. En la figura siguiente, se muestra el control
%de estabilizacion por medio de realimentacion de estados en modo
%regulador. Se pide:
%1) Determine las ganancias K2 y K3 para que las raices esten en -15 y
%-2-2j -2+2j
%2) Calcule la transferencia debida a la perturbacion.
%3) Dibuje el balanceo angular del ferry para una perturbacion de olas
%constante (En forma de escalon unitario) Calcule sobrepaso, tiempo de
%asentamiento. En cuanto mejora este regulador, el efecto perturbador
%angular  donstante de las olas, siendo d(t)=1*u(t)

%Ks averiguadas por despeje
K2=17/60;
K3=0.15;

%Transferencia
num= [0 0 0 120];
den= [1 10+60*K3 16+120*K3+120*K2 120];

G=tf(num,den)
F1=figure(1);
zplane(num,den)

F2=figure(2);
step(G)

%Transferencia de la perturbacion
num2= [0 0 2 16+120*K3];
den2= [1 10+60*K3 16+120*K3+120*K2 120];

G2=tf(num2,den2)
F3=figure(3);
zplane(num2,den2)

F4=figure(4);
step(G2)
stepinfo(G2)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%El siguiente sistema de control con realimentacion no unitaria tiene una
%planta inestable. La transferencia de la misma esta dada por G(s)=1/(s-20)
%Se utiliza un sensor de realimentacion con ganancia H(s)=10. Se desea
%diseñar un controlador serie Gc(s) y un prefiltro G(p) Tal que se cumplan
%los siguientes requisitos de diseño:
% Sobrepaso Mp<5%, Ts_2%<2s, Error verdadero nulo.

%Transferencia
num3= [0 1];
den3= [1 -10];

G3=tf(num3,den3)
F5=figure(5);
zplane(num3,den3)

F6=figure(6);
step(G3)

%Compensador:
%Propongo PID modificado polo doble en cero, cero doble en -0.3
num_c= [1 0.6 0.09];
den_c= [1 0 0];
G_c=tf(num_c,den_c)

%ganancia de realimentacion
H=10;

%Total
G_total=G3*G_c;
GH=G_total*H;

%Root locus para obtener e valor de K
F7=figure(7);
rlocus(GH) 
grid;

%Sistema ya compensado
F8=figure(8);
KD=1.4;
M=feedback(KD*GH,1);
step(M); 
stepinfo(M)
grid;

%El refiltro ni idea, la verdad que este ejercicio es algo que nunca habia
%visto
%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%La red circuital mostrada en la siguiente figura, se utiliza con
%frecuencia como controlador/compensador serie en sistemas de control
%industrial. Se pide: 
%1) Realice un diagrama en bloques/flujo de la red circuital
%2) A partir del inciso anterior, calcule la ganancia de la red circuital.
%Es decir, G(s)=Vo(s)/Vi(s). Que estrucura de controlcompensacion es?
%Realice un diagrama de ubicacion de polos y ceros de la red circuital.
%3) Calcule la sensibilidad de la salida respecto a la variacion de la
%capacidad C en el tiempo, asi tambien como su valor en regimen permanente.

%Despejando, queda la transferencia (s+1/rc)/(s+2/rc), analizando sale que
%-2/rc<-1/rc por lo que es una red de adelanto de fase. La sensibilidad es
%(src)/((src+1)(src+2))