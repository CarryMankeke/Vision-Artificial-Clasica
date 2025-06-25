function otros = detectarOtrosDefectos(maskPieza, config)
% detectarOtrosDefectos Busca defectos adicionales en la golilla
%   otros = detectarOtrosDefectos(maskPieza, config)
%   maskPieza: máscara binaria de la golilla segmentada
%   config.tol_px: tolerancia en píxeles para el perfil radial

% Inicializar struct de salida
otros = struct('muescas', false, 'deformSuave', false, 'rayones', false);

% 1. Perfil radial para detectar muescas/protuberancias
boundary = bwboundaries(maskPieza);
if isempty(boundary)
    return;
end
boundary = boundary{1};  % Nx2 array [fila, col]

% Calcular centroide
cent = regionprops(maskPieza, 'Centroid');
cent = cent.Centroid;    % [x y]

% Preparar vectores de ángulos y radios
theta = atan2(boundary(:,1) - cent(2), boundary(:,2) - cent(1));
radius = hypot(boundary(:,1) - cent(2), boundary(:,2) - cent(1));

% Ordenar por theta
[thetaSorted, idx]   = sort(theta);
radiusSorted         = radius(idx);

% Quitar valores duplicados en el eje de muestras
[thetaUnique, ia]    = unique(thetaSorted);
radiusUnique         = radiusSorted(ia);

% Interpolación a malla uniforme de ángulos
thetaGrid            = linspace(-pi, pi, numel(thetaUnique));
radiusInterp         = interp1(thetaUnique, radiusUnique, thetaGrid, ...
                               'linear', 'extrap');

% Detectar picos en perfil radial
desv = abs(radiusInterp - mean(radiusInterp));
if any(desv > config.tol_px * 0.3)
    otros.muescas = true;
end

% 2. Fourier descriptors (si existen funciones auxiliares)
try
    fd = calcularFourierDescriptors(boundary);
    desviacionFD = compararConFDNormales(fd);
    % Umbral para Fourier (ejemplo: 0.2)
    umbralFD = 0.2;
    otros.deformSuave = (desviacionFD > umbralFD);
catch
    % Si falta implementación, dejar como false
end

% 3. Rayones: no aplicable en dataset puro
otros.rayones = false;
end
