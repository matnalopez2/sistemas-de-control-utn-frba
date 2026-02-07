clc
H=1;

%%%%% Ejercicio 1 %%%%
%Se desea realziar el control de temperatura de un horno electrico. La
%planta cuanta con una constante de tiempo muy elevada  T=50 y se desea
%calentar rapidamente a ese horno sin tener en cuenta el elevado consumo de
%energia asociado para lograrlo. Se pide:
%1) Controlador clasico error nulo al escalon, Mp <=5% y un Ts_2% <= 1s.

%transferencia:
num= [0.02];
den= [1 0.02];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
zplane(num,den)

%Compensador:
%Propongo PI, polo en el origen, cero en -4
num2= [1 4.01];
den2= [1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F3=figure(3);
rlocus(GH) 
ylim([-6 6])
grid;
KD=400;

F4=figure(4);
M=feedback(KD*GH,1)
step(M); 
stepinfo(M)
%No puedo cumplir MP por la cercania del cero del controlador a los polos
%a lazo cerrado

%%%%% Ejercicio 2 %%%%
%El siguiente grafico muestra un control de nivel de altura en liquido en
%un tanque, consta de un motor de CC controlado por inducido.
%1) Diagrama en bloques (Demostrar que es inestable)
%2) Establilizar el sistema con Mp<= 5% y Ts_2% <= 5s y en regimen
%permanente H=150m
la=0;
ra=1;
jm=0.9;
bm=6.2;
kt=1;
kb=1;
a=20;
ch=1;
rh=10;
kv=0.1;
kp=10;

%Transferencia
num= [0 0 0 22.22];
den= [1 8.1 0.8 22.22];

G=tf(num,den)
F5=figure(5);
bode(G)
roots(den)

F6=figure(6);
zplane(num,den)

%Compensador:
%Elijo polos en lazo cerrado -1+-J
%Propongo un PID polo en cero, cero en 0.1 y 0.8571
num2= [1 0.975 0.0875];
den2= [0 1 0];
G2=tf(num2,den2)

%Total
GT=G*G2;
GH=GT*H;

F7=figure(7);
rlocus(GH) %averiguo como se mueven los polos
ylim([-6 6])
grid;
KD=0.631;

F8=figure(8);
M2=feedback(KD*GH,1)
step(M2); %Respuesta al escalon, donde se ven los parametros
stepinfo(M2)
%No se cumple MP por la obicacion de los ceros cerca de polos dominantes

F9=figure(9);
margin(M2)

%%%%% Ejercicio 3 %%%%
%1) Desconectando la realimentacion y suponiendo que se puede medir la
%altura del tanque, angulo de rotacion del motor y velocidad angular,
%diseñe un sistema de control mediante realimentacion compoleta del vector
%de estados tal que Mp<=5% Ts_2% <= 5s y Hfinal = 1.50m

%matrices de estado
%entrada x1=wm, x2= phim, x3= H
%A = [-(bm*ra+kb*kb)/(jm*ra), 0, 0 ; 1, 0, 0 ; 0, kv/ch, -1/(ch*rh)]
%B = [a*kt*/(jm*ra) ; 0 ; 0]
%C = [0, 0, 1]
%D = [0]

A = [-8, 0, 0 ; 1, 0, 0 ; 0, 0.1, -0.1]
B = [22.22 ; 0 ; 0]
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
%elijo tercer polo en -10
P = [-1+i -1-i -10]              %polos a lazo cerrado
K = place(A,B,P)                 %Calculo la matrix K
An=A-B*K;            
C = [1 0 0 ; 0 1 0 ; 0 0 1];     %Matriz para las posiciones iniciales
PLC_d=eig(An);                   %Posicion de los polos a lazo cerrado de diseño

X0 = [1 0 0];               
sys = ss(An, [], C, []);    
initial(sys, X0);
grid on;
