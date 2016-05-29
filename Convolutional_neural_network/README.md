# Convolutional Neural Network
 
#### In this project, I implemented CNN learning on 8x8 patches sampled from images from the STL-10 dataset for classifying images.
The reduced STL-10 dataset comprises 64x64 images from 4 classes (airplane, car, cat, dog).
In *cnnExercise.m*, it first trains 2000 images in *stlTrainSubset.mat*. And then, using trained model, it predicts which class given test image belongs to through 3200 test images in *stlTestSubset.mat*. The accuracy is around 80%.  

You can check the result by running *cnnExercise.m* script.
