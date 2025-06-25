function elem = elegirAleatorio(lista)
    % elegirAleatorio Selecciona un elemento al azar de una lista
    %   elem = elegirAleatorio(lista)
    %   lista: cell array o vector de valores
    %   elem: elemento seleccionado
    
    % Validar entrada
    if isempty(lista)
        error('La lista está vacía. No se puede elegir un elemento.');
    end
    
    % Elegir índice aleatorio
    idx = randi(numel(lista));
    
    % Extraer elemento según tipo de lista
    if iscell(lista)
        elem = lista{idx};
    else
        elem = lista(idx);
    end
end