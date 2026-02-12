function g00 = factorEscala(A, B, C, K)
    g00 = 1/(C * inv ( -A + B*K ) * B);
end
