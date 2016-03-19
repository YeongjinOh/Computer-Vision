cd('C:\Users\SNU\Desktop\Problem\YOURCODE');
clc;clear;
k = 14;
TextonLibrary = getTextonLibrary(k);
Canvas_histogram = get_histogram('Canvas',TextonLibrary,k);
Chips_histogram = get_histogram('Chips',TextonLibrary,k);
Grass_histogram = get_histogram('Grass',TextonLibrary,k);
Seeds_histogram = get_histogram('Seeds',TextonLibrary,k);
Straw_histogram = get_histogram('Straw',TextonLibrary,k);
save TextureLibrary.mat TextonLibrary
save Histograms.mat Canvas_histogram Chips_histogram Grass_histogram Seeds_histogram Straw_histogram
cd('../');
testClassifier;
    