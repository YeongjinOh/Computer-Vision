# Homography
  
####The goal of this project is to explore Transformation Matrix and Image Warping.

In this project, I consider a vision application in which a scene is being observed by multiple cameras at various locations and orientations.  

Given two cameras, a natural thing to do would be to compute how the scene currently seen from camera 1 would appear from camera 2’s point of view. In particular, this would allow one to paste together multiple images which have over-lapping regions, even if those images were obtained from different locations. This is also called Mosaicing.  

An image mosaic is created by first choosing one camera as the reference frame and its associated image as the reference image. The task then consists of mapping all other images onto the reference frame so that all images can be displayed together with the reference image. In the most general case, there would be no constraints on the scene geometry, making the problem quite hard to solve. If, however, the scene can be approximated by a plane in 3D, a solution can be formulated much more easily even without the knowledge of camera calibration parameters.   

This project is divided into **two parts**. First derives the transformation that maps one image onto another in the planar scene case. Then finds this warping and apply it to two pairs of test images, which are provided in src folder. The warped and merged outputs are in result folder.  

####Part 1 : Estimating transformations from the image points

The function in *computeH.m* computes the projective transformation matrix *H*, called homography, using the input arrays(t1, t2) whose size of 2 by N. t2 is the list of points in reference image. t1 is the list of points in the other image corresponding to the point in t2.  

The corresponding point pairs of 'wdc#.jpg' are contained in *points.m* as points1, points2. you can use this fuction as :  
*H = computeH(points1, points2)*  


####Part 2 : Image warping and mosaicing

The function *warpImage* takes as input an image Iin, a reference image Iref, and a 3 × 3 homography, and returns 2 images as outputs. The first image is Iwarp, which is the input image Iin warped according to *H* to be in the frame of the reference image Iref. The second output image is Imerge, a single mosaic image with a larger field of view containing both the input images.  

In the directory *'src'*, read input images and run this function using following codes:  
*Iin = imread('wdc1.jpg');*  
*Iref = imread('wdc2.jpg');*  
*[Iwarp, Imerge] = warpImage(Iin, Iref, H);*  







