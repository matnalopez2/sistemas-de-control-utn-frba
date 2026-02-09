function [K, K0, Ke, K00] = control(A,B,C,D, PLC, options)
%CONTROL Realiza el calculo de la matriz de realimentacion y estimacion
%   Calcula las matrices de realimentacion y estimacion para una planta.
%   Adicionalmente calcula los prefiltros de realimentacion de estados y de
%   estimacion (suponiendo controlador en paralelo)
% A: Matriz de estados.
% B: Matriz de entrada
% C: Matriz de salida
% D: Matriz de transmision directa
% PLC: Polos a lazo cerrado de la planta.
% Pest: Polos del estimador.
% Ts: Tiempo de muestreo. Opcional. 0 default (continuo).
% Yinf: Vector de salidas deseadas en infinito.
% Rinf: Vector de entradas deseadas en infinito.
    arguments
        A (:,:) double
        B (:,:) double
        C (:,:) double
        D (:,:) double
        PLC double
        options.Pest double = []
        options.Ts double = 0
        options.Yinf double = []
        options.Rinf double = []
    end
    n = size(A,1);   % cant estados
    r = size(B,2);   % cant entradas
    m = size(C,1);   % cant salidas
    
    %%% Chequeo de valores
    has_inf_value = (~isempty(options.Rinf) && ~isempty(options.Yinf));
    
    if has_inf_value
        if ~isequal(size(options.Rinf), [r, 1])
            error('Rinf debe ser de tamaño (%d,1)', r);
        end
        if ~isequal(size(options.Yinf), [m, 1])
            error('Yinf debe ser de tamaño (%d,1)', m);
        end
    end
    
    %%% Controlabilidad
    if ( n > rank(ctrb(A,B)) )
        error('El sistema NO ES controlable. No se puede realimentar el vector de estados\n');
    else
        fprintf('El sistema ES controlable\n');
    end
    
    %%% Realimentacion de vector de estados
    if r == 1 && m == 1
        K = acker(A,B,PLC);
    else
        K = place(A,B,PLC);
    end
    An = A-B*K;

    K0 = pinv(dcgain(ss(An,B,C,D, options.Ts)));    %% Si #in = #out --> pinv = inv 
    
    if has_inf_value
        K0 = K0 * options.Yinf * pinv(options.Rinf);
    end

    %%% Observabilidad y estimacion de estados
    Ke = [];
    K00 = [];
    if ~(isempty(options.Pest))
        if ( n > rank(obsv(A,C)) )
            error('El sistema NO ES observable. No se puede estimar el vector de estados\n');
        else
            fprintf('El sistema ES observable\n');
        end
        
        if r == 1 && m == 1
            Ke = acker(A',C',options.Pest)';
        else
            Ke = place(A',C',options.Pest)';
        end
        
        MG = ss(A,B,C,D, options.Ts);
        MH = ss((A-B*K-Ke*C), Ke, K, zeros(r, m), options.Ts);
        Mtot = feedback(MG, MH);
        K00 = pinv(dcgain(Mtot));
        if has_inf_value
            K00 = K00 * options.Yinf * pinv(options.Rinf);
        end
    end

end

