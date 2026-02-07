clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%El siguiente sistema corresponde a un sistema de equilibrio hidraulico
%dinamico, la masa M1 produce el movimiento de una plataforma de masa
%despreciable, dentro de un tanque con paredes viscosas Bt. Este movimiento
%provoca el desplazamiento del liquido (de densidad p) almacenado en el
%tanque (de area A) y regulado por una resistencia hidraulica Rh. FInalmente,
%un piston de masa despreciable (Con area a) provoca el movimiento de la
%masa M2, la cual esta contenida por un resorte de constante elastica k y
%un amortiguador con velocidad Bm. El sistema parte del reposo, se pide:
%1) Realice un diagrama en bloques (o de flujo), considerando como salida
%la posicion de la masa m2
%2) Verifique que la ganancia del sistema es G(s)=X(s)/Pm1(s) =
%(a/A)/(s²*Mt+s*Bt+Kt) con Mt=M2+a²/A²*M1 Bt=Bm+a²/A²*Bt+a²*Rh Kt=a²/Ch+k y
%Ch=A/(p*g)
%3) Sabiendo que la posicion final de la masa es Xfm2=20cm, encuentre el
%valor de la masa.
%4) Verificacion con Matlab-Simulink

%Por tratarse de un sistema compuesto donde hay liquidos, se usa
%modelizacion serie. Quedando el sistema una fuente de tension valor m*g,
%L serie(m1) transformador de relacion A:1 y resistemacia Bt. Despues del
%transformador un C serie (Ch), R serie (Rh) y transformador de relacion
%1:a despues del transformador R serie (M2) C serie (1/k) y R serie (bm).

%Quedando las formulas:
%F1=(M*G)/s-V1(bt+s*M1)
%p1=F1/A
%p3=p2-RH*Q
%F3=p3*a
%V2=(s*F3)/(s*Bm+k+s²*M2)
%p2=p1-Q/(s*CH)
%X2=V2/s
%Q=a*V2
%V1=Q/A
%Con esto, armar el diagrama de flujo, no olvidar que la entrada tiene que
%estar dividida por s P=(M1*g)/s

M2=50;
RH=3000;
B1=10;
K=25;
Bm=30;
A=1;
a=0.001;
p=920;
g=9.81;
XFM2=0.2;

%obtenido del despeje, para el valor de M1
M1=((a*a*p*g+K*A)*XFM2)/(a*g)
M1=510 %Para valores mas redondos

CH=A/(p*g);
Mt=M2+((a*a)/(A*A))*M1;
Bt=Bm+((a*a)/(A*A))*B1+(a*a)*RH;
Kt=(a*a)/CH+K;

%Transferencia
num= [0 0 (a/A)];
den= [Mt Bt Kt];

G=tf(num,den)
F1=figure(1);
bode(G)

%Tengo que poner M1*g para la entrada al escalon
F2=figure(2);
step(G*M1*g)
stepinfo(G*M1*g)
grid;

F3=figure(3);
zplane(num,den)

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Se pretende controlar el sistema miendiante una realimentacion completa
%del vector de estados. Tenga presente los datos del sistema brindados en
%el inciso c ademas considerar que M1=510kg. Se pide:
%1) Diseñe un controlador por realimentacion del vector de estados de tal
%manera que el sistema llegue a una posicion final de ka nasa m2 de
%XFM=20cm un Mp<10% y T2_2%<2seg.
%2) Verificacion y explique si no se cumple algo porque

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

%Compensador
%Propongo polos en -4-4i -4+4i
P = [-4-4i -4+4i] %polos a lazo cerrado
K = acker(A,B,P) %Calculo la matrix K
An=A-B*K            
PLC_d=eig(An) %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo, (ganancia 1)
go=XFM2/((M1*g*C)*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
F4=figure(4);
step(sys*M1*g)
stepinfo(sys*M1*g)
grid on;

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%En esta ocasion, se pretende controlar la posicion de la masa XM2,
%mediante una estimacion completa del vector de estados (Ya que solamente
%se tiene acceso a la salida del sistema asi tambien como a su señal de
%control) En consecuencia, se pide:
%1) Realice una estimacion y realimentacion completa del vector de estados
%estimados de manera de cumplir los requisitos del diseño anterior.
%2) Verificar con matlab-simulink

%Estimador
P_est = [-8 -8] %polos a lazo cerrado
Ke = acker(A',C',P_est)' %Calculo la matrix K
%X'=A*X^+B*u(t)+Ke(XFM2(t)-C*X^(t)) %Ecuacion del estimador