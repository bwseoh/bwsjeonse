% bws_QEremoval predict the future values of interest rate data after 2008.11 based on
% the assumption of Wiener Process to rule out the QE effect.
function g_noQE = bws_QEremoval(InterestRateData, q)

% Ronald Byungwook Seoh, COSI 177A Spring 2013. Email bwseoh@brandeis.edu
% for any inquiries related to this code.

% Create copies of input data to work on
rIndex = repmat(InterestRateData,1,100);

% Monte Carlo for the interest rate data
rIndex_rateOfChange = diff(InterestRateData(72:120)) ./ InterestRateData(72:119);
rIndex_S0 = InterestRateData(120);
rIndex_mu = mean(rIndex_rateOfChange);
rIndex_sigma = std(rIndex_rateOfChange);
rIndex_TimePeriods = 50;
rIndex_stepsEachPeriod = 1;
rIndex_nb_traj = 100;
rIndex(121:171,:) = bws_MonteCarlo(rIndex_sigma, rIndex_TimePeriods, rIndex_nb_traj, rIndex_S0, rIndex_mu, rIndex_stepsEachPeriod);

% Continuous compounding
for n = 1:100
    rIndex(:,n) = reallog(1 + rIndex(:,n));
end

% Calculate the values for g based on the corrected interest rates
g_noQE = zeros(171,100);

for j = 1:100
    g_noQE(:,j) = q - rIndex(:,j);
end

plot(g_noQE);