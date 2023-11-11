clear all
clc
ISCS=8.66;
IMPS=8.15;
VOCS=37.3;
VMPS=30.7;
alpha=0.86988;
beta=0.36901;
Gs=1000;
Ts=25;
for i=1:1000
    Tmin=15;
    Tmax=35;
    T=(Tmax-Tmin)*rand+Tmin;
    Gmin=0;
    Gmax=1000;
    G=(Gmax-Gmin)*rand+Gmin;
    IMP(i)=IMPS*(G/Gs)*(1+(alpha*(T-Ts)));
    VMP(i)=VMPS+(beta*(T-Ts));
    PMP(i)=VMP(i)+IMP(i);
    input(i,:)=[G T];
    output(i,1)=VMP(i);
    output1(i,1)=IMP(i);
     output2(i,1)=PMP(i);
end

sampleTime = 0.01;
numSteps = 1001;
time = sampleTime*(0:numSteps-1);
time = time';
data1 = G;
simin_G = timeseries(data1,time);
data2 = T;
simin_T = timeseries(data2,time);


% Define input and output data

inputs = input';
outputs = output';

% Create neural network
net = feedforwardnet(10);

% Train neural network
net = train(net, inputs, outputs);

% Get initial weights and biases
initialWeights = getwb(net);

% Define objective function for PSO
fitfunc = @(x) mse(outputs, sim(setwb(net, x), inputs));

% Initial values for PSO
n_particles = 20;
n_iterations = 100;
dim = numel(initialWeights);

% Run PSO algorithm
options = optimoptions('particleswarm','SwarmSize',n_particles,'MaxIterations',n_iterations);
optimal_weights = particleswarm(fitfunc,dim,-1,1,options);

% Optimize network weights
optimal_net = setwb(net,optimal_weights);
gensim(optimal_net)