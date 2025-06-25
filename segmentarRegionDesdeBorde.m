function maskPieza = segmentarRegionDesdeBorde(BWedge, config)
    % segmentarRegionDesdeBorde Rellena huecos manteniendo el hueco interior y extrae la región principal
    %   maskPieza = segmentarRegionDesdeBorde(BWedge, config)
    %   BWedge: máscara binaria de bordes obtenida de detectar bordes
    %   config.R_ext_nom_px: radio nominal en píxeles derivado en inicializarDataset
    
    sz = size(BWedge);
    
    % 1. Rellenar todos los huecos
    BWfill = imfill(BWedge, 'holes');
    
    % 2. Detectar huecos interiores grandes y excluirlos:
    %    - Invertimos la máscara de bordes para encontrar componentes de fondo/huecos:
    BW_inv = ~BWedge;
    CCinv = bwconncomp(BW_inv);
    maskHole = false(sz);
    for k = 1:CCinv.NumObjects
        pixIdx = CCinv.PixelIdxList{k};
        [rows, cols] = ind2sub(sz, pixIdx);
        % Si esta componente no toca el borde de la imagen, es un hueco interior
        if all(rows > 1 & rows < sz(1) & cols > 1 & cols < sz(2))
            maskHole(pixIdx) = true;
        end
    end
    % Quitamos ese hueco interior del fill completo
    BW2 = BWfill & ~maskHole;
    
    % 3. Seleccionar la región de mayor área (debería ser la arandela con hueco respetado)
    CC = bwconncomp(BW2);
    stats = regionprops(CC, 'Area');
    if isempty(stats)
        maskPieza = false(sz);
        return;
    end
    areas = [stats.Area];
    [~, idxMax] = max(areas);
    maskPieza = labelmatrix(CC) == idxMax;
    
    % 4. Eliminar artefactos pequeños
    areaMin = pi * (config.R_ext_nom_px * 0.5)^2 * 0.2;  % 20% del área nominal
    p = round(areaMin);
    if isscalar(p) && p > 0
        maskPieza = bwareaopen(maskPieza, p);
    end
    
    % 5. Suavizar contorno para evitar ramificaciones internas
    se = strel('disk', 2);  % ajustar según resolución
    maskPieza = imopen(maskPieza, se);
    maskPieza = imclose(maskPieza, se);
end