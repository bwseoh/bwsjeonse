% The main script for Ronald Byungwook Seoh's COSI 177A project.

% Ronald Byungwook Seoh, COSI 177A Spring 2013. Email bwseoh@brandeis.edu
% for any inquiries regarding this code.

% Reading the input data using xlsread
HousingPriceData = xlsread('hIndex.xls'); % Jeonse deposit rate
InterestRateData = xlsread('rIndex.xls');

% Preparing q
p = 0.01;
outsideFactor = 0.3;
q = HousingPriceData + outsideFactor;
q = p - (reallog(q) / 2);

% Continuous compounding
InterestRateData = reallog(1 + InterestRateData);

% Calculate the values for g
g = q - InterestRateData;

% plot g, q, r
figure;

plot(g,'g');
hold on
plot(q,'r');
plot(InterestRateData,'b');
grid on
legend('g','q','r');

% Predict the future values of interest rate data after 2008.11 based on
% the assumption of Wiener Process to rule out the QE effect
figure;
g_noQE = bws_QEremoval(InterestRateData(1:120), q);

% Housing price simulation based on g
HousingPriceData2 = xlsread('hIndex2.xls');

% Calculating standard deviation by getting the residual from the trend.
% Currently, it does the curve fitting but does not make use of the
% residual. Further work needed.
figure;
hIndex2_cfit = bws_hIndex2_CurveFitting_1(HousingPriceData2);
hIndex2_cfit_residual = feval(hIndex2_cfit, 1:numel(HousingPriceData2)) - HousingPriceData2;

hIndex2 = HousingPriceData2;

hIndex2_MCsimulation = bws_hIndex2_MCsimulation(hIndex2, numel(hIndex2), 1, g(numel(hIndex2),1), 2, 1/12, 100);
hIndex2_MCsimulation_gNoQE = bws_hIndex2_MCsimulation(hIndex2, numel(hIndex2), 1, g_noQE(numel(hIndex2),1), 2, 1/12, 100);

figure;
plot(hIndex2_MCsimulation);
figure;
plot(hIndex2_MCsimulation_gNoQE);

% Finding past optimal points. 51 is February 2003, and 171 is February 2013. 
pastOptimal_StartingPoint = 51;
pastOptimal_EndingPoint = 171;
pastOptimal_expectedGrowthWOrisk = zeros((pastOptimal_EndingPoint-pastOptimal_StartingPoint+1), 1);
pastOptimal_Results_RawData = zeros((pastOptimal_EndingPoint-pastOptimal_StartingPoint+1), 2);
pastOptimal_MatchCount = 1;

for i = pastOptimal_EndingPoint:-1:pastOptimal_StartingPoint
    pastOptimal_MCsimulation = bws_hIndex2_MCsimulation(hIndex2, i, 1, g(i,1), 2, 1/12, 100);    
    pastOptimal_expectedGrowthWOrisk(i-pastOptimal_StartingPoint+1,1) = mean(pastOptimal_MCsimulation(25,:))- 2.5 * std(pastOptimal_MCsimulation(25,:));
    if pastOptimal_expectedGrowthWOrisk(i-pastOptimal_StartingPoint+1,1) > 1
        pastOptimal_Results(pastOptimal_MatchCount,:) = [i-pastOptimal_StartingPoint+1 pastOptimal_expectedGrowthWOrisk(i-pastOptimal_StartingPoint+1,1)];
        pastOptimal_MatchCount = pastOptimal_MatchCount + 1;
    end
    pastOptimal_Results_RawData(i-pastOptimal_StartingPoint+1,:) = [mean(pastOptimal_MCsimulation(25,:)) std(pastOptimal_MCsimulation(25,:))];
end

figure;
plot(pastOptimal_expectedGrowthWOrisk, 'r');
hold on;
plot(pastOptimal_Results(:,1),pastOptimal_Results(:,2),'g*');

% Print out the result, assuming that the size of risk is 2.5 sigma
expectedGrowthWOrisk = mean(hIndex2_MCsimulation(25,:)) - 2.5 * std(hIndex2_MCsimulation(25,:));
fprintf('Expected growth rate without the risk = %f \n', expectedGrowthWOrisk);

if expectedGrowthWOrisk > 1
    disp('It is better to buy a house.');
else
    disp('It is better to rent with a jeonse.');
end

expectedGrowthWOrisk_gNoQE = mean(hIndex2_MCsimulation_gNoQE(25,:)) - 2.5 * std(hIndex2_MCsimulation_gNoQE(25,:));
fprintf('No QE - Expected growth rate without the risk = %f \n', expectedGrowthWOrisk_gNoQE);

if expectedGrowthWOrisk_gNoQE > 1
    disp('It is better to buy a house.');
else
    disp('It is better to rent with a jeonse.');
end