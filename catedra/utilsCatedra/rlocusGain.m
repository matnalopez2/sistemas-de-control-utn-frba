function [K_best, pole_best] = rlocusGain(G, p_des)
% RLOCUSGAIN  Encuentra K tal que un polo del lazo cerrado quede lo más
% cercano posible a p_des. Si NO se piden outputs, grafica (como rlocus).
% G: sistema a realizar lugar de raices.
% p_dest: polo objetivo.
% [K_best, pole_best] = rlocus_gain(G, p_des)
    arguments
        G {mustBeA(G,'DynamicSystem')}
        p_des (1,1)
    end

    [r, kvec] = rlocus(G);
    numK = numel(kvec);

    % Buscar el mejor K muestreado
    minDist = inf;
    idxBest = 1;
    for i = 1:numK
        polos = r(:,i);
        dist = min(abs(polos - p_des));
        if dist < minDist
            minDist = dist;
            idxBest = i;
        end
    end
    K_init = kvec(idxBest);

    %%% Refino el resultado
    dist_fun = @(K) min(abs(pole(feedback(K*G,1)) - p_des));

    if idxBest > 1
        lo = kvec(idxBest-1);
    else
        lo = max(0, K_init*0.1);
    end

    if idxBest < numK
        hi = kvec(idxBest+1);
    else
        hi = K_init*2 + 1e-6;
    end

    lo = max(lo,0);
    hi = max(hi, lo + 1e-6);
    opts = optimset('TolX',1e-8, 'Display','off');

    % Búsqueda local
    K_refined = fminbnd(dist_fun, lo, hi, opts);
    poles_refined = pole(feedback(K_refined*G,1));

    % Salida final
    K_best = K_refined;
    [~, idx] = min(abs(poles_refined - p_des));
    pole_best = poles_refined(idx);
    
    %%% Graficar
    figure;
    rlocus(G); hold on; grid on;

    plot(real(p_des), imag(p_des), 'ro', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', 'Polo deseado');
    plot(real(pole_best), imag(pole_best), 'bx', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', 'Polo obtenido');

    legend show;
    title(sprintf("Lugar de las raíces. K = %.2g", K_best));

end
