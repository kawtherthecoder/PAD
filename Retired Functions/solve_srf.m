% Run after first cells of EVA_calibration.m (up to '%% resample SRF')

% clear;
addpath .. % adds select_panels function to path

%% I/O
panel_photo = '\\files.brown.edu\Home\krouabhi\Documents\PAD Research\Cal Panels\2019_0819_184741_009.TIF';

%% Select colors
panel_colors = {'white','black','brown','tan','green','purple','yellow'...
    'blue-pale','red','pink','blue-dark','grey','orange'};
RGN_stretch=imread(panel_photo);
% h=imshow(RGN_stretch);

%% select panel pixels
panel = select_all_panels(RGN_stretch, panel_colors);

%% Make matrix of panels in RGN (matrix C)
% Make sure RGN is actually correct order of camera bands, so I don't get
% confused...

C = [[panel.meanValueR]', [panel.meanValueG]', [panel.meanValueN]'];

%% Make matrix of spectra (matrix B)
A = spect(:,[1:13])'; % and so on...

%% Solve inverse matrix problem (many unique solutions, I think)
% Try also mldivide, or linsolve for more control over parameters
B = A \ C; 
