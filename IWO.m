function bestfis=IWO(fis,data,MaxItr,Population)

% Variables
p0=GettingFuzzyParameters(fis);
Problem.CostFunction=@(x) FuzzyCost(x,fis,data);
Problem.nVar=numel(p0);
alpha=1;
Problem.VarMin=-(10^alpha);
Problem.VarMax=10^alpha;

%% Parameters

Params.MaxIt = MaxItr;         % Maximum Number of Iterations
Params.nPop0 = Population;     % Initial Population Size
Params.nPop = Population;      % Maximum Population Size
Params.Smin = 0;       % Minimum Number of Seeds
Params.Smax = 2;       % Maximum Number of Seeds
Params.Exponent = 2;           % Variance Reduction Exponent
Params.sigma_initial = 0.5;    % Initial Value of Standard Deviation
Params.sigma_final = 0.001;	% Final Value of Standard Deviation

% Starting IWO Algorithm
results=RunIWOFCN(Problem,Params);
% Getting the Results
p=results.BestSol.Position.*p0;
bestfis=FuzzyParameters(fis,p);
end

function results=RunIWOFCN(Problem,Params)
disp('Starting IWO Algorithm Training');
% Cost Function
CostFunction=Problem.CostFunction;  % Number of Decision Variables
nVar=Problem.nVar;   % Size of Decision Variables Matrixv
VarSize=[1 nVar]; % Lower Bound of Variables
VarMin=Problem.VarMin;   % Upper Bound of Variables
VarMax=Problem.VarMax;      % Some Change
if isscalar(VarMin) && isscalar(VarMax)
dmax = (VarMax-VarMin)*sqrt(nVar);
else
dmax = norm(VarMax-VarMin);
end


%% Initialization

MaxIt =Params.MaxIt;         
nPop0 =Params.nPop0;   
nPop =Params.nPop;    
Smin =Params.Smin;      
Smax =Params.Smax;        
Exponent =Params.Exponent;          
sigma_initial =Params.sigma_initial;   
sigma_final =Params.sigma_final;	 

% Empty Plant Structure
empty_plant.Position = [];
empty_plant.Cost = [];

pop = repmat(empty_plant, nPop0, 1);    % Initial Population Array

for i = 1:numel(pop)

% Initialize Position
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);

% Evaluation
pop(i).Cost = CostFunction(pop(i).Position);

end

% Initialize Best Cost History
BestCosts = zeros(MaxIt, 1);

%% IWO Main Loop

for it = 1:MaxIt

% Update Standard Deviation
sigma = ((MaxIt - it)/(MaxIt - 1))^Exponent * (sigma_initial - sigma_final) + sigma_final;

% Get Best and Worst Cost Values
Costs = [pop.Cost];
BestCost = min(Costs);
WorstCost = max(Costs);

% Initialize Offsprings Population
newpop = [];

% Reproduction
for i = 1:numel(pop)

ratio = (pop(i).Cost - WorstCost)/(BestCost - WorstCost);
S = floor(Smin + (Smax - Smin)*ratio);

for j = 1:S

% Initialize Offspring
newsol = empty_plant;

% Generate Random Location
newsol.Position = pop(i).Position + sigma * randn(VarSize);

% Apply Lower/Upper Bounds
newsol.Position = max(newsol.Position, VarMin);
newsol.Position = min(newsol.Position, VarMax);

% Evaluate Offsring
newsol.Cost = CostFunction(newsol.Position);

% Add Offpsring to the Population
newpop = [newpop
newsol]; 

end

end

% Merge Populations
pop = [pop
newpop];

% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);

% Competitive Exclusion (Delete Extra Members)
if numel(pop)>nPop
pop = pop(1:nPop);
end

% Store Best Solution Ever Found
BestSol = pop(1);

% Store Best Cost History
BestCosts(it) = BestSol.Cost;

% Display Iteration Information
disp(['Iteration ' num2str(it) ': IWO Best Cost = ' num2str(BestCosts(it))]);
BestCost=BestCosts;
end
disp('IWO Algorithm Came To End');
% Store Res
results.BestSol=BestSol;
results.BestCost=BestCost;
%% Plot 
% Plot IWO Training Stages
% set(gcf, 'Position',  [600, 300, 500, 400])
plot(BestCost,'-',...
'LineWidth',1,...
'MarkerSize',4,...
'MarkerEdgeColor','k',...
'Color',[0.1,0.1,0.1]);
title('IWO Algorithm Training')
xlabel('IWO Iteration Number','FontSize',10,...
'FontWeight','bold','Color','k');
ylabel('IWO Best Cost Result','FontSize',10,...
'FontWeight','bold','Color','k');
legend({'IWO Algorithm Train'});
end
