%{
Ejercicio 12a
Respuesta al escalón del sistema:
G(s) = (9 - 3s)/((s+1)(s+7))
%}


% Defino la variable s para funciones transferencia
s = tf('s');

% Defino la función transferencia
G = (9 - 3*s) / ( (s+1) * (s+7) );

% Función para chequear polos
polos = pole(G);

% Función para chequear ceros
ceros = zero(G);

% Imprimo resultados por pantalla
fprintf('Los polos del sistema son: ');
fprintf('%g ', polos);
fprintf('\n');

fprintf('Los ceros del sistema son: ');
fprintf('%g ', ceros);
fprintf('\n');

% Vamos a evaluar la respuesta al escalón
figure
step(G)
grid on
title('Respuesta al escalón unitario')

%figure
%pzmap(G)
%grid on
%title('Diagrama de polos y ceros - pzmap')

%figure
%pzplot(G)
%grid on
%title('Diagrama de polos y ceros - pzplot')