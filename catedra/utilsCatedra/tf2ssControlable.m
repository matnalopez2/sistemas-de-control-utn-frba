function [A, B, C, D] = tf2ssControlable(num, den)
    %TF2SSCONTROLABLE Summary of this function goes here
    % Forma canónica controlable para tf con coef ordenados como MATLAB:
    % num = [b_n ... b_1 b_0]
    % den = [a_n ... a_1 a_0]

    num = num(:).';
    den = den(:).';

    % Normalizar para que a_n = 1
    den = den / den(1);
    num = num / den(1);

    n = length(den) - 1;

    % Invertir orden. Simplifica cuentas [a0...a(n-1)]
    a = den(end:-1:1);
    b = num(end:-1:1);

    % Completar bn
    if length(b) < length(a)
        b = [b, zeros(1, length(a) - length(b))];
    end

    % Matriz A
    A = [zeros(n-1,1) eye(n-1); -a(1:end-1)];

    % Matriz B
    B = zeros(n,1);
    B(end) = 1;

    % Matriz C
    C = b(1:end-1) - b(end) * a(1:end-1);

    % Matriz D
    D = 0;
end
