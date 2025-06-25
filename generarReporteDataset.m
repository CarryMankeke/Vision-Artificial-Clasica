function generarReporteDataset(resultados)
    % generarReporteDataset Imprime métricas de clasificación del dataset
    %   generarReporteDataset(resultados)
    %   resultados: struct con campos TP, TN, FP, FN
    
    TP = resultados.TP;
    TN = resultados.TN;
    FP = resultados.FP;
    FN = resultados.FN;
    
    % Mostrar matriz de confusión
    fprintf('Matriz de Confusión:\n');
    fprintf('          Predicción\n');
    fprintf('           N    A\n');
    fprintf('Real N:   %4d %4d\n', TN, FP);
    fprintf('Real A:   %4d %4d\n', FN, TP);
    
    % Calcular métricas
    accuracy  = (TP + TN) / (TP + TN + FP + FN);
    precision = TP / (TP + FP);
    recall    = TP / (TP + FN);
    
    % Mostrar métricas
    fprintf('\nAccuracy : %.2f%%\n', accuracy*100);
    fprintf('Precision: %.2f%%\n', precision*100);
    fprintf('Recall   : %.2f%%\n', recall*100);
end
