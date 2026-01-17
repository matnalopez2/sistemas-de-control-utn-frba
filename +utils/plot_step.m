function [y, t] = plot_step(G, plotTitle, tFinal)
%PLOT_STEP Grafica la respuesta al escalon unitario de un sistema.
%   [y, t] = utils.plot_step(G, plotTitle, tFinal)
%
% Entradas:
%   G         : sistema LTI (tf/zpk/ss)
%   plotTitle : titulo del grafico (string/char). Opcional.
%   tFinal    : tiempo final de simulacion [s]. Opcional.
%
% Salidas:
%   y, t      : respuesta y vector de tiempo (por si queres validar numericamente)

    if nargin < 2 || isempty(plotTitle)
        plotTitle = 'Respuesta al escalon unitario';
    end
    if nargin < 3 || isempty(tFinal)
        tFinal = 10;
    end

    t = linspace(0, tFinal, 1000);

    figure;
    step(G, t);
    grid on;
    title(plotTitle);
    xlabel('Tiempo');
    ylabel('Amplitud');
end
