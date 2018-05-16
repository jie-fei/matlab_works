% PMSAFdemo        Proportionale Multiband-Structured Subbband Adaptive Filter (PNSAF) Demo
%
%                  Subband error signals are generated from subband input signals and subband
%                  desired responses. The fullband error signal is generated by interpolating 
%                  and combining the subband erros signals
%                   
%
% by Lee, Gan, and Kuo, 2008
% Subband Adaptive Filtering: Theory and Implementation
% Publisher: John Wiley and Sons, Ltd

addpath '..\Common';         % Functions in Common folder
clear all; close all;

% Adaptive filter parameters

mu = 0.1;                        % Step size (0<mu<2)
M = 256;                         % Length of adaptive weight vector
N = 4;                           % Number of subbands, 4
L = 8*N;                         % Length of analysis filters, L=2KN, 
                                 %   overlapping factor K=4

% Run parameters
 
iter = 8.0*80000;                % Number of iteration for each runs
b = load('h1.dat');              % Unknown system (select h1 or h2)
b = b(1:M);                      % Truncate to length M

tic;

% Adaptation process

disp(sprintf('Number of subbands, N = %d, Step size = %.5f',N,mu));
[un,dn,vn] = GenerateResponses(iter,b);
S = PMSAFinit(zeros(M,1),mu,N,L);% Initialization
S.unknownsys = b;
[en,S] = PMSAFadapt(un,dn,S);    % Perform PMSAF algorithm

EML = S.eml.^2;                  % System error norm (normalized)
err_sqr = en.^2;
    
disp(sprintf('Total time = %.3f mins',toc/60));

figure;
q = 0.99; MSE = filter((1-q),[1 -q],err_sqr);
hold on; plot((0:length(MSE)-1)/1024,10*log10(MSE));
axis([0 iter/1024 -60 10]);
xlabel('Number of iterations (\times 1024 input samples)'); 
ylabel('Mean-square error (with delay)'); grid on;
title('PMSAF');

figure;
hold on; plot((0:length(EML)-1)/1024,10*log10(EML));
xlabel('Number of iterations (\times 1024 input samples)'); 
ylabel('Misalignment (dB)'); title('PMSAF');
grid on;

