% main.m
% Script principal que orquesta el flujo completo usando el dataset

clc; clear; close all;

% 1. Cargar configuración del proyecto
config = cargarConfiguracionDataset();

% 2. Inicializar dataset (calcular radio nominal, validar rutas)
estado = inicializarDataset(config);

% 3. Procesar conjunto de prueba y obtener métricas de clasificación
resultados = procesarDataset(estado);

% 4. Crear datastores para escenas sintéticas (solo se usan para generación)
dsTrain = imageDatastore(config.trainFolder);
dsAnom  = imageDatastore(config.testAnomalyFolder);

% 5. Generar y procesar múltiples escenas sintéticas
numEscenas = 5;
for i = 1:numEscenas
    % Generar escena con golillas normales y anómalas
    escena = generarEscenaSintetica(config, dsTrain, dsAnom);
    % Procesar escena: segmentar, clasificar y visualizar resultados
    procesarEscenaSintetica(escena, estado);
end

% 6. Imprimir reporte final de performance
generarReporteDataset(resultados);
