function Iout = preprocesarImagen(Igray, config)
    % preprocesarImagen Aplica filtrado y compensación de iluminación
    %   Iout = preprocesarImagen(Igray, config)
    %   Igray: imagen en escala de grises
    %   config.gaussSigma: sigma del filtro Gaussiano
    %   config.compensarIluminacion: flag para sustracción de fondo
    %   config.morphKernelSize: tamaño de elemento estructurante
    
    % Aplicar filtro Gaussiano para reducir ruido
    if config.gaussSigma > 0
    I = imgaussfilt(Igray, config.gaussSigma);
    else
        I = Igray;  % No se aplica suavizado
    end
    
    % Compensación de iluminación (sustracción de fondo) si está activada
    if config.compensarIluminacion
        % Elemento estructurante circular
        kernel = strel('disk', config.morphKernelSize);
        % Estimar fondo mediante apertura morfológica
        background = imopen(I, kernel);
        % Sustraer fondo de la imagen
        I = imsubtract(I, background);
    end
    
    % Devolver imagen procesada
    Iout = I;
end
