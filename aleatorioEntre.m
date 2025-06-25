function n = aleatorioEntre(a, b)
    % aleatorioEntre Devuelve un entero aleatorio entre a y b inclusive
    %   n = aleatorioEntre(a, b)
    %   a, b: enteros que definen el rango
    %   n: entero aleatorio en [a, b]
    
    % Validar argumentos
    if ~isscalar(a) || ~isscalar(b) || a ~= floor(a) || b ~= floor(b) || a > b
        error('Los parámetros a y b deben ser enteros con a <= b');
    end
    
    % Generar entero aleatorio en el rango [a, b]
    
    n = randi([a, b]);
end