function data=JustLoad()

%ds = tabularTextDatastore("train.csv");
%ds.ReadSize = 10091520;
% train=readall(ds,UseParallel=true); % For parallel computing
a=6250000;
%tr=[train(:,2) train(:,62) train(:,122) train(:,182) train(:,242) train(:,302) train(:,362:378) train(:,438) train(:,498)];
%tr=[train(:,2) train(:,62) train(:,438) train(:,498)];
load('tr_0.mat');
tr=rescale(table2array(tr));
xx=tr(1:a,:);
ts=tr(a+1:end,:);
%yr=table2array(train(:,918));
load('yr.mat')
yy=yr(1:a,:);
obs=yr(a+1:end,:);


data.Inputs=tr;
data.Targets=yr;
Inputs=data.Inputs;
Targets=data.Targets;
nSample=size(Inputs,1);

% Shuffle Data
S=randperm(nSample);
Inputs=Inputs(S,:);
Targets=Targets(S,:);

% Train Data
pTrain=0.70;
nTrain=round(pTrain*nSample);
TrainInputs=Inputs(1:nTrain,:);
TrainTargets=Targets(1:nTrain,:);
% Test Data
TestInputs=Inputs(nTrain+1:end,:);
TestTargets=Targets(nTrain+1:end,:);
% Export
data.TrainInputs=TrainInputs;
data.TrainTargets=TrainTargets;
data.TestInputs=TestInputs;
data.TestTargets=TestTargets;
end