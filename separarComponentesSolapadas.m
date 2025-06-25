function comps = separarComponentesSolapadas(BWglob, config)
    % separarComponentesSolapadas Separa componentes en máscara global con prealloc
    %   comps = separarComponentesSolapadas(BWglob, config)
    %   BWglob: imagen binaria con varias golillas (o componentes)
    %   config: struct con parámetros (uso en needsSplit)
    %   comps: array de structs con campos:
    %     - mask: máscara binaria de la pieza individual
    %     - BoundingBox: rectángulo [x y width height]
    
    % 1. Encontrar componentes conectados
    CC    = bwconncomp(BWglob);
    stats = regionprops(CC, 'BoundingBox', 'PixelIdxList');
    
    % Prealocar arreglo máximo (sin subdividir)
    nMax = CC.NumObjects;
    comps(nMax) = struct('mask', false(size(BWglob)), 'BoundingBox', []);
    idxOut = 0;
    
    % 2. Iterar sobre cada componente
    for k = 1:CC.NumObjects
        % Crear máscara temporal para este componente
        maskC = false(size(BWglob));
        maskC(stats(k).PixelIdxList) = true;
        bbox = stats(k).BoundingBox;
        % 3. Decidir si necesita dividirse
        try
            splitFlag = needsSplit(maskC, config);
        catch
            splitFlag = false;
        end
        if splitFlag
            % Dividir en subcomponentes
            try
                submasks = watershedSplit(maskC, config);
                for j = 1:numel(submasks)
                    subMask = submasks{j};
                    subStats = regionprops(subMask, 'BoundingBox');
                    idxOut = idxOut + 1;
                    comps(idxOut) = struct('mask', subMask, 'BoundingBox', subStats.BoundingBox);
                end
            catch
                idxOut = idxOut + 1;
                comps(idxOut) = struct('mask', maskC, 'BoundingBox', bbox);
            end
        else
            % Agregar componente completo
            idxOut = idxOut + 1;
            comps(idxOut) = struct('mask', maskC, 'BoundingBox', bbox);
        end
    end
    
    % Ajustar tamaño final si hubo subdivisiones o menos comp
    comps = comps(1:idxOut);
end
