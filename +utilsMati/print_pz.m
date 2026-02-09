function print_pz(G)
    p = pole(G);
    z = zero(G);

    fprintf('Polos del sistema: \n');
    disp(p);

    fprintf('Ceros del sistema: \n');
    disp(z)
end