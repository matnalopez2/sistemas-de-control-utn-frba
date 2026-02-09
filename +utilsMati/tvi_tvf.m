%==========================================================================
% Archivo: tvi_tvf.m
%
% Descripción:
%   Calcula el Teorema del Valor Inicial (TVI) y el Teorema del Valor Final
%   (TVF) para la respuesta al escalón unitario de un sistema LTI continuo.
%
% Uso:
%   [y0, yinf] = utils.tvi_tvf(G)
%
% Entradas:
%   G    : Función transferencia del sistema (tf / zpk / ss)
%
% Salidas:
%   y0   : Valor inicial de la respuesta (y(0+))
%   yinf : Valor final de la respuesta (y(∞))
%
% Notas:
%   - El TVF es válido únicamente si todos los polos de s·Y(s) se encuentran
%     en el semiplano izquierdo (sistema estable).
%   - Se asume entrada escalón unitario.
%
% Materia:
%   Sistemas de Control (Ingeniería Electrónica)
%   Universidad Tecnológica Nacional - FRBA
%
% Autor:
%   Matías Nahuel López
%==========================================================================

function [y0, yinf] = tvi_tvf(Y)
    s = tf('s');
    y0 = evalfr(minreal(s*Y), Inf);
    yinf = evalfr(minreal(s*Y), 0);
end



