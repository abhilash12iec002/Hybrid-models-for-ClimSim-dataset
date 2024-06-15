%% Bio Fuzzy Regression
%clc;
%clear;
%close all;

warning('off');
% Data Loading
data=JustLoad();
% Generate Fuzzy Model
% -------------------------------------
t_start=tic;
ClusNum=5; % Number of Clusters in FCM

% -------------------------------------
fis=GenerateFuzzy(data,ClusNum);
% -------------------------------------
%% Tarining Bio Algorithm

MaxItr=100; % Maximum Number of Iterations
Population=10; % Population Size

%%  Algorithm


%------------------------------------------
BioFis=IWO(fis,data,MaxItr,Population);        

%% Plot Fuzzy Bio Results (Train - Test)
% Train Output Extraction
TrTar=data.TrainTargets;
TrainOutputs=evalfis(data.TrainInputs,BioFis);
% Test Output Extraction
TsTar=data.TestTargets;
TestOutputs=evalfis(data.TestInputs,BioFis);
% Train calc
Errors=data.TrainTargets-TrainOutputs;
MSE=mean(Errors.^2);RMSE=sqrt(MSE);  
error_mean=mean(Errors);error_std=std(Errors);
% Test calc
Errors1=data.TestTargets-TestOutputs;
MSE1=mean(Errors1.^2);RMSE1=sqrt(MSE1);  
error_mean1=mean(Errors1);error_std1=std(Errors1);
mld_test=fitlm(data.TestTargets,TestOutputs);
R_value=sqrt(mld_test.Rsquared.Ordinary);
RMSE_value=mld_test.RMSE;
Bias_value=sum(TestOutputs-data.TestTargets)/length(TestOutputs);
t_total=toc(t_start);
% Train
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot(3,2,1);
% plot(data.TrainTargets,'c');hold on;
% plot(TrainOutputs,'k');legend('Target','Output');
% title('Bio Training Part');xlabel('Sample Index');grid on;
% % Test
% subplot(3,2,2);
% plot(data.TestTargets,'c');hold on;
% plot(TestOutputs,'k');legend('Bio Target','Bio Output');
% title('Bio Testing Part');xlabel('Sample Index');grid on;
% % Train
% subplot(3,2,3);
% plot(Errors,'k');legend('Bio Training Error');
% title(['Train MSE =     ' num2str(MSE) '  ,     Train RMSE =     ' num2str(RMSE)]);grid on;
% % Test
% subplot(3,2,4);
% plot(Errors1,'k');legend('Bio Testing Error');
% title(['Test MSE =     ' num2str(MSE1) '  ,    Test RMSE =     ' num2str(RMSE1)]);grid on;
% % Train
% subplot(3,2,5);
% h=histfit(Errors, 50);h(1).FaceColor = [.8 .8 0.3];
% title(['Train Error Mean =   ' num2str(error_mean) '  ,   Train Error STD =   ' num2str(error_std)]);
% % Test
% subplot(3,2,6);
% h=histfit(Errors1, 50);h(1).FaceColor = [.8 .8 0.3];
% title(['Test Error Mean =   ' num2str(error_mean1) '  ,   Test Error STD =    ' num2str(error_std1)]);

