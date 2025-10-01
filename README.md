TipTrack is a MATLAB based toolkit that extracts center lines and tip locations of fluorescent slender structures and computes length time traces with high precision

This package is developed by Sabyasachi Sutradhar. This MATLAB based package can precisely calculate the length and tip locations of fluorescently labeled filamentous (slender) structures. 
Copyright: Sabyasachi Sutradhar (Sabyasachi.sutradhar@yale.edu), 2022
Installation: This package does not need any installation. Just download it and then keep it on local computer. However, MATLAB is necessary with Image Processing Toolbox, Statistics Toolbox, Curve fitting Toolbox etc.
Example To run the code: 
%% Set some initial paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
workdir=pwd;
logdir='CREATE and PUT the LOCATION of a LOG directory';
trackdir='LOCATATION of the folder TipTrack_v3/';
filename="YOUR FILE NAME WITH LOCATION ";
addpath(genpath(trackdir));
%% SET PARAMETERS
params.filter_box_size=15;%%box size for filtering your image
params.threshold_branchlength=3;%%remove branch less than this length
params.areathreshold=10;%%%%%%%% remove detected object less than this
%% TRACKING your tip
global fid
Tip=Scan_Video(strcat(datadir,filename),params,logdir);
Data output:  
Output contains data of all the detected tips in a 1xn_frame cell. Each cell contains a structure with x-y coordinates of the tip, end locations and length in pixels. For example, Tip{1}.xy will provide the x-y coordinates along the backbones of the detected tip in frame 1 of the time-lapse movie.
Tip-tracking algorithm
To quantify the dynamical properties of the tips, we developed an in-house algorithm to track dendritic tips and determine dendrite length-time curves 
	To track the growing and shrinking tips, the algorithm determined the longitudinal centerline of the terminal dendrite and the location of its end for each frame. The central line was computed by fitting Gaussians to the cross-sectional intensity profiles at regular intervals along the backbone of the dendrite using:


<img width="339" height="52" alt="image" src="https://github.com/user-attachments/assets/376b4066-9d3b-496b-bdb3-a4841985d1b1" />

(Demchouk et al., 2011) where  is the position along a normal to the dendrite,  is the peak intensity value,  is the center of the Gaussian,  is the standard deviation and  is the measured camera offset (100) plus the background fluorescence. To compute the location of the tip, (, we fit a 2-dimensional Gaussian function convolved with an error function using (Demchouk et al., 2011):

<img width="633" height="71" alt="Screenshot 2025-10-01 at 11 07 27 AM" src="https://github.com/user-attachments/assets/40b3bb30-02bb-48f4-ba28-2d896789f24e" />

where  is the peak intensity,  is the angular direction of the tip, and  and  are the standard deviations along the orthogonal and parallel directions. The length of the dendrite in each frame was determined by fitting the center line and the tip with a cubic spline. Length-time traces were smoothed with a median filter of size 3 to remove glitches.
	To estimate the precision of our tracking algorithm, we used two different approaches. In the first, we tracked synthetic images of capped cylindrical tubes of known length and radius with fluorophores placed randomly on their surfaces (10% labeling density) and convolved with a point spread function (350 nm FWHM). To ensure that our algorithm could perform robustly under a wide range of signal-to-background ratios, we tested the tracking accuracy with decreasing signal to background ratios. The typical precision was ≪1 pixel (100 nm) even for low signal-to-background ratios (Ruhnow et al., 2011). (ii) We tracked the position of in-vivo dendritic tips that are in long-term paused states and found that the average standard deviation of length was ~0.1 μm (< 1 pixel, 0.1615 μm. This accuracy is comparable to and, in some cases, better than available software, such as, FIESTA (Ruhnow et al., 2011), JFilament (Smith et al., 2010b), and Simple Neurite Tracer (Longair et al., 2011). Using a parallelized method, several hundred tips can be tracked simultaneously. A caveat of our method is that it can only track filaments that are reasonably free of extraneous objects, excessive noise, and have no breaks, discontinuities, or overlapping segments.



