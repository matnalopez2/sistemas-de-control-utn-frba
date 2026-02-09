function K0 = prefilterFeedback(A,B,C,D,K,options)
% PREFILTERFEEDBACK Computa el prefiltro del controlador cuando se usan estados estimados.
% A,B,C,D  : matrices de la planta
% K        : ganancias de realimentacion
% Ts       : 0 -> continuo. >0 -> discreto (muestreo Ts)
% Yinf,Rinf: opcional (si se quiere imponer G_dc = Yinf * pinv(Rinf))
%
% Devuelve K0 (matriz #inputs x #referencias) tal que
%    y_ss = (Yinf * pinv(Rinf)) * r   (si Yinf/Rinf se pasaron)
% o else K0 = pinv(H) (prefiltro que hace que G_dc = I aproximado)
    arguments
        A (:,:) double
        B (:,:) double
        C (:,:) double
        D (:,:) double
        K (:,:) double
        options.Ts double = 0
        options.Yinf double = []
        options.Rinf double = []
    end
    has_inf_value = (~isempty(options.Rinf) && ~isempty(options.Yinf));

    An = A-B*K;
    K0 = pinv(dcgain(ss(An,B,C,D, options.Ts)));    %% Si #in = #out --> pinv = inv 
    
    if has_inf_value
        K0 = K0 * options.Yinf * pinv(options.Rinf);
    end


