function val = lim_tf(G, at)
%LIM_TF  Calcula límites robustos de una FT G(s) en s->0 o s->Inf
%
% Uso:
%   val = utils.lim_tf(G, 0);     % lim_{s->0}   G(s)
%   val = utils.lim_tf(G, Inf);   % lim_{s->Inf} G(s)
%
% Devuelve NaN si el límite no existe (p.ej., s->Inf y G no es propia).
Gm = minreal(G);
if isinf(at)
    [num, den] = tfdata(Gm, 'v');
    degN = length(num) - 1;
    degD = length(den) - 1;

    if degN < degD
        val = 0;
    elseif degN == degD
        val = num(1)/den(1);   % coeficientes líderes
    else
        val = NaN;             % no existe (no propia)
    end

elseif at == 0
    % lim_{s->0} G(s) = G(0) si está definido
    % (si hay polo en 0, evalfr puede dar Inf o NaN, y eso está bien)
    val = evalfr(Gm, 0);
else
    error('utils.lim_tf: at debe ser 0 o Inf');
end
end
