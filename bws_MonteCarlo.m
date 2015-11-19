% bws_MonteCarlo performs simple monovariate Monte Carlo simulation for 
% Ronald Byungwook Seoh's COSI 177A project.

% Ronald Byungwook Seoh, COSI 177A Spring 2013. Email bwseoh@brandeis.edu
% for any inquiries related to this code.

function simulatedTimeSeries = bws_MonteCarlo(standev, nTime, nTragectories, beginningValue, expectedValue, nSteps)

stepsEachPeriod = ceil(nTime/nSteps);

trend = repmat((expectedValue - standev^2/2) * nSteps * (1:stepsEachPeriod)', 1, nTragectories);
variabilityNoise = standev * sqrt(nSteps) * cumsum(randn(stepsEachPeriod, nTragectories));

simulatedTimeSeries = [repmat(beginningValue, 1, nTragectories); beginningValue * exp(trend + variabilityNoise)];

end