function decision = procesarImagenDataset(Igray, estado)
    % procesarImagenDataset Procesa una imagen de golilla y decide aprobación
    %   decision = procesarImagenDataset(Igray, estado)
    %   Igray: imagen en escala de grises de una golilla
    %   estado: struct con campo estado.config (configuración del proyecto)
    
    % Extraer configuración
    config = estado.config;
    
    % 1. Preprocesamiento
    Iproc = preprocesarImagen(Igray, config);
    
    % 2. Evaluar detectores de bordes
    resDet = evaluarDetectores(Iproc, config);
    
    % 3. Seleccionar el mejor detector
    mejor = seleccionarMejorDetector(resDet, config);
    
    % 4. Segmentar la golilla a partir del mejor borde
    maskP = segmentarRegionDesdeBorde(mejor.BWedge, config);
    if isempty(maskP) || ~any(maskP(:))
        decision = 'RECHAZADO';
        return;
    end
    
    % 5. Calcular métricas geométricas
    metrics = calcularMetricas(maskP, Igray, config);
    
    % 6. Decidir aprobación
    [decision, info] = decidirAprobacion(maskP, config, metrics);
    
    % 7. Detectar otros defectos (opcional)
    otros = detectarOtrosDefectos(maskP, config);
    
    % 8. Visualización si está habilitado
    if config.verbose
        mostrarResultados(Igray, Iproc, mejor, maskP, metrics, info, otros);
    end
end
