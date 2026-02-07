clear
clc
H=1;

%%%%%%%%% Ejercicio 1 %%%%%%%%%%%
%La siguiente figura visualiza un filtro activo de segundo orden, se pide:
%1) Encuentre el modelo de estados del filtro activo, es decir las matrices
%A B C D respectivamente.
%2) Mediante un diagrama de flujo de estados y Mason, verifique que la
%ganancia de filtro esta dada por:
%G(s)=Vo(s)/Vi(s)=((G1+G2)G4*G6a)/((s²C3*C5*G1+G2*G4*(G6a+G6b))
%Tenidendo en cuenta que R1=R2=R6a=R6b=1K, R4=2K y C3=C5=10uF, realice un
%grafico de Bode del filtro asitambien su respuesta a un escalon unitario.
%Es estable este filtro? Calcule los valores mas representativos de la
%señal de salida obtenida frente al escalon unitario de tension de entrada.

%quedan las matrices de estados:

%entrada tensiones en los capacitores
%A = [0, G2(G6a+G6b)/(C5*G1) ; -G4/C3, 0]
%B = [G6a/C5; 0]
%C = [0, -(1+G2/G1)]
%D = [0]

R1=1000;
R2=1000;
R6a=1000;
R6b=1000;
R4=1000;
R4=2000;
C3=10e-6;
C5=10e-6;

G1=1/R1;
G2=1/R2;
G4=1/R4;
G6a=1/R6a;
G6b=1/R6b;

%Transferencia
num= [0 0 (G1+G2)*G4*G6a];
den= [C3*C5*G1 0 G2*G4*(G6a+G6b)];

G=tf(num,den)
F1=figure(1);
bode(G)

F2=figure(2);
step(G)
stepinfo(G)
grid;

%%%%%%%%% Ejercicio 2 %%%%%%%%%%%
%Teniendo en cuenta que se puede acceder a las diferencias de potencial de
%los capacitores del circuito, se pide:
%1) Realice una realimentacion completa del vector de estados, de tal
%manera de cumplir un seguimiento perfecto a un escalon unitario de tension
%de entrada del circuito y una frecuencia angular de corte de 3db de
%wc=100rad/seg.
%2) Calcule la nueva ganancia del filtro controlado, es decir
%M(s)=Vo(s)/Vi(s). Se recomienda de sobremanera el uso de lso comandos
%ss2tf y tf de Matlab para el calculo de la transferencia controlada.
%3) Realice un diagrama de Bode del sistema controlado verificando que se
%cumpla las condiciones de diseño con la realimentacion completa del vector
%de estados.
%4) Realice un diagrama de Simulink del sistema original y de
%realimentacion con el vector de estados, graficando de manera conjunta su
%respuesta al escalon unitario.


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


%Realimentacion del vector de estados
%Coloco el primer polo a -100 por el enunciado, debo solamente poner uno,
%ya que al colocar uno doble, este bajaria -6db/dec, y pide solo 3db/dec,
%el segundo polo lo pongo 5 veces mas alejado, para no interferir con el
%dominante.
P = [-100 -500]                     %polos a lazo cerrado
K = acker(A,B,P)                            %Calculo la matrix K
An=A-B*K                                    %Vector de realimentacion de estados
PLC_d=eig(An)                               %Posicion de los polos a lazo cerrado de diseño

%Ahora, para seguir el escalon con error nulo
go=1/(C*inv(-A+B*K)*B)

%Sistema ya compensado
sys=ss(An,B*go,C,D);
%[NGN,DGN]=ss(An,D,C,D); %Esto no anda, no se porque
%obtengo la ganancia compensada
G2=tf(sys)

F3=figure(3);
step(sys);
stepinfo(sys)
grid on;

%%%%%%%%% Ejercicio 3 %%%%%%%%%%%
%Analice la veracidad o falsedad de las siguientes sentencias,
%justificando brevemente sus resultados
%1) Cualquier sistema con realimentacion unitaria negativa tiene un error
%verdadero nulo ante una entrada de delta de Dirac.
%2) Un tren de engranajes con relacion de dientes n=N1/N2 con N1<N2, hace
%que la cupla T2(t) sea menor que la cupla T1(t).
%3) Si los acumuladores de energia definen la cantidad de variables de
%estado de un sistema fisico, entonces un sistema rotacional compuesto por
%2 momentos de inercia J1 y J2, acoplados con un tren de engranajes de
%relacion n=N1/N2 tiene 2 variables de estado.
%4) Un PID clasico produce en una planta realimentada unitariamente, que la
%señal de error en regimen permanente sea nula ante una entrada de escalon 
%unitario
%5) Una red de adelanto con transferencia D(s)=k*(s+zc)/(s+pc) es tal que 
%|zc|>|pc|

%1) Falso, un sistema con realimentación unitaria negativa no garantiza un 
%error nulo y absoluto ante una entrada de delta de Dirac, el error en 
%estado estacionario dependerá del tipo de sistema de control y de las 
%características de su función de transferencia en lazo abierto, y no solo 
%de la realimentación unitaria negativa. 
%2) Falso, disminuye la velocidad, pero aumenta la cupla.
%3) Falso, eso se modeliza con dos capacitores, luego a traves del
%transformador se refleja y se reemplaza por un equivalente reflejado al
%primario o secundario, es decir, una sola variable de estado.
%4) Verdadero, un controlador PID clásico, al ser realimentado 
%unitariamente, logra un error nulo en régimen permanente (estado 
%estacionario) para una entrada de escalón unitario debido a la acción 
%integral
%5) Falso, eso es para una red de atraso.