%% Plot Just Fuzzy Results (Train - Test)
% Train Output Extraction
fTrainOutputs=evalfis(data.TrainInputs,fis);
% Test Output Extraction
fTestOutputs=evalfis(data.TestInputs,fis);
% Train calc
fErrors=data.TrainTargets-fTrainOutputs;
fMSE=mean(fErrors.^2);fRMSE=sqrt(fMSE);  
ferror_mean=mean(fErrors);ferror_std=std(fErrors);
% Test calc
fErrors1=data.TestTargets-fTestOutputs;
fMSE1=mean(fErrors1.^2);fRMSE1=sqrt(fMSE1);  
ferror_mean1=mean(fErrors1);ferror_std1=std(fErrors1);
% Train
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot(3,2,1);
% plot(data.TrainTargets,'m');hold on;
% plot(fTrainOutputs,'k');legend('Target','Output');
% title('Fuzzy Training Part');xlabel('Sample Index');grid on;
% % Test
% subplot(3,2,2);
% plot(data.TestTargets,'m');hold on;
% plot(fTestOutputs,'k');legend('Target','Output');
% title('Fuzzy Testing Part');xlabel('Sample Index');grid on;
% % Train
% subplot(3,2,3);
% plot(fErrors,'g');legend('Fuzzy Training Error');
% title(['Train MSE =     ' num2str(fMSE) '   ,    Test RMSE =     ' num2str(fRMSE)]);grid on;
% % Test
% subplot(3,2,4);
% plot(fErrors1,'g');legend('Fuzzy Testing Error');
% title(['Train MSE =     ' num2str(fMSE1) '   ,    Test RMSE =     ' num2str(fRMSE1)]);grid on;
% % Train
% subplot(3,2,5);
% h=histfit(fErrors, 50);h(1).FaceColor = [.3 .8 0.3];
% title(['Train Error Mean =    ' num2str(ferror_mean) '   ,   Train Error STD =    ' num2str(ferror_std)]);
% % Test
% subplot(3,2,6);
% h=histfit(fErrors1, 50);h(1).FaceColor = [.3 .8 0.3];
% title(['Test Error Mean =    ' num2str(ferror_mean1) '   ,   Test Error STD =    ' num2str(ferror_std1)]);

%% Regression Plots
% figure('units','normalized','outerposition',[0 0 1 1])
% subplot(2,2,1)
% [population2,gof] = fit(TrTar,TrainOutputs,'poly3');
% plot(TrTar,TrainOutputs,'o',...
% 'LineWidth',1,...
% 'MarkerSize',6,...
% 'MarkerEdgeColor','g',...
% 'MarkerFaceColor',[0.9,0.1,0.1]);
% title(['Bio Train - R =  ' num2str(1-gof.rmse)]);
% xlabel('Train Target');
% ylabel('Train Output');   
% hold on
% plot(population2,'b-','predobs');
% xlabel('Train Target');
% ylabel('Train Output');   
% hold off
% subplot(2,2,2)
% [population2,gof] = fit(TsTar, TestOutputs,'poly3');
% plot(TsTar, TestOutputs,'o',...
% 'LineWidth',1,...
% 'MarkerSize',6,...
% 'MarkerEdgeColor','g',...
% 'MarkerFaceColor',[0.9,0.1,0.1]);
% title(['Bio Test - R =  ' num2str(1-gof.rmse)]);
% xlabel('Test Target');
% ylabel('Test Output');    
% hold on
% plot(population2,'b-','predobs');
% xlabel('Test Target');
% ylabel('Test Output');
% hold off
% subplot(2,2,3)
% [population2,gof] = fit(TrTar,fTrainOutputs,'poly3');
% plot(TrTar,fTrainOutputs,'o',...
% 'LineWidth',1,...
% 'MarkerSize',6,...
% 'MarkerEdgeColor','b',...
% 'MarkerFaceColor',[0.3,0.9,0.2]);
% title(['Fuzzy Train - R =  ' num2str(1-gof.rmse)]);
% xlabel('Train Target');
% ylabel('Train Output');   
% hold on
% plot(population2,'r-','predobs');
% xlabel('Train Target');
% ylabel('Train Output');   
% hold off
% subplot(2,2,4)
% [population2,gof] = fit(TsTar, fTestOutputs,'poly3');
% plot(TsTar, fTestOutputs,'o',...
% 'LineWidth',1,...
% 'MarkerSize',6,...
% 'MarkerEdgeColor','b',...
% 'MarkerFaceColor',[0.3,0.9,0.2]);
% title(['Fuzzy Test - R =  ' num2str(1-gof.rmse)]);
% xlabel('Test Target');
% ylabel('Test Output');    
% hold on
% plot(population2,'r-','predobs');
% xlabel('Test Target');
% ylabel('Test Output');
% hold off
%% Errors
% Fuzzy Regression Train and Test Errors
% Train
fprintf('////////////////////////////////////////////////\n');
fprintf('Fuzzy Regression Training "MSE" Is =  %0.4f.\n',fMSE)
fprintf('Fuzzy Regression Training "RMSE" Is =  %0.4f.\n',fRMSE)
%  fprintf('Fuzzy Regression Training "Mean Error" Is =  %0.4f.\n',ferror_mean)
%  fprintf('Fuzzy Regression Training "STD Error" Is =  %0.4f.\n',ferror_std)
fprintf('Fuzzy Regression Training "MAE" Is =  %0.4f.\n',mae(data.TrainTargets,fTrainOutputs))
% Test
fprintf('Fuzzy Regression Testing "MSE" Is =  %0.4f.\n',fMSE1)
fprintf('Fuzzy Regression Testing "RMSE" Is =  %0.4f.\n',fRMSE1)
%  fprintf('Fuzzy Regression Testing "Mean Error" Is =  %0.4f.\n',ferror_mean1)
%  fprintf('Fuzzy Regression Testing "STD Error" Is =  %0.4f.\n',ferror_std1)
fprintf('Fuzzy Regression Testing "MAE" Is =  %0.4f.\n',mae(data.TestTargets,fTestOutputs))
fprintf('////////////////////////////////////////////////\n');

