clear all
close all
format compact
clc

% script to calculate the statistics for each scan given this will currently only run if distances have been measured
% for all included scans (UsedSets)

% modify the path to evaluate your models
dataPath='/home1/datasets/Database/DTU/SampleSet';
resultsPath='/home2/wangshaoqian/home2/wangshaoqian/wsq/MVS/cascade/CasMVSNet/ET-MVSNet-main/MVS4Net_CSNew_feature_up_cost_up_ori_model_depth321684_inter21105_train_aga_trainset_gather_oldloss_notlarge_feature_up_usinglast_noDY_IN_aug_e13_1_2_040/';
% resultsPath='/home2/wangshaoqian/home2/wangshaoqian/wsq/MVS/Patchmatch/PatchmatchNet-main/outputs/';
MaxDist=20; %outlier thresshold of 20 mm

time=clock;

method_string='mvsnet';
light_string='l3'; %'l7'; l3 is the setting with all lights on, l7 is randomly sampled between the 7 settings (index 0-6)
representation_string='Points'; %mvs representation 'Points' or 'Surfaces'

switch representation_string
    case 'Points'
        eval_string='_Eval_'; %results naming
        settings_string='';
end

% get sets used in evaluation
UsedSets=[1 4 9 10 11 12 13 15 23 24 29 32 33 34 48 49 62 75 77 110 114 118];

nStat=length(UsedSets);

BaseStat.nStl=zeros(1,nStat);
BaseStat.nData=zeros(1,nStat);
BaseStat.MeanStl=zeros(1,nStat);
BaseStat.MeanData=zeros(1,nStat);
BaseStat.VarStl=zeros(1,nStat);
BaseStat.VarData=zeros(1,nStat);
BaseStat.MedStl=zeros(1,nStat);
BaseStat.MedData=zeros(1,nStat);

for cStat=1:length(UsedSets) %Data set number
    currentSet=UsedSets(cStat);
    %input results name
    EvalName=[resultsPath method_string eval_string num2str(currentSet) '.mat'];

    disp(EvalName);
    load(EvalName);

    Dstl=data.Dstl(data.StlAbovePlane); %use only points that are above the plane
    Dstl=Dstl(Dstl<MaxDist); % discard outliers

    Ddata=data.Ddata(data.DataInMask); %use only points that within mask
    Ddata=Ddata(Ddata<MaxDist); % discard outliers

    BaseStat.nStl(cStat)=length(Dstl);
    BaseStat.nData(cStat)=length(Ddata);

    BaseStat.MeanStl(cStat)=mean(Dstl);
    BaseStat.MeanData(cStat)=mean(Ddata);

    BaseStat.VarStl(cStat)=var(Dstl);
    BaseStat.VarData(cStat)=var(Ddata);

    BaseStat.MedStl(cStat)=median(Dstl);
    BaseStat.MedData(cStat)=median(Ddata);

    disp("acc");
    disp(mean(Ddata));
    disp("comp");
    disp(mean(Dstl));
    time=clock;
end

disp(BaseStat);
disp("mean acc")
acc_mean = mean(BaseStat.MeanData);
disp(acc_mean);
disp("mean comp")
comp_mean = mean(BaseStat.MeanStl);
disp(comp_mean);
disp("mean overall")
overall_mean = (acc_mean + comp_mean)/2;
disp(overall_mean)

totalStatName=[resultsPath 'TotalStat_' method_string eval_string '.mat']
save(totalStatName,'BaseStat','time','MaxDist');

totalStatName=[resultsPath 'TotalStat_' method_string eval_string '.txt']
fp=fopen(totalStatName,'a');
fprintf(fp,'%f\n',mean(BaseStat.MeanData));
fprintf(fp,'%f\n',mean(BaseStat.MeanStl));
fprintf(fp,'%f\n',overall_mean);



