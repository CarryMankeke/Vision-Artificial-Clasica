function metrics = calcularMetricas(maskPieza, Igray, config)
    % calcularMetricas Extrae métricas geométricas de la golilla segmentada
    %   metrics = calcularMetricas(maskPieza, Igray, config)
    %   maskPieza: máscara binaria de la golilla segmentada
    %   Igray: imagen original en escala de grises
    %   config: struct con parámetros de configuración
    
    % Obtener propiedades geométricas
    stats = regionprops(maskPieza, ...
        'Area','Perimeter','Centroid','EulerNumber', ...
        'MajorAxisLength','MinorAxisLength','BoundingBox');
    
    % Asumir una sola región principal
    % regionprops devuelve un struct array; tomamos el primero
    euler       = stats(1).EulerNumber;
    area        = stats(1).Area;
    perim       = stats(1).Perimeter;
    circularity = 4 * pi * area / (perim^2);
    axisRatio   = stats(1).MajorAxisLength / stats(1).MinorAxisLength;
    
    % Recorte de la imagen original según bounding box
    rect = stats(1).BoundingBox;           % [x y width height]
    subI = imcrop(Igray, rect);
    
    % Parámetros de Hough basado en radio nominal y tolerancia
    Rnom = config.R_ext_nom_px;
    tol  = config.tolPct;
    minR = floor(Rnom * (1 - tol));
    maxR = ceil (Rnom * (1 + tol));
    
    % Detectar círculos en la subimagen
    [~, radii] = imfindcircles(subI, [minR, maxR], ...
        'ObjectPolarity','dark', 'Sensitivity', config.houghSensitivity);
    
    % Asignar radios exterior e interior
    if numel(radii) >= 2
        radiiSort = sort(radii, 'descend');
        R_ext_px = radiiSort(1);
        R_int_px = radiiSort(2);
    elseif isscalar(radii)
        R_ext_px = radii(1);
        R_int_px = NaN;
    else
        R_ext_px = NaN;
        R_int_px = NaN;
    end
    
    % Construir struct de salida
    metrics = struct( ...
        'euler',       euler, ...
        'circularity', circularity, ...
        'axisRatio',   axisRatio, ...
        'R_ext_px',    R_ext_px, ...
        'R_int_px',    R_int_px ...
    );
end
