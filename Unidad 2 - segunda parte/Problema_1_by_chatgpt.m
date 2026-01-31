clc; clear;

%% Datos
Ea = 300;       % V
Ra = 1;         % ohm
La = 0.05;      % H
Kt = 1.10;      % Nm/A
Kb = 1.10;

Jm = 0.4;
JL = 0.8;
bm = 0.005;
bL = 0.1;

b = bm + bL;
J = Jm + JL;

%% Planta: w / Ea
s = tf('s');
Gplant = Kt / ((Ra + La*s)*(b + J*s) + Kb*Kt);

%% Valor final para escalón de 300 V
wInf = dcgain(Ea * Gplant);

%% Corriente de armadura en régimen
IaInf = (b / Kt) * wInf;

%% Potencias en régimen
Pin_a = Ea * IaInf;        % potencia eléctrica de entrada
Pcu_a = IaInf^2 * Ra;      % pérdida cobre armadura

PmL = bL * wInf^2;         % potencia en la carga
PmM = bm * wInf^2;         % pérdida mecánica

%% Rendimientos
eta_mec = PmL / (PmL + PmM);
eta_tot = PmL / Pin_a;

%% Resultados
fprintf('\n=== REGIMEN PERMANENTE ===\n');
fprintf('w_inf   = %.2f rad/s\n', wInf);
fprintf('Ia_inf  = %.2f A\n\n', IaInf);

fprintf('Pin_a   = %.1f W  (entrada armadura)\n', Pin_a);
fprintf('Pcu_a   = %.1f W  (pérdida cobre)\n', Pcu_a);
fprintf('PmL     = %.1f W  (potencia en la carga)\n', PmL);
fprintf('PmM     = %.1f W  (pérdida mecánica)\n\n', PmM);

fprintf('eta_mec = %.4f  (reparto mecánico)\n', eta_mec);
fprintf('eta_tot = %.4f  (rendimiento motor)\n', eta_tot);
