function [ error, gradient ] = wme_parameter_error( theta, degSeq )

% ----------------------------------------------------------------
% WME PARAMETER ERROR
%
% Computes the square of the L2 error of the WME mean graph
% degree sequence given by the parameter vector theta and the 
% "true" mean degree sequence from a sampled matrix, as well as 
% its gradient. Used to apply the method of gradient descent to 
% estimate the parameter theta for the WME distribution on 
% non-negatively weighted graphs with respect to the given degree
% sequence.
%
% INPUTS: 
%   theta: a vector of n non-negative values which act as
%       parameters in the maximum entropy distribution
%   degSeq: target degree sequence of mean from maximum entropy
%       distribution parameterized by theta
%
% OUTPUTS:  
%   error: square of l2 error between degree sequence of mean 
%       element of ME distribution and degSeq
%   gradient: gradient with resepct to entries of theta of the
%       error term
%
% ----------------------------------------------------------------

% ----------------------------------------------------------------
% Rewrite the thetas in forms that will be useful to the 
% computation. 
% ----------------------------------------------------------------

n = length(theta);
thetaInvSums = zeros(n);
for i=1:n
    for j=i+1:n
        thetaInvSums(i, j) = 1/(theta(i) + theta(j));
    end
end
thetaInvSums = thetaInvSums + thetaInvSums';
thetaInvRowSums = sum(thetaInvSums, 1);
thetaInvSquareSums = thetaInvSums.^2;
thetaInvSquareRowSums = sum(thetaInvSquareSums, 1);

% ----------------------------------------------------------------
% Compute the total error
% ----------------------------------------------------------------
error = 0;
for i=1:n
    error = error + (degSeq(i) - thetaInvRowSums(i))^2;
end

% ----------------------------------------------------------------
% Compute the gradient of the error term
% ----------------------------------------------------------------

gradient = zeros(n,1);
for j=1:n
    for i=1:n
        if (i == j)
            gradient(j) = gradient(j) + 2*(degSeq(i) - ...
                thetaInvRowSums(i))*(thetaInvSquareRowSums(i));
        else
            gradient(j) = gradient(j) + 2*(degSeq(i) - ...
                thetaInvRowSums(i))*(thetaInvSquareSums(i,j) - ...
                thetaInvRowSums(i) + thetaInvSums(i,j));            
        end
    end
end

end

