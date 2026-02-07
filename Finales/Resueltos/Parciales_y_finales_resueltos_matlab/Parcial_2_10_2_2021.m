clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%la siguiente figura representa el diagrama en bloques de un sistema de
%control mediante realimentacion de estados. las ganancias de
%realimentacion de estado k1, k2, k3 son costantes reales. Se pide:    
%1) Los valores de ganancias de realimentacion tal que, error en estado
%poermanente sea cero, y los polos en s1: -1+j s2: -1-j y s3: -10.
%Verificar el diseño - Matlab y Simulink
%2) Ahora, en vez de una realimentacion de estados, implementar un
%controlador serie, tal que se cumplan los requisitos del enunciado
%anterior.

%Valor de constantes obtenidas manualmente despejadas de la formula de
%error de actuacion e igualando a los polos
K=[11 8 20]

%Matrices de estado
A=[-1 1 0;-K(1) -(3+K(2)) K(3);-1 0 0]; 
B=[0 0 1]';
C=[1 0 0];
D=[0];

SS=ss(A,B,C,D);

Au=eig(A) %Polos a lazo cerrado segun el enunciado

%Grafico la respuesta al escalon del sistema con las K averiguadas
F1=figure(1);
set(F1,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'Respuesta al escalon con realimentacion');
step(SS);
grid

%Diseño clasico para los valores pedidos en el enunciado
%Calculo ganancia
G=tf(1,conv([1 3],[1 1])); %Ganancia planta
H=1;

%Compensador
Gc=tf([1 4/3],[1 0])
[Num_Gc,Den_Gc]=tfdata(Gc,'v');

%Todas las ganancias en una, tomando la realimentacion y el compensador
GcGH=Gc*G*H;

F2=figure(2);
set(F2,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'Lugar de raices');
rlocus(GcGH)
grid

KP=3 %Constante proporcional por Rlocus
KI = Num_Gc(2)*KP %Constante integral
Gc=KP*Gc %Transferencia del controlador

F3=figure(3);
set(F3,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'Respuesta al escalon, usando controlador clasico');
M=feedback(Gc*G,1)
step(M)
grid

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%La siguiente figura, muestra el diagrama en bloques de un sistema de
%control de un motor de CC con realimentacion por tacometro. Encuentre los
%valores de diseño K y Kt de tal manera de obtener:
%Kv=1, polos dominantes a sqrt(2)/2 
%Verificar con atlab - Simulink

%Calculo la transferencia
G=tf(10,poly([0 -1 -10]));

%Valores obtenidos analiticamente
%Hay que usar solamente la G1, sin tomar el primer K y ese usarlo solamente
%para calcular el Kv despues. Con eso despejo que K=Kt+1
%Luego, usando el denominador (Numerador de F(s)) se obtiene que :
%s³+11s²+10k(s+1)=0, de esto despejo y obtengo la formula para usar Rlocus
%y de ahi obtengo del grafico:
K=2.22;
Kt=K-1;

%Calculo la ganancia
G1=feedback(G,Kt*tf([1 0],1));
H=1;
F4=figure(4);
set(F4,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'LR de P(s)');
P=tf(10*[1 1],[1 11 0 0]);
rlocus(P);
grid

%Calculo la ganancia la lazo cerrada con el controlador
M=feedback(K*G1,H)
[N_M,D_M]=tfdata(M,'v');

%Polos finales
P_LC=roots(D_M)

%Respuesta al escalon
F5=figure(5);
set(F5,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'Respuesta al escalon');
step(M)
grid

%Respuesta a la rampa
F6=figure(6);
set(F6,'position',[100 20 900 650],'Menubar','none','NumberTitle','off','name', 'Respuesta a la rampa');
[y,t]=step(M*tf(1,[1 0]),6);
plot(t,t,'b',t,y,'r')
xlabel('t (sec)')
grid

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Dado el siguiente sistema físico compuesto por una masa M y un resorte de 
%constante elástica k, sometido a la acción de una fuerza vertical, 
%y, considerando que el sistema se encontraba en equilibrio dinámico al
%momento de aplicar la fuerza (una deformación inicial del resorte 
%compensó la fuerza peso de la masa), se pide:
%1) Matrices de estado
%2) Controlador Mp<10% y Ts_2%<2s, posicion permanente en x(inf)=40cm
%3) Verificacion, diagrama en bloques

%Valores de las constantes dados en el enunciado
M=10;
K=4;

%Planta, obtengo, o saco las matrices algebraicamente 
num_1= [1]           
den_1= [M 0 K]
G=tf(num_1,den_1) 

%Obtengo modelo de estados (OBTENGO ESPEJADAS) debo acomodarlas
[A B C D]=tf2ss(num_1,den_1);
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
%P = [-3.3898+4.63i -3.3898-4.63i] %polos a lazo cerrado
P = [-4+4i -4-4i] %polos a lazo cerrado
K = place(A,B,P) %Calculo la matrix K
An=A-B*K            
%C = [1 0  ; 0 1 ]; %Matriz para las posiciones iniciales
PLC_d=eig(An) %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=0.4/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F7=figure(7);
step(sys)
stepinfo(sys)
grid on;