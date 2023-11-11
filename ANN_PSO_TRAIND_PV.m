% Clear all variables and the command window
clear all
clc

% Define the constants for the photovoltaic system
ISCS=8.66;
IMPS=8.15;
VOCS=37.3;
VMPS=30.7;
alpha=0.86988;
beta=0.36901;
Gs=1000;
Ts=25;
num_samples = 1000;

% Initialize matrices for temperature (T) and solar irradiance (G)
T = zeros(num_samples, 1);
G = zeros(num_samples, 1);

% Generate random values for T and G, and calculate IMP, VMP, and PMP
for i=1:num_samples
    Tmin=15;
    Tmax=35;
    T(i)=(Tmax-Tmin)*rand+Tmin;
    Gmin=0;
    Gmax=1000;
    G(i)=(Gmax-Gmin)*rand+Gmin;
    IMP(i)=IMPS.*(G(i)/Gs).*(1+(alpha.*(T(i)-Ts)));
    VMP(i)=VMPS+(beta*(T(i)-Ts));
    PMP(i)=VMP(i)+IMP(i);
    input(i,:)=[G(i) T(i)];
    output(i,1)=VMP(i);
end

% Define the input and output data
inputs = input';
outputs = output';

% Create a feedforward neural network with 10 hidden neurons
net = feedforwardnet(10);

% Train the neural network with the input and output data
net = train(net, inputs, outputs);

% Get the initial weights and biases of the network
initialWeights = getwb(net);

% Define the fitness function for PSO as the mean squared error between the actual outputs and the outputs predicted by the neural network
fitfunc = @(x) mse(outputs, sim(setwb(net, x), inputs));

% Define the initial parameters for PSO
n_particles = 20;
n_iterations = 100;
dim = numel(initialWeights);

% Run the PSO algorithm to find the optimal weights for the neural network
options = optimoptions('particleswarm','SwarmSize',n_particles,'MaxIterations',n_iterations);
optimal_weights = particleswarm(fitfunc,dim,-1,1,options);

% Optimize the weights of the neural network using the results from PSO
optimal_net = setwb(net,optimal_weights);
gensim(optimal_net)
