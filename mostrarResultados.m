function mostrarResultados(Igray, Iproc, mejor, maskPieza, metrics, info, otrosDef)
    % mostrarResultados Muestra visualizaciones del procesamiento de una golilla
    %   mostrarResultados(Igray, Iproc, mejor, maskPieza, metrics, info, otrosDef)
    %   Igray: imagen original en escala de grises
    %   Iproc: imagen preprocesada
    %   mejor: struct con fields .name y .BWedge
    %   maskPieza: máscara de la golilla segmentada
    %   metrics: struct con campos euler, circularity, axisRatio, R_ext_px, R_int_px
    %   info: struct con .decision y .razones (cell array)
    %   otrosDef: struct con defectos adicionales (.muescas, .deformSuave, .rayones)
    
    figure;
    tiledlayout(2,3);
    
    % 1. Imagen original
    nexttile;
    imshow(Igray);
    title('Original');
    
    % 2. Imagen preprocesada
    nexttile;
    imshow(Iproc);
    title('Preprocesada');
    
    % 3. Borde detectado con método seleccionado
    nexttile;
    imshow(mejor.BWedge);
    title(['Borde: ', mejor.name]);
    
    % 4. Máscara de segmentación y decisión
    nexttile;
    imshow(maskPieza);
    title(['Decisión: ', info.decision]);
    
    % 5. Dibujar círculo exterior detectado
    nexttile;
    imshow(Igray);
    hold on;
    if ~isnan(metrics.R_ext_px) && isfield(info.metrics, 'Center')
        viscircles(info.metrics.Center, metrics.R_ext_px);
    end
    hold off;
    title('Hough Circles');
    
    % 6. Mostrar razones e info adicional en texto
    nexttile;
    axis off;
    lines = info.razones(:);
    if otrosDef.muescas
        lines{end+1} = 'Muescas detectadas';
    end
    if otrosDef.deformSuave
        lines{end+1} = 'Deformación suave detectada';
    end
    text(0.1, 0.5, lines, 'FontSize', 10);
    title('Razones de Decisión');
end
