function [decision, info] = decidirAprobacion(maskPieza, config, metrics)
    % decidirAprobacion Determina si la golilla pasa o no el control de calidad
    %   [decision, info] = decidirAprobacion(maskPieza, Igray, estado, config, metrics)
    %   maskPieza: máscara binaria de la golilla
    %   config: struct con parámetros de tolerancia
    %   metrics: struct con campos euler, circularity, axisRatio, R_ext_px, R_int_px
    
    % Inicializar razones y flag de aprobación
    razones = {};
    ok = true;
    
    % 1. EulerNumber debe ser 0
    if metrics.euler ~= 0
        ok = false;
        razones{end+1} = sprintf('EulerNumber = %d (no cero)', metrics.euler);
    end
    
    % 2. Circularidad dentro de tolerancia
    c = metrics.circularity;
    tolCirc = config.circularityTol;
    if c < tolCirc(1) || c > tolCirc(2)
        ok = false;
        razones{end+1} = sprintf('Circularity = %.3f fuera de [%.2f, %.2f]', c, tolCirc(1), tolCirc(2));
    end
    
    % 3. Relación de ejes dentro de tolerancia
    ar = metrics.axisRatio;
    tolAR = config.axisRatioTol;  % [0.97, 1.03]
    if ar < tolAR(1) || ar > tolAR(2)
        ok = false;
        razones{end+1} = sprintf('Axis ratio = %.3f fuera de [%.2f, %.2f]', ar, tolAR(1), tolAR(2));
    end
    
    % 4. Radio exterior vs nominal
    Rext = metrics.R_ext_px;
    Rnom = config.R_ext_nom_px;
    tolPx = config.tol_px;
    if isnan(Rext) || abs(Rext - Rnom) > tolPx
        ok = false;
        if isnan(Rext)
            razones{end+1} = 'No se detectó radio exterior con Hough';
        else
            razones{end+1} = sprintf('R_ext_px = %.1f fuera de ±%.1f px de nominal', Rext, tolPx);
        end
    end
    
    % 5. Detectar grietas internas mediante esqueleto
    skel = bwmorph(maskPieza, 'skel', Inf);
    branchPts = bwmorph(skel, 'branchpoints');
    if any(branchPts(:))
        ok = false;
        razones{end+1} = 'Ramificaciones en esqueleto: posible grieta interna';
    end
    
    % Asignar resultado final
    if ok
        decision = 'APROBADO';
    else
        decision = 'RECHAZADO';
    end
    
    % Salvar información adicional
    info.razones = razones;
    info.metrics = metrics;
    info.decision = decision;
end
