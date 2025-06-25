function escena = generarEscenaSintetica(config, dsTrain, dsAnom)
    % generarEscenaSintetica Crea una imagen sintética con varias golillas
    %   escena = generarEscenaSintetica(config, dsTrain, dsAnom)
    %   config: struct de configuración con campo synthetic
    %   dsTrain: imageDatastore de imágenes normales
    %   dsAnom: imageDatastore de imágenes anómalas
    %   escena: imagen en escala de grises (double en [0,1])
    
    % Tamaño del lienzo
    canvasSize = config.synthetic.canvasSize;  % [alto, ancho]
    alto = canvasSize(1);
    ancho = canvasSize(2);
    
    % Inicializar lienzo con gris medio
    escena = 0.5 * ones(alto, ancho);
    
    % Número de piezas a colocar
    rangoP = config.synthetic.numPiecesRange;
    numP = aleatorioEntre(rangoP(1), rangoP(2));
    
    for k = 1:numP
        % Elegir imagen normal o anómala
        if rand < config.synthetic.probAnomaly
            pathImg = elegirAleatorio(dsAnom.Files);
        else
            pathImg = elegirAleatorio(dsTrain.Files);
        end
        % Leer y rotar la golilla
        Iw = leerImagenGrayscale(pathImg);
        ang = aleatorioEntre(0, 359);
        Iwr = rotarImagen(Iw, ang);
        % Segmentar la golilla rotada
        maskIw = segmentarRegionPieza(Iwr, config);
        % Obtener dimensiones de la golilla
        [hIw, wIw] = size(Iwr);
        % Elegir posición aleatoria que asegure encaje en el lienzo
        x = aleatorioEntre(1, ancho  - wIw + 1);
        y = aleatorioEntre(1, alto   - hIw + 1);
        % Superponer la golilla sobre el lienzo usando la máscara
        patch = escena(y:y+hIw-1, x:x+wIw-1);
        patch(maskIw) = Iwr(maskIw);
        escena(y:y+hIw-1, x:x+wIw-1) = patch;
    end
end
