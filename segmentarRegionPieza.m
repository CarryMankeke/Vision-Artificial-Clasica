function mask = segmentarRegionPieza(Igray, config)
    % segmentarRegionPieza Segmenta la golilla en primer plano
    %   mask = segmentarRegionPieza(Igray, config)
    %   Igray: imagen en escala de grises
    %   config.R_ext_nom_px: radio nominal en px para calcular área mínima
    
    % 1. Umbral adaptativo
    BW = imbinarize(Igray, 'adaptive', 'Sensitivity', 0.4, 'ForegroundPolarity', 'dark');
    
    % 2. Rellenar agujeros
    BW = imfill(BW, 'holes');
    
    % 3. Encontrar componentes conectados
    CC = bwconncomp(BW);
    stats = regionprops(CC, 'Area');
    
    % 4. Seleccionar la región de mayor área
    areas = [stats.Area];
    [~, idxMax] = max(areas);
    mask = (labelmatrix(CC) == idxMax);
    
    % 5. Eliminar objetos muy pequeños
    areaMin = pi * (config.R_ext_nom_px * 0.5)^2 * 0.2;  % 20% del área nominal
    % Calcular área mínima y asegurar que sea un entero escalar
    p = round(areaMin);
    if isscalar(p) && p > 0
        mask = bwareaopen(mask, p);
    end
end
