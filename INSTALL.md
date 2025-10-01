# Installation and setup

This package requires MATLAB with the following toolboxes
- Image Processing  
- Statistics and Machine Learning  
- Curve Fitting

There is no separate installation step Place the folder on your local machine and add it to the MATLAB path

## Steps

1. Download or clone the repository to a local folder  
2. Start MATLAB  
3. Add the folder to the path with subfolders

```matlab
trackdir = 'PATH TO TipTrack_v3 FOLDER';
addpath(genpath(trackdir));
savepath;    % optional
```

4. Prepare a folder for logs with write permission  
5. Prepare your data folder and a file name for the movie or image stack  
6. Run the example below

```matlab
workdir = pwd;
datadir = 'PATH TO YOUR DATA FOLDER';
logdir = 'PATH TO A WRITEABLE LOG FOLDER';
trackdir = 'PATH TO TipTrack_v3 FOLDER';
filename = 'YOUR FILE NAME WITH EXTENSION';

addpath(genpath(trackdir));

params.filter_box_size = 15;
params.threshold_branchlength = 3;
params.areathreshold = 10;

global fid
Tip = Scan_Video(fullfile(datadir, filename), params, logdir);
```

## Notes and caveats

- The algorithm assumes reasonably clean filaments without strong occlusions discontinuities or heavy overlap  
- For best performance ensure good signal to background ratio and appropriate exposure  
- If you process many tips consider MATLAB parallel pool

## Support

For questions contact Sabyasachi dot Sutradhar at yale dot edu
