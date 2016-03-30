# Texture Classification
  
In this section, we will implement some interesting parts of the following  
  
#####paper:
#####Cula, O. G. and K. J. Dana: 2004,  
#####3D Texture Recognition Using Bidirectional Feature Histograms.  
#####International Journal of Computer Vision 59(1).  
  
Texture classification is an interesting problem in vision since many objects we would like to recognize have distinctive textures (such as zebras, pedestrian crossings and chess boards). The first section of the paper gives a broad outline of the most recent work in texture classification. Reading this part is extremely optional, but is recommended, especially if your research is related to texture. This paper uses the CURET database, which you may want to look at if you have some free time. It is at http://www1.cs.columbia.edu/CAVE/curet/. In this assignment, some of the images will also come from the BRODATZ database, which is also online at http://www.ux.his.no/tranden/brodatz.html  
  
###Part 1 Gabor Filters
  
Gabor filters have become popular as it has been shown recently that simple cells in the primary visual cortex can be modeled by Gabor functions.  
A 2D Gabor function g(x, y) is a 2D Gaussian modulated with a complex exponential (sinusoidal) and is given as:  
  
**g(x, y) = (1/(2*pi*σx*σy))*exp(complex(-1/2*(x^2/σx^2+y^2/σy^2),2*pi*W*x));**
  
A Gabor filter bank is a series of Gabor filters at various scales and orientations (which means they have different values for the inputs in the function above). Applying each of these to the image gives a response at each pixel, for each filter in the bank. The constant W determines the frequency bandwidth of the filters, use W = 0.52. The above representation of a Gabor function simply combines in a single function  
  
Let g(x, y) be the mother wavelet, then the self-similar filter bank can be obtained by appropriate dilations and rotations of g(x, y) through the generating function as: 
  
g_mn (x, y) = a^(−m) * g(x0, y0),  
a > 1,  
m = 0, ... , (S−1),  n = 0, ... ,(K-1)
  
x0 = a^(−m)*(xcosθ+ysinθ) and y0 = a^(−m)(−xsinθ+ycosθ)  
where a is the scale parameter, angle θ = nπ/K, S is the total number of scales and K is the total number of orientations. We can define a certain family of filters by choosing low and high frequencies, Ul and Uh to define the band within which we are interested in working. We must also choose a scale factor, a, and the variances along the x and y axes, σx and σy . The Gabor filters can be shown to form a nonorthogonal basis, which implies that there is redundant information in the filtered images. It is possible to design the Gabor filter bank gmn (x, y) such that the tiling of the frequency space reduces these redundancies.
  
Note: There is nothing inherently intuitive about the following parameter values they are just provided here to help you implement the Gabor filter.  
  
For design purposes, you can choose S to be any number between 4 and 10 (we chose 10) and K to be between 8 and 12 (we chose 10). The values of center frequencies Uh and Ul can be chosen as 0.4 and 0.1 respectively. What you need to do now is to write the following 
  
function:   
**[vectors] = extractResponseVectors(Image)**
  
The extractResponseVectors function should take any Image and apply the Gabor filter bank onto it. vectors is an MxN matrix, where N is the number of Gabor filters in the bank and M is the total numbers of pixels in an image.  
When you see the Garbor function g(x, y) you can notice that the function has defined on complex plane. Don’t panic. You can split g(x, y) by real part and complex part, and calculate filter for each part. After that, just calculate the magnitude and you could get the filtered result.  
  
####Part 2 The Texton Library
  
In this section you will use the random textures directory that we have given you.  
Each pixel in an image will give a vector of responses to the Gabor filter bank. The length of this vector will be the number of filters you create in the bank. The next thing you will write is a script:
createTextonLibrary In this script, you will use the extractResponseVector command you made to extract a vector of responses to the Gabor filter, from every pixel in each image
contained in the random image directory. The point of the texton library is to approximate all the variety of textures that occur in the real world with a finite set of textons. You have already written code to extract response vectors from an image. Now you will run this function on all the images in the random directory to create a giant matrix of response vectors. Each row of the matrix is a response vector that you extracted using the Gabor filter, from some pixel in some image in the random directory. You should now cluster this giant matrix of intensity vectors using the BUILT-IN Matlab command:  
  
**[clusterresult clustercenters] =**  
**  kmeans(GiantFeatureMatrix,NumberofClusters,EmptyAction,drop)  **
  
The EmptyAction bit means that if you input too large a k, then redundant cluster centers are dropped. clustercenters are the centers of the groups that kmeans has found in your GiantFeatureMatrix. Our main hope/assumption is that these centers capture what it means to be a texture that belongs to that class. Specifying a good value of k is actually a very hard question in machine learning. We suggest using a k between 8-25. If you change the number of clusters, then you will
affect the whole classification. Therefore a design decision for you is the value of N umberof Clusters.  
For both your and our convenience, store your database in a Matlab data file called TextureLibrary.mat. When you load this file into Matlab, you should get a matrix of textons in the workspace called TextonLibrary. PLEASE KEEP the variable name as directed. This matrix should be an MxN matrix, with M being the number of clusters you use
and N is the number of filters in the filter bank.
  
####Part 3 Using Training Images  
  
Once you have the texton library, you can start to train images.   Training images are also located in the zip file that you will download. There are 5 classes and the directories are named after each class. Each directory is filled with textures of a certain kind. For example the trainGrass directory has grass images.  
When you first read a training image, you should extract the response vectors at each pixel from it, using extractResponseVectors. What you will do now is to use the information in the paper to create the following script:  
**createHistogram**
  
In this script, you will open a class directory (say Grass), and compute all the response vectors for every image in that class. You will NOT need to store all of the response vectors you compute. Instead you will keep a record of which textons from the texton library were important in describing that class. This record is a
histogram. Generally, a histogram is represented as a 2-dimensional graph. The yaxis is usually some measure of count. Note that you can use the Matlab function named hist if you wish, but it is not necessary.   
For your own convenience, and for grading purpose, create a Matlab data file called Histograms.mat. When you load this file into Matlab, you should get many 1-dimensional vectors (Nx1) loaded into the workspace. These vectors are the histograms. Each histogram should be named after a class. For example there will be a Grass histogram which
refers histogram of canavas and a Straw histogram which refers histogram of straw.  

####Part 4 Classification  
  
After the above section you will be able to take a single test image and create its histogram by using the texton library. Create a function:  
**[class] = classify(im)**
  
This function creates a histogram for the input image, and figures out which class this image belongs to, using the texton library. The output should be a string of the directory name of the class. For example, if the classify result is Grass, the return value should be ’Grass’.
