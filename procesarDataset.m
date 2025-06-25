function resultados = procesarDataset(estado)
    % procesarDataset Procesa el conjunto de prueba y calcula métricas de clasificación
    %   resultados = procesarDataset(estado)
    %   estado: struct con estado.config (configuración del proyecto)
    %   resultados: struct con campos TP, TN, FP, FN
    
    % Extraer configuración
    config = estado.config;
    
    % Inicializar contadores
    TP = 0;  % verdaderos positivos (anomalías correctamente rechazadas)
    TN = 0;  % verdaderos negativos (normales correctamente aprobadas)
    FP = 0;  % falsos positivos (normales rechazadas)
    FN = 0;  % falsos negativos (anomalías aprobadas)
    
    % Procesar imágenes normales de test
    filesNorm = dir(fullfile(config.testNormalFolder, '*.png'));
    for i = 1:numel(filesNorm)
        pathImg = fullfile(config.testNormalFolder, filesNorm(i).name);
        I = leerImagenGrayscale(pathImg);
        decision = procesarImagenDataset(I, estado);
        if strcmp(decision, 'APROBADO')
            TN = TN + 1;
        else
            FP = FP + 1;
        end
    end
    
    % Procesar imágenes anómalas de test
    filesAnom = dir(fullfile(config.testAnomalyFolder, '*.png'));
    for i = 1:numel(filesAnom)
        pathImg = fullfile(config.testAnomalyFolder, filesAnom(i).name);
        I = leerImagenGrayscale(pathImg);
        decision = procesarImagenDataset(I, estado);
        if strcmp(decision, 'RECHAZADO')
            TP = TP + 1;
        else
            FN = FN + 1;
        end
    end
    
    % Construir struct de resultados
    resultados = struct('TP', TP, ...
                        'TN', TN, ...
                        'FP', FP, ...
                        'FN', FN);
end
