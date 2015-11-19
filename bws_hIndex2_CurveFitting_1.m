function cf_ = bws_hIndex2_CurveFitting_1(HousingPriceData2)
%HINDEX2_CURVEFITTING_1    Create plot of datasets and fits
%   HINDEX2_CURVEFITTING_1(HOUSINGPRICEDATA2)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

% Ronald Byungwook Seoh, COSI 177A Spring 2013. Email bwseoh@brandeis.edu
% for any inquiries regarding this code.

% Data from dataset "HousingPriceData2":
%    Y = HousingPriceData2:
%    Unweighted
%

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[436.667 164 672 481]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "HousingPriceData2"
x_1 = (1:numel(HousingPriceData2))';
HousingPriceData2 = HousingPriceData2(:);
h_ = line(x_1,HousingPriceData2,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(x_1));
xlim_(2) = max(xlim_(2),max(x_1));
legh_(end+1) = h_;
legt_{end+1} = 'HousingPriceData2';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[-0.69999999999999995559, 172.69999999999998863]);
end


% --- Create fit "fit 1"
ok_ = isfinite(x_1) & isfinite(HousingPriceData2);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
ft_ = fittype('poly9');

% Fit this model using new data
cf_ = fit(x_1(ok_),HousingPriceData2(ok_),ft_);

% Or use coefficients from the original fit:
if 0
   cv_ = { 1.1102750800831183948e-15, -9.7296722518840518398e-13, 3.5545051070556256848e-10, -7.0172770520971017468e-08, 8.1036529777163569523e-06, -0.00055248552525990937256, 0.021269426842450454146, -0.41087596845939816648, 3.3628902571305268054, 48.486871709974643352};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

% Done plotting data and fits.  Now finish up loose ends.
hold off;
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'}; 
h_ = legend(ax_,legh_,legt_,leginfo_{:});  % create legend
set(h_,'Interpreter','none');
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
