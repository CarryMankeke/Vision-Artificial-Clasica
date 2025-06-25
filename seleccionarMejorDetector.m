function best = seleccionarMejorDetector(resultados, config)
    % seleccionarMejorDetector Elige el detector con mejor score según métricas
    %   best = seleccionarMejorDetector(resultados, config)
    %   resultados: array de structs con campos .metrics (con eulerNumber, circularity, numInteriorIssues)
    %   config.circularityTol: [min max]
    
    % Inicializar
    mejorScore = -Inf;
    best = resultados(1);
    
    % Recorrer todos los resultados
    for k = 1:numel(resultados)
        r = resultados(k);
        % Extraer métricas
        e = r.metrics.eulerNumber;
        c = r.metrics.circularity;
        ni = r.metrics.numInteriorIssues;
        % Calcular score
        score = 0;
        if e == 0
            score = score + 2;
        end
        if c >= config.circularityTol(1) && c <= config.circularityTol(2)
            score = score + 2;
        end
        if ni == 0
            score = score + 1;
        end
        % Penalizar desviación de circularidad de 1
        if ~isnan(c)
            score = score - abs(c - 1);
        end
        % Actualizar mejor
        if score > mejorScore
            mejorScore = score;
            best = r;
        end
    end
    
    % Fallback (por si no se asignó ninguno, aunque ocurre solo si resultados vacío)
    if isempty(best) && ~isempty(resultados)
        % Elegir el que tenga circularity más cercano a 1
        difMin = Inf;
        for k = 1:numel(resultados)
            c = resultados(k).metrics.circularity;
            if ~isnan(c) && abs(c - 1) < difMin
                difMin = abs(c - 1);
                best = resultados(k);
            end
        end
    end
end