% Bio Regression Algorithm Train and Test Errors
% Train
fprintf('Bio Regression Training "MSE" Is =  %0.4f.\n',MSE)
fprintf('Bio Regression Training "RMSE" Is =  %0.4f.\n',RMSE)
%  fprintf('Bio Regression Training "Mean Error" Is =  %0.4f.\n',error_mean)
%  fprintf('Bio Regression Training "STD Error" Is =  %0.4f.\n',error_std)
fprintf('Bio Regression Training "MAE" Is =  %0.4f.\n',mae(data.TrainTargets,TrainOutputs))
% Test
fprintf('Bio Regression Testing "MSE" Is =  %0.4f.\n',MSE1)
fprintf('Bio Regression Testing "RMSE" Is =  %0.4f.\n',RMSE1)
%  fprintf('Bio Regression Testing "Mean Error" Is =  %0.4f.\n',error_mean1)
%  fprintf('Bio Regression Testing "STD Error" Is =  %0.4f.\n',error_std1)
fprintf('Bio Regression Testing "MAE" Is =  %0.4f.\n',mae(data.TestTargets,TestOutputs))
fprintf('////////////////////////////////////////////////\n');

% _________________________________________________________________________ 
%% Normalized Errors
% Train
trr1=rescale(TrainOutputs);
trr2=rescale(TrTar);
trmse=mse(trr1,trr2);
Traincorrcoef = corr(trr1,trr2);
mdltr = fitlm(TrTar,TrainOutputs);
TrRsquared=mdltr.Rsquared.Ordinary;
% Test
tsr1=rescale(TestOutputs);
tsr2=rescale(TsTar);
tsmse=mse(tsr1,tsr2);
Testcorrcoef = corr(tsr1,tsr2);
mdlts = fitlm(TsTar, TestOutputs);
TsRsquared=mdlts.Rsquared.Ordinary;
% Normalized
fprintf('Bio Normalized Train "MSE" =  %0.4f.\n',trmse)
fprintf('Bio Normalized Test "MSE" =  %0.4f.\n',tsmse)
fprintf('Bio Normalized Train "RMSE" =  %0.4f.\n',sqrt(trmse))
fprintf('Bio Normalized Test "RMSE" =  %0.4f.\n',sqrt(tsmse))
fprintf('Bio Train Correlation Coefficient Is =  %0.4f.\n',Traincorrcoef)
fprintf('Bio Test Correlation Coefficient Is =  %0.4f.\n',Testcorrcoef)
fprintf('Bio Train Rsquared Is =  %0.4f.\n',TrRsquared)
fprintf('Bio Test Rsquared Is =  %0.4f.\n',TsRsquared)
