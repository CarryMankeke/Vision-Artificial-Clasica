% analizarTrainDatasetStandalone.m
% Script autónomo para analizar ~1000 PNG de train/conform
% y calcular límites estadísticos de métricas geométricas.
clc; clear; close all;
% Ajusta esta ruta a tu carpeta local del dataset
datasetPath = 'C:\Users\camil\OneDrive\Escritorio\washer_detection\archive\simplified-washers-for-anomaly-detection';
trainFolder = fullfile(datasetPath, 'train', 'conform');

% Listar archivos PNG
dirInfo = dir(fullfile(trainFolder, '*.png'));
numFiles = numel(dirInfo);

% Prealocar vectores de métricas
circ_vals = nan(numFiles,1);
ar_vals   = nan(numFiles,1);
Rext_vals = nan(numFiles,1);

% Parámetros de preprocesamiento
gaussSigma = 1.5;

% Bucle sobre cada imagen
dataIdx = 0;
for i = 1:numFiles
    % Leer en gris
    I = imread(fullfile(trainFolder, dirInfo(i).name));
    if ndims(I)==3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end
    % Suavizar
    Iproc = imgaussfilt(Igray, gaussSigma);
    % Umbral adaptativo y relleno\    
    BW = imbinarize(Iproc, 'adaptive', 'Sensitivity', 0.4, 'ForegroundPolarity', 'dark');
    BW = imfill(BW, 'holes');
    % Seleccionar componente mayor
    CC = bwconncomp(BW);
    statsA = regionprops(CC, 'Area');
    if isempty(statsA)
        continue;
    end
    areas = [statsA.Area];
    [~, idxMax] = max(areas);
    mask = labelmatrix(CC)==idxMax;
    % Obtener propiedades geométricas
    st = regionprops(mask, 'Area','Perimeter','MajorAxisLength','MinorAxisLength','EquivDiameter');
    % Asumir primer objeto
    area  = st(1).Area;
    perim = st(1).Perimeter;
    circ_vals(i) = 4*pi * area / (perim^2);
    ar_vals(i)   = st(1).MajorAxisLength / st(1).MinorAxisLength;
    Rext_vals(i) = st(1).EquivDiameter / 2;
    dataIdx = dataIdx + 1;
end

% Eliminar entradas vacías
circ_vals = circ_vals(~isnan(circ_vals));
ar_vals   = ar_vals(~isnan(ar_vals));
Rext_vals = Rext_vals(~isnan(Rext_vals));

% Calcular estadísticas básicas
meanCirc = mean(circ_vals); stdCirc = std(circ_vals);
meanAR   = mean(ar_vals);   stdAR   = std(ar_vals);
meanR    = mean(Rext_vals); stdR    = std(Rext_vals);

% Límites ±3σ
limits.circularity = meanCirc + [-3, 3]*stdCirc;
limits.axisRatio   = meanAR   + [-3, 3]*stdAR;
limits.Rext        = meanR    + [-3, 3]*stdR;

% Mostrar resultados
fprintf('Circularity: mean=%.4f, std=%.4f, limits=[%.4f, %.4f]\n', meanCirc, stdCirc, limits.circularity);
fprintf('AxisRatio : mean=%.4f, std=%.4f, limits=[%.4f, %.4f]\n', meanAR, stdAR, limits.axisRatio);
fprintf('R_ext (px): mean=%.2f,  std=%.2f,  limits=[%.2f, %.2f]\n',      meanR,   stdR,   limits.Rext);

% Graficar histogramas
figure;
tiledlayout(1,3);
nexttile; histogram(circ_vals, 50); title('Circularity');
nexttile; histogram(ar_vals,   50); title('Axis Ratio');
nexttile; histogram(Rext_vals, 50); title('R_{ext} (px)');
