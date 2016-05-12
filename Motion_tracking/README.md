# Motion tracking
  
####The goal of this project is to implement a tracker for estimating dominant affine motion in a sequence of images and subsequently identify pixels corresponding to moving objects in the scene.  

The input images are consisting of aerial views of moving vehicles from a non-stationary camera.  

There are **two parts** in this project.  

**First part** implements motion detector based on Lucas-Kanade algorithm. It detect dominant motion between two images.  

**Second part** is template tracker. It tracks the template which user choose until it loose the template.  

You can find the result movie and images of each part in the 'result' folder.   

####Part 1 : Motion detector

*SubtrackDominantMotion* extract dominant motion between two images using Lucas-Kanade algorithm. *test_motion* just call this function with successive image pair and then make the result as a movie file.  

You can implement with this command, where *numimages* is the number of images you want to implement :  
*test_motion('../data/frames', numimages);*

####Part 2 : Template tracker

*trackTemplate* tracks the template which user choose in the following consecutive images. It solves the least square to minimize error of optical flow constraint and to find the best motion *(u,v)*. To respond better for fast motion, images are smoothed using gaussian filter. So it needs the input of sigma value for the gaussian filter. I recommend to use 4 for input sigma.  

You can implement using this command :  
*trackTemplate('../data/frames', sigma);*









