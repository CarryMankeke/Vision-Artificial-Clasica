function config = cargarConfiguracionDataset()
    % cargarConfiguracionDataset Inicializa los parámetros de configuración del proyecto
    %   config = cargarConfiguracionDataset()
    %   Define rutas del dataset y parámetros para el procesamiento de imágenes.
    
    % Ruta base al dataset (ajusta según tu sistema)
    config.datasetPath = 'C:\Users\camil\OneDrive\Escritorio\washer_detection\archive\simplified-washers-for-anomaly-detection';
    
    % Carpetas de train y test
    config.trainFolder       = fullfile(config.datasetPath, 'train', 'conform');
    config.testNormalFolder  = fullfile(config.datasetPath, 'test',  'conform');
    config.testAnomalyFolder = fullfile(config.datasetPath, 'test',  'anomaly');
    
    % Parámetros de preprocesamiento
    config.gaussSigma           = 0.0;       % Desviación estándar del filtro Gaussiano
    config.compensarIluminacion = false;      % Realizar sustracción de fondo
    config.morphKernelSize      = 31;        % Tamaño del elemento estructurante para apertura
    
    % Parámetros de detección de bordes
    config.SobelThreshold       = [];        % Umbral para Sobel (vacío = automático)
    config.LoGThreshold         = [];        % Umbral para LoG (vacío = automático)
    config.CannyThreshold       = [0.1, 0.3];% Umbrales [low high] para Canny
    
    % Parámetros de selección de mejor detector
    config.circularityTol       = [0.98, 1.20]; % Tolerancia para circularidad
    config.axisRatioTol   = [0.97, 1.20];

    % Parámetros de decisión basados en pixeles del dataset
    config.tolPct               = 0.10;      % ±10% tolerancia sobre radio nominal
    config.R_ext_nom_px         = [];        % Se calcula en inicializarDataset
    config.tol_px               = [];        % Se calcula en inicializarDataset
    
    % Parámetros para HoughCircles
    config.houghSensitivity     = 0.90;      % Sensibilidad del detector de círculos
    
    % Parámetros para escenas sintéticas
    config.synthetic.canvasSize     = [480, 640];   % Tamaño del lienzo [alto, ancho]
    config.synthetic.numPiecesRange = [1, 5];       % Número de golillas en escena
    config.synthetic.probAnomaly    = 0.20;        % Probabilidad de usar golilla anómala
    
    % Verbose para debugging
    config.verbose              = true;
end
