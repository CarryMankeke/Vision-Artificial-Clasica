function resultados = procesarEscenaSintetica(escena, estado)
% procesarEscenaSintetica Procesa una escena sintética de múltiples golillas
%   resultados = procesarEscenaSintetica(escena, estado, dsTrain, dsAnom)
%   escena: imagen en escala de grises con varias golillas sintéticas
%   estado: struct con estado.config
%   resultados: array de structs con campos:
%     - BoundingBox: [x y width height]
%     - decision: 'APROBADO' o 'RECHAZADO'

% Extraer configuración
config = estado.config;

% 1. Preprocesar la escena completa
Igray = escena;
Iproc = preprocesarImagen(Igray, config);

% 2. Segmentación global para separar componentes
BWglob = imbinarize(Iproc, 'adaptive', 'Sensitivity', 0.4, 'ForegroundPolarity', 'dark');
BWglob = imfill(BWglob, 'holes');

% 3. Extraer componentes individuales
comps = separarComponentesSolapadas(BWglob, config);
numComp = numel(comps);

% 4. Prealocar resultados
resultados(numComp) = struct('BoundingBox', [], 'decision', '');

% 5. Procesar cada componente como imagen individual
for k = 1:numComp
    bb = comps(k).BoundingBox;
    subI = imcrop(Igray, bb);
    d = procesarImagenDataset(subI, estado);
    resultados(k) = struct('BoundingBox', bb, 'decision', d);
end

% 6. Mostrar la escena con resultados
mostrarEscenaConResultados(escena, resultados);
end
