clear;
clc;

pth = fullfile(fileparts(mfilename('fullpath')), '..');
addpath(pth);

% add FFT analysis lib
addpath(genpath(fullfile(pth, 'lib', 'FFT_fMRI_analysis')));
% add cpp repo
run ../lib/CPP_BIDS_SPM_pipeline/initCppSpm.m;

% get all the parameters needed
opt = getOptionBlock();

% check for dependencies are set right
checkDependencies();

%% FFT analysis

opt.anatMask = 0;
opt.FWHM = 0; % 3 or 6mm smoothing
% opt.stepSize = 4; % 2 or 4
opt.skullstrip.threshold = 0.5;

% create a whole brain functional mean image mask
% so the mask will be in the same resolution/space as the functional images
% one may not need it if they are running bidsFFX since it creates a
% mask.nii by default
opt.skullstrip.mean = 1;
opt.funcMask = bidsWholeBrainFuncMask(opt);

% % want to quickly change some parameters in opt?
% opt.space = 'MNI'; % 'individual', 'MNI'
% opt.subjects = {'011'};

opt.nStepsPerPeriod = 2;
calculateSNR(opt);
