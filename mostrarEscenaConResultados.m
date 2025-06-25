function mostrarEscenaConResultados(escena, resultados)
    % mostrarEscenaConResultados Dibuja resultados de inspección en una escena sintética
    %   mostrarEscenaConResultados(escena, resultados)
    %   escena: imagen en escala de grises con múltiples golillas
    %   resultados: array de structs con campos:
    %     - BoundingBox: [x y width height]
    %     - decision: 'APROBADO' o 'RECHAZADO'
    
    % Mostrar la escena completa
    figure;
    imshow(escena);
    title('Escena Sintética con Resultados de Inspección');
    hold on;
    
    % Dibujar rectángulos según la decisión
    for k = 1:numel(resultados)
        bb = resultados(k).BoundingBox;
        if strcmp(resultados(k).decision, 'APROBADO')
            color = 'g';
        else
            color = 'r';
        end
        rectangle('Position', bb, 'EdgeColor', color, 'LineWidth', 2);
    end
    
    hold off;
end
