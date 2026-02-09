%Obtengo modelo de estados (OBTENGO ESPEJADAS) debo acomodarlas

function [A, B, C, D] = tf2ss_mati(num,den)
    [A B C D]=tf2ss(num,den);
    A=flipud(A);
    A=fliplr(A) %Matriz final A
    
    B=flipud(B);
    B=fliplr(B) %Matriz final B
    
    C=flipud(C);
    C=fliplr(C) %Matriz final C
    
    D=flipud(D);
    D=fliplr(D) %Matriz final D
end