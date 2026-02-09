function K00 = prefilterEstimator(A,B,C,D,K,Ke,options)
% PREFILTERESTIMATOR Computa el prefiltro del controlador cuando se usan estados estimados.
% A,B,C,D  : matrices de la planta
% K, Ke    : ganancias de realimentacion y observador (K: state-feedback, Ke: estimator)
% Ts       : 0 -> continuo. >0 -> discreto (muestreo Ts)
% Yinf,Rinf: opcional (si se quiere imponer G_dc = Yinf * pinv(Rinf))
%
% Devuelve K00 (matriz #inputs x #referencias) tal que
%    y_ss = (Yinf * pinv(Rinf)) * r   (si Yinf/Rinf se pasaron)
% o else K00 = pinv(H) (prefiltro que hace que G_dc = I aproximado)
    arguments
        A (:,:) double
        B (:,:) double
        C (:,:) double
        D (:,:) double
        K (:,:) double
        Ke (:,:) double
        options.Ts double = 0
        options.Yinf double = []
        options.Rinf double = []
    end
    
    %n = size(A,1);  % cant estados
    r = size(B,2);  % cant entradas
    m = size(C,1);  % cant salidas
    has_inf_value = (~isempty(options.Rinf) && ~isempty(options.Yinf));

    MG = ss(A,B,C,D, options.Ts);
    MH = ss((A-B*K-Ke*C), Ke, K, zeros(r, m), options.Ts);
    Mtot = feedback(MG, MH);
    K00 = pinv(dcgain(Mtot));
    if has_inf_value
        K00 = K00 * options.Yinf * pinv(options.Rinf);
    end


