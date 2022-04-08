function [net1,ps1,ts1,angledesign,radiusdesign,thicknessdesign,diameterdesign,curnet,curps,curts,curnum]=getpopinfo
%% load pretrained network
load('pretrained_network\GABPnet.mat')
load('pretrained_network\GABPps.mat')
load('pretrained_network\GABPts.mat')
net1=net;
ps1=ps;
ts1=ts;

load('pretrained_network\grunet.mat');
load('pretrained_network\gruinputs.mat');
load('pretrained_network\gruputputs.mat');

curnet=net;
curps=inputps;
curts=outputps;
% curnet.Layers

%% design parameter

diameterdesign=50;
thicknessdesign=3;

angledesign=60;
radiusdesign=150;

