function metrics = evaluarCalidadContorno(BWedge)
    % evaluarCalidadContorno Calcula métricas de calidad de un borde detectado
    %   metrics = evaluarCalidadContorno(BWedge)
    %   BWedge: máscara binaria de bordes
    
    % 1. Rellenar la región interior para obtener la región completa
    BWfill = imfill(BWedge, 'holes');
    
    % 2. Encontrar componentes conectados
    CC = bwconncomp(BWfill);
    
    % 3. Si no hay componentes, devolver NaN
    if CC.NumObjects == 0
        metrics = struct('eulerNumber', NaN, ...
                         'circularity',  NaN, ...
                         'numInteriorIssues', NaN);
        return;
    end
    
    % 4. Obtener propiedades
    stats = regionprops(CC, 'Area', 'Perimeter', 'EulerNumber');
    areas = [stats.Area];
    [~, idxMax] = max(areas);
    
    euler = stats(idxMax).EulerNumber;
    area  = stats(idxMax).Area;
    perim = stats(idxMax).Perimeter;
    
    % 5. Calcular circularidad
    circularity = 4 * pi * area / (perim^2);
    
    % 6. Determinar número de issues interiores
    if euler == 0
        numInteriorIssues = 0;
    elseif euler < 0
        numInteriorIssues = abs(euler) - 1;
    else
        numInteriorIssues = euler;
    end
    
    % 7. Devolver struct de métricas
    metrics = struct('eulerNumber',       euler, ...
                     'circularity',       circularity, ...
                     'numInteriorIssues', numInteriorIssues);
end
