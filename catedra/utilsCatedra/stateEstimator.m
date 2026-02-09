function Ke = stateEstimator(A, C, Pest)
%STATEESTIMATOR resuelve la estimación de un ss
%   Devuelve la matriz de estimación para un ss determinado.
% A: Matriz de estados.
% C: Matriz de salida.
% Pest: Polos del estimador.
    arguments
        A (:,:) double
        C (:,:) double
        Pest double
    end
    n = size(A,1);   % cant estados
    m = size(C,1);   % cant salidas

    %%% Observabilidad
    if ( n > rank(obsv(A,C)) )
        error('El sistema NO ES observable. No se puede estimar el vector de estados\n');
    else
        fprintf('El sistema ES observable\n');
    end
    
    %%% Vector de estimacion
    if m == 1
        Ke = acker(A',C',Pest)';
    else
        Ke = place(A',C',Pest)';
    end

    if nargout == 0
        fprintf('Matriz de estimacion:');
        disp(Ke);
    end
end