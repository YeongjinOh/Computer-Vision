cd('C:\Users\SNU\Desktop\Problem\YOURCODE');
clc;clear;
max = 0;
for a = 1:0.5:4
    k=25;
    sum = 0;
    for i=1:10
    display(sprintf('k = %d',k));
    TextonLibrary = getTextonLibrary(k);
    Canvas_histogram = get_histogram('Canvas',TextonLibrary,k);
    Chips_histogram = get_histogram('Chips',TextonLibrary,k);
    Grass_histogram = get_histogram('Grass',TextonLibrary,k);
    Seeds_histogram = get_histogram('Seeds',TextonLibrary,k);
    Straw_histogram = get_histogram('Straw',TextonLibrary,k);
    save TextureLibrary.mat TextonLibrary
    save Histograms.mat Canvas_histogram Chips_histogram Grass_histogram Seeds_histogram Straw_histogram
    
    acc = test_myself(k);
    
    if max < acc
        max = acc;
        save sprintf('Max.mat') k  TextonLibrary  Canvas_histogram Chips_histogram Grass_histogram Seeds_histogram Straw_histogram
        
    end
        sum = sum + acc;
    end
        avg = sum/10;
        display(sprintf('avg of k(%d) = %d', k, avg));
        save(sprintf('avg%d.mat',k),'avg');

end
