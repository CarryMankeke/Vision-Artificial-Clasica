function estado = inicializarDataset(config)
    % inicializarDataset Verifica carpetas y calcula parámetros derivados
    %   estado = inicializarDataset(config)
    %   - Comprueba existencia de carpetas de train y test
    %   - Lee una imagen de referencia y determina radio nominal
    %   - Calcula los campos R_ext_nom_px y tol_px en config
    %   - Devuelve estado.config actualizado
    
    % Verificar carpetas del dataset
    if ~isfolder(config.trainFolder)
        error('Carpeta de entrenamiento no encontrada: %s', config.trainFolder);
    end
    if ~isfolder(config.testNormalFolder)
        error('Carpeta de test normal no encontrada: %s', config.testNormalFolder);
    end
    if ~isfolder(config.testAnomalyFolder)
        error('Carpeta de test anómalo no encontrada: %s', config.testAnomalyFolder);
    end
    
    % Leer primera imagen normal de referencia
    refFiles = dir(fullfile(config.trainFolder, '*.png'));
    if isempty(refFiles)
        error('No se encontraron imágenes PNG en %s', config.trainFolder);
    end
    refPath = fullfile(config.trainFolder, refFiles(1).name);
    Iref = leerImagenGrayscale(refPath);
    
    % Segmentar la golilla para obtener máscara
    maskRef = segmentarRegionPieza(Iref, config);
    if isempty(maskRef) || ~any(maskRef(:))
        error('No se pudo segmentar la imagen de referencia');
    end
    
    % Calcular diámetro equivalente y derivar radio nominal (px)
    stats = regionprops(maskRef, 'EquivDiameter');
    R_equiv = stats.EquivDiameter / 2;
    
    % Actualizar configuración con valores derivados
    config.R_ext_nom_px = R_equiv;
    config.tol_px       = config.tolPct * R_equiv;
    
    % Salvar estado
    estado.config = config;
end
