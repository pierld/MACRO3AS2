[output_mat,output_table,dates_nb] =  call_dbnomics('OECD/QNA/DEU.B1_GE.CQRSA.Q','OECD/QNA/DEU.B1_GE.DNBSA.Q','IMF/DOT/Q.DE.TMG_CIF_USD.US','ECB/EXR/Q.USD.EUR.SP00.A','OECD/DP_LIVE/DEU.CPI.TOT.IDX2015.Q');

%% ================================
% --- Observed series ---
% (1) [GDP€] : "Germany – Gross domestic product - expenditure approach – National currency, current prices, quarterly levels, seasonally adjusted – Quarterly" ['OECD/QNA/DEU.B1_GE.CQRSA.Q']
% (1.1) [GDP Deflator 2015 = 100] : "Germany – Gross domestic product - expenditure approach – Deflator, national base/reference year, seasonally adjusted – Quarterly" ['OECD/QNA/DEU.B1_GE.DNBSA.Q']
% (2) [Imports from US in $ = US exports to GER] : "Quarterly – Germany – Goods, Value of Imports, Cost, Insurance, Freight (CIF), US Dollars – United States, Millions" ['IMF/DOT/Q.DE.TMG_CIF_USD.US']
% (3) [Nominal exchange rate 1€=x$] : "Quarterly – US dollar – Euro – Spot – Average" [ECB/EXR/Q.USD.EUR.SP00.A]
%       > We have e = 1/NER
% (4) [CPI Quarterly Index] : "Germany – Inflation (CPI) – Total – 2015=100 – Quarterly [OECD/DP_LIVE/DEU.CPI.TOT.IDX2015.Q]"
% (?) [Real Exchange Rate (Index)] : "Quarterly – Narrow EER group of trading partners (fixed composition) – US dollar – Real effective exch. rate CPI deflated – Average" ['ECB/EXR/Q.E01.USD.ERC0.A']


% PRENDRE EN COMPTE POPULATION GROWTH ?? Prendre des valeurs per capita ? > non psq je regarde output GROWTH stationnaire
% remark 9 chained values 


%% ================================
idx = find(~isnan(sum(output_mat(:,2:end),2)));	% Find rows without NaN
data = output_mat(idx,:);						% > dataset without missing values
T = dates_nb(idx);								% > corresponding dates
NER = 1./data(:,5);                             % Exchange rate Foreign -> Home ($->€) but ECB provides (€->$)
imports_eur = data(:,4).*NER;                   % Imports are in $ : convert in € using NER
imports_real = imports_eur./data(:,6);			% In real terms
inflation = diff(log(data(:,6)));               % Inflation QoQ%


%% ================================
% --- Define "observed series" ---
% (1) Real output growth rate
gy_H_obs = diff(log(data(:,2)./data(:,3)));
% > Measurement equation : gy_H_obs = log(y_H/y_H(-1))
% > Where y_h = model total output measured in goods

% (2) Foreign exports = Home imports (growth rate)
ex_F_obs = diff(log(imports_real));
% > Measurement equation : ex_F_obs  = log(ex_F/ex_F(-1))
% > Where ex_F = model H imports of Foreign products measured in goods

% (3) Nominal exchange rate change (growth rate) : Foreign->Home ($->€)
de_obs = diff(log(NER));
% > Measurement equation : de_obs = log(de) (où de = ratio des exchange rate dans modèle)

% (4) Inflation
pi_H_obs = inflation - mean(inflation);
% > Measurement equation : Demean the sample to make it consistant with model definition of pi - steady_state(pi)

T = T(2:end);

%% ================================
% --- Export ---
% save into `ger_obs` the series selected observed series
save ger_obs T gy_H_obs ex_F_obs pi_H_obs de_obs;


%% ================================
% --- Plots ---
close all;
figure;

subplot(2,2,1)
plot(T,gy_H_obs)
xlim([min(T) max(T)]);
title('Real output (%QoQ)')

subplot(2,2,2)
plot(T,ex_F_obs)
xlim([min(T) max(T)]);
title('German US imports (%QoQ)')

subplot(2,2,3)
plot(T,pi_H_obs)
xlim([min(T) max(T)]);
title('Inflation (%QoQ)')

%subplot(2,2,4)
%plot(T,de_obs)
%xlim([min(T) max(T)]);
%title('Nominal Exchange rate $->€ (%QoQ)')






