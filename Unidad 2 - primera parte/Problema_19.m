clear;
clc;

%% Definiciones iniciales
syms s m1 b1 J2 b2 J3 b3 JL bL k eta1 eta2 r tita2 tita3 titaL z

Z_b1 = 1/b1;            Y_b1 = 1 / Z_b1;
Z_m1 = 1 / (s*m1);      Y_m1 = 1 / Z_m1;

Z_J2 = 1/(J2*s);        
Z_b2 = 1/b2;

Z_J3 = 1/(J3*s);
Z_b3 = 1/b3;

Z_k = s / k;
Z_JL = 1 / (s*JL);
Z_bL = 1/bL;

%eta1 = r;
%eta2 = N2 / N3;
eta = eta1 * eta2;

%% Reflejando al primario desde los secundarios

% Reflejando de tita2 a z
Z_J2_final = Z_J2 / eta1^2;     Y_J2_final = 1 / Z_J2_final;
Z_b2_final = Z_b2 / eta1^2;     Y_b2_final = 1 / Z_b2_final;

% Reflejando de tita3 a z
Z_J3_final = Z_J3 / eta^2;      Y_J3_final = 1 / Z_J3_final;
Z_b3_final = Z_b3 / eta^2;      Y_b3_final = 1 / Z_b3_final;
Z_k_final  = Z_k  / eta^2;      Y_k_final = 1 / Z_k_final;
Z_JL_final = Z_JL / eta^2;      Y_JL_final = 1 / Z_JL_final;
Z_bL_final = Z_bL / eta^2;      Y_bL_final = 1 / Z_bL_final;


%% Resolviendo

Y_1 = Z_JL_final + Z_bL_final;
Z_1 = 1 / Y_1;
Z_2 = Z_1 + Z_k_final;
Y_2 = 1 / Z_2;

%disp('Z1:'); pretty(Z_1)
%disp('Z2:'); pretty(Z_2)

Y_total = Y_b1 + Y_m1 + Y_J2_final + Y_b2_final + Y_J3_final + Y_b3_final + Y_2;
%disp('pretty');     pretty(Y_total)
%disp('simplify');   simplify(Y_total)
%disp('collect Y_total');    collect(Y_total)
%disp('numden');     numden(Y_total)

Z_total = 1 / Y_total;
%disp('collect Z_total');    collect(Z_total)

%disp('pretty');     pretty(Z_total)
% Fracción prolija
Zs = simplify(Z_total, 'Steps', 80);
[num, den] = numden(Zs);
num = factor(collect(expand(num), s));
den = factor(collect(expand(den), s));

disp('Z_total(s) = num/den:')
disp(num);
disp(den);