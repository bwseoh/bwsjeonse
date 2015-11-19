% bws_hIndex2_MCsimulation conducts Monte Carlo simulation for housing market price growth rate.
function hIndex2_MCsimulation = bws_hIndex2_MCsimulation(hIndex2, simulationStartingPoint, hIndex2_S0, hIndex2_mu, hIndex2_timePeriods, hIndex2_stepsEachPeriod, hIndex2_nb_traj)

% Ronald Byungwook Seoh, COSI 177A Spring 2013. Email bwseoh@brandeis.edu
% for any inquiries related to this code.

%Calculating the rates of change to get the standard deviation. 
hIndex2_rateOfChange = zeros(24,1); % For the past 2 years
for i = simulationStartingPoint:-1:(simulationStartingPoint-24+1)
    hIndex2_rateOfChange(i-(simulationStartingPoint-24),1) = (hIndex2(i) - hIndex2(i-12)) / hIndex2(i);
end

hIndex2_sigma = std(hIndex2_rateOfChange);

hIndex2_MCsimulation = bws_MonteCarlo(hIndex2_sigma, hIndex2_timePeriods, hIndex2_nb_traj, hIndex2_S0, hIndex2_mu, hIndex2_stepsEachPeriod);

end