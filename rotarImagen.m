function Irot = rotarImagen(I, ang)
    % rotarImagen Rota una imagen en un ángulo dado
    %   Irot = rotarImagen(I, ang)
    %   I: imagen de entrada (matriz 2D)
    %   ang: ángulo de rotación en grados
    %   Irot: imagen rotada con el mismo tamaño de I
    
    % Validar tipo de ángulo
    if ~isscalar(ang) || ~isnumeric(ang)
        error('El ángulo debe ser un valor numérico escalar.');
    end
    
    % Rotar la imagen manteniendo el tamaño original
    Irot = imrotate(I, ang, 'bilinear', 'crop');
end
