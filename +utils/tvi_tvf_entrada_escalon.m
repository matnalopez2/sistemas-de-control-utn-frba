function [y0, yinf] = tvi_tvf_entrada_escalon(G, varargin)
% Uso:
%   r = utils.tvi_tvf_entrada_escalon(G);          % imprime (default)
%   r = utils.tvi_tvf_entrada_escalon(G,'silent'); % no imprime
s = tf('s');

Y = G/s;
Ym = minreal(Y);
Ylim = Ym * s;

% --- TVI para escalón: y(0+) = lim_{s->inf} s*G(s)*(1/s) = lim_{s->inf} G(s) ---
y0 = utils.lim_tf(minreal(Ylim), Inf);

% --- TVF para escalón: y(inf) = lim_{s->0} s*G(s)*(1/s) = G(0), si G estable ---
yinf = utils.lim_tf(minreal(Ylim), 0);


if ~any(strcmpi(varargin, 'silent'))
    fprintf('TVI: y(0+) = %.6g\n', y0);
    if isstable(G)
        fprintf('TVF: y(∞)  = %.6g\n', yinf);
    else
        fprintf('TVF no aplicable: G(s) inestable. Polos: ( ');
        fprintf('%g ', pole(G));
        fprintf(')\n');
    end
end
end