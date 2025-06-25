function Igray = leerImagenGrayscale(path)
    % leerImagenGrayscale Lee una imagen PNG y devuelve su versión en escala de grises
    %   Igray = leerImagenGrayscale(path)
    %   path: ruta al archivo PNG
    %   Igray: imagen en escala de grises
    
    % Leer la imagen
    I = imread(path);
    % Si la imagen es RGB, convertir a gris
    if ndims(I) == 3 && size(I,3) == 3
        Igray = rgb2gray(I);
    else
        % Si ya es 2D, devolver tal cual
        Igray = I;
    end
end
