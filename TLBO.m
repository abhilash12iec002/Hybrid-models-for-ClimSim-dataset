function bestfis=TLBO(fis,data,MaxItr,Population)
%
% Variables
p0=GettingFuzzyParameters(fis);
p0=abs(p0);
Problem.CostFunction=@(x) FuzzyCost(x,fis,data);
Problem.nVar=numel(p0);
alpha=1;
Problem.VarMin=-(10^alpha);
Problem.VarMax=10^alpha;

% TLBO Parameters
Params.MaxIt = MaxItr;% Maximum Number of Iterations
Params.nPop = Population ; % Population Size
%
% Starting TLBO Algorithm
results=Runtlbo(Problem,Params);
%
% Getting the Results
p=results.BestSol.Position.*p0;
bestfis=FuzzyParameters(fis,p);
end
%%----------------------------------------------
function results=Runtlbo(Problem,Params)
disp('Starting TLBO Algorithm Training');
%------------------------------------------------
% Cost Function
CostFunction=Problem.CostFunction;  
% Number of Decision Variables
nVar=Problem.nVar;   
% Size of Decision Variables Matrixv
VarSize=[1 nVar]; 
% Lower Bound of Variables
VarMin=Problem.VarMin;    
% Upper Bound of Variables
VarMax=Problem.VarMax;      
% Some Change
if isscalar(VarMin) && isscalar(VarMax)
dmax = (VarMax-VarMin)*sqrt(nVar);
else
dmax = norm(VarMax-VarMin);
end
%--------------------------------------------
% TLBO Algorithm Parameters
MaxIt=Params.MaxIt; % Maximum Number of Iterations
nPop=Params.nPop; 

%------------------------------------------------------
% Second Stage
% Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];
% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);
% Initialize Best Solution
BestSol.Cost = inf;
% Initialize Population Members
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
% Initialize Best Cost Record
BestCosts = zeros(MaxIt, 1);
%
%% TLBO Algorithm Main Body
%
for it = 1:MaxIt
% Calculate Population Mean
Mean = 0;
for i = 1:nPop
Mean = Mean + pop(i).Position;
end
Mean = Mean/nPop;
% Select Teacher
Teacher = pop(1);
for i = 2:nPop
if pop(i).Cost < Teacher.Cost
Teacher = pop(i);
end
end
% Teacher Phase
for i = 1:nPop
% Create Empty Solution
newsol = empty_individual;
% Teaching Factor
TF = randi([1 2]);
% Teaching (moving towards teacher)
newsol.Position = pop(i).Position ...
+ rand(VarSize).*(Teacher.Position - TF*Mean);
% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);
% Evaluation
newsol.Cost = CostFunction(newsol.Position);
% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end
% Learner Phase
for i = 1:nPop
A = 1:nPop;
A(i) = [];
j = A(randi(nPop-1));
Step = pop(i).Position - pop(j).Position;
if pop(j).Cost < pop(i).Cost
Step = -Step;
end
% Create Empty Solution
newsol = empty_individual;
% Teaching (moving towards teacher)
newsol.Position = pop(i).Position + rand(VarSize).*Step;
% Clipping
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);
% Evaluation
newsol.Cost = CostFunction(newsol.Position);
% Comparision
if newsol.Cost<pop(i).Cost
pop(i) = newsol;
if pop(i).Cost < BestSol.Cost
BestSol = pop(i);
end
end
end
% Store Record for Current Iteration
BestCosts(it) = BestSol.Cost;
% Show Iteration Information
disp(['In Iteration ' num2str(it) ': TLBO Best Cost = ' num2str(BestCosts(it))]);
end
%------------------------------------------------
disp('TLBO Algorithm Came To End');
% Store Res
results.BestSol=BestSol;
results.BestCost=BestCosts;
% Plot TLBO Training Stages
% set(gcf, 'Position',  [600, 300, 500, 400])
plot(BestCosts,'-',...
'LineWidth',1,...
'MarkerSize',4,...
'MarkerEdgeColor','k',...
'Color',[0.1,0.1,0.1]);
title('TLBO Algorithm Training')
xlabel('TLBO Iteration Number','FontSize',10,...
'FontWeight','bold','Color','k');
ylabel('TLBO Best Cost Result','FontSize',10,...
'FontWeight','bold','Color','k');
legend({'TLBO Algorithm Train'});
end


