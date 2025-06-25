function resultados = evaluarDetectores(I, config)
    % evaluarDetectores Aplica Sobel, LoG y Canny y calcula métricas de calidad
    %   resultados = evaluarDetectores(I, config)
    %   I: imagen preprocesada en escala de grises
    %   config: estructura con parámetros de umbralización
    %   resultados: arreglo de structs con campos:
    %     - name: método de borde ('Sobel', 'LoG' o 'Canny')
    %     - BWedge: máscara binaria del contorno
    %     - metrics: struct con métricas de calidad devuelto por evaluarCalidadContorno
    
    % Definir métodos a evaluar
    metodos = {'Sobel', 'LoG', 'Canny'};
    numMetodos = numel(metodos);
    
    % Prealocar arreglo de resultados para eficiencia
    resultados(numMetodos) = struct('name', '', 'BWedge', [], 'metrics', []);
    
    for k = 1:numMetodos
        modo = metodos{k};
        switch modo
            case 'Sobel'
                if isempty(config.SobelThreshold)
                    BW = edge(I, 'Sobel');
                else
                    BW = edge(I, 'Sobel', config.SobelThreshold);
                end
            case 'LoG'
                if isempty(config.LoGThreshold)
                    BW = edge(I, 'log');
                else
                    BW = edge(I, 'log', config.LoGThreshold);
                end
            case 'Canny'
                BW = edge(I, 'Canny', config.CannyThreshold);
        end
        % Cerrar pequeños huecos en el contorno
        BWcl = imclose(BW, strel('disk', 1));
        % Evaluar calidad de contorno
        metrics = evaluarCalidadContorno(BWcl);
        % Rellenar la entrada prealocada
        resultados(k) = struct('name', modo, 'BWedge', BWcl, 'metrics', metrics);
    end
end