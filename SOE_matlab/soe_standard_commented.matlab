%=====================================================================
% Arbus A, Barrio P, Rouillard P
% Code adapted from Prof. Vermandel G (gauthier@vermandel.fr)
%=====================================================================

close all;
%format long

%=====================================================================
% 1. VARIABLES
%=====================================================================
var c_H r_H pic_H pi_H mc_H w_H h_H y_H p_H NFA_H lb_H ex_H
	c_F r_F pic_F pi_F mc_F w_F h_F y_F p_F NFA_F lb_F ex_F
	de rer
	e_H e_F tau_H tau_F mu_H mu_F g_H g_F varrho_H varrho_F
	e_z_H e_p_H e_r_H e_x_H e_t_H e_g_H
	e_z_F e_p_F e_r_F e_x_F e_t_F e_g_F 
	gy_H_obs gy_F_obs gc_H_obs gc_F_obs pi_H_obs pi_F_obs r_H_obs r_F_obs de_obs  drer_obs ex_H_obs ex_F_obs
	e_e;

varexo	eta_z_H eta_p_H eta_r_H eta_x_H eta_z_F eta_p_F eta_r_F eta_x_F eta_e eta_t_H eta_t_F  eta_g_H eta_g_F ;

parameters	sigmaC_H sigmaC_F sigmaH_H sigmaH_F beta alpha hc_H hc_F chi_B chi_H chi_F xi_H xi_F epsilon_H epsilon_F mu alphaC_H alphaC_F n rho phi_pi phi_y 
			rho_e phi_H phi_F tau0_H tau0_F y0 sig_H sig_F theta1 theta2 varphi A psi piss Hss gy_H gy_F
			rho_z_H rho_r_H rho_p_H rho_x_H rho_t_H rho_g_H
			rho_z_F rho_r_F rho_p_F rho_x_F rho_t_F rho_g_F
			;

%=====================================================================
% 2. CALIBRATION
%=====================================================================


% >>> BASE
% ------------ Calibrated -------------------
sigmaC_H		= 1.5;		% risk aversion
sigmaC_F		= 1.2;		% risk aversion >> chercher US?
sigmaH_H		= 2;		% labor supply
sigmaH_F		= 1.9;		% labor supply	>> chercher US?
beta		= .994;			% discount factor
alpha		= .7;			% share of labor in production
hc_H		= .7;			% consumption habits
hc_F		= .6;			% consumption habits
chi_B		= 0.007;		% (x) cost of foreign debt (same for hh in H or in F)
xi_H		= 100;			% (x) cost adjustment prices
xi_F		= 80;			% (x) cost adjustment prices
epsilon_H	= 10;			% (x) imperfect substitution between goods
epsilon_F	= 9.5;			% (x) imperfect substitution between goods
mu			= 2;			% Substitution between home/foreign goods
alphaC_H	= .1;			% Share of home goods in consumption basket
alphaC_F	= .11;			% Share of foreign goods in consumption basket
%
n 			= 0.2;			% share of Home country then size of Foreign country 1-n : https://data.oecd.org/pop/population.html
y0	 		= 25;			% trillions usd PPA : https://data.worldbank.org/indicator/NY.GDP.MKTP.CD ; on a bien y(US) = (1-n)*y0
piss		= 1.005;		% steady state inflation
Hss			= 1/3;			% labor supply in ss
gy_H 		= 0.45;			% Public spending to gdp : https://ourworldindata.org/government-spending
gy_F 		= 0.45;			% Public spending to gdp : 1980 - now public spending to gdp avg : US=0.4 et Germany=0.5
% ------------ Climate block ----------------
varphi	= 0.22;				% elasticity of emission to GDP
tau0_H	= 50 /1000;			% value of carbon tax ($/ton)
tau0_F	= 50 /1000;			% value of carbon tax ($/ton)
sig_H	= 0.2; 				% Carbon intensity USA 0.2 Gt / Trillions USD
sig_F	= 0.2; 				% Carbon intensity USA 0.2 Gt / Trillions USD
theta1  = 0.05;				% level of abatement costs
theta2  = 2.6;				% curvature abatement cost
% ------------ Estimated with KF ------------
rho			= .8;			% Monetary policy coefficient smoothing
phi_pi		= 1.5;			% Monetary policy reaction to inflation
phi_y		= .05;			% Monetary policy reaction to output
% parameters of autoregressive shocks						
rho_z_H 	= .95; rho_z_F 	= .95;
rho_p_H 	= .95; rho_p_F 	= .95;
rho_r_H		= .4;  rho_r_F	= .4;
rho_x_H		= .4;  rho_x_F	= .4;
rho_t_H		= .4;  rho_t_F	= .4;
rho_g_H		= .4;  rho_g_F	= .8;
rho_e		= .1;



% >>> Based on the iFO DSGE model for Germany
% ------------ Calibrated -------------------
/sigmaC_H		= 2;		% risk aversion
/sigmaC_F		= 2;		% risk aversion >> chercher US?
/sigmaH_H		= 1.5;		% labor supply
/sigmaH_F		= 1.5;		% labor supply	>> chercher US?
/beta		= .998;			% discount factor
/alpha		= .57;			% share of labor in production
hc_H		= .7;			% consumption habits
/hc_F		= .7;			% consumption habits
chi_B		= 0.007;		% (x) cost of foreign debt (same for hh in H or in F)
xi_H		= 100;			% (x) cost adjustment prices
xi_F		= 80;			% (x) cost adjustment prices
epsilon_H	= 10;			% (x) imperfect substitution between goods
epsilon_F	= 9.5;			% (x) imperfect substitution between goods
mu			= 1.1;			% Substitution between home/foreign goods
/alphaC_H	= .5;			% Share of home goods in consumption basket
/alphaC_F	= .5;			% "Share of foreign goods in consumption basket" >> non???
n 			= 0.2;			% share of Home country then size of Foreign country 1-n : https://data.oecd.org/pop/population.html
y0	 		= 29;			% trillions usd PPA : https://data.worldbank.org/indicator/NY.GDP.MKTP.CD ; on a bien y(US) = (1-n)*y0
piss		= 1.005;		% steady state inflation
Hss			= 1/3;			% labor supply in ss
gy_H 		= 0.45;			% Public spending to gdp : https://ourworldindata.org/government-spending
gy_F 		= 0.45;			% Public spending to gdp : 1980 - now public spending to gdp avg : US=0.4 et Germany=0.5
% ------------ Climate block ----------------
varphi	= 0.22;				% elasticity of emission to GDP
tau0_H	= 50 /1000;			% value of carbon tax ($/ton)
tau0_F	= 50 /1000;			% value of carbon tax ($/ton)
sig_H	= 0.2; 				% Carbon intensity USA 0.2 Gt / Trillions USD
sig_F	= 0.2; 				% Carbon intensity USA 0.2 Gt / Trillions USD
theta1  = 0.05;				% level of abatement costs
theta2  = 2.6;				% curvature abatement cost
% ------------ Estimated with KF ------------
rho			= .8;			% Monetary policy coefficient smoothing
phi_pi		= 1.5;			% Monetary policy reaction to inflation
phi_y		= .05;			% Monetary policy reaction to output
% parameters of autoregressive shocks						
rho_z_H 	= .95; rho_z_F 	= .95;
rho_p_H 	= .95; rho_p_F 	= .95;
rho_r_H		= .4;  rho_r_F	= .4;
rho_x_H		= .4;  rho_x_F	= .4;
rho_t_H		= .4;  rho_t_F	= .4;
rho_g_H		= .4;  rho_g_F	= .8;
rho_e		= .1;





%=====================================================================
% 3. COMPUTATION : CLOSE-FORM expression of the steady-state
%=====================================================================
steady_state_model;
	h_H		= Hss;
	h_F		= Hss;
	tau_H 	= tau0_H;
	tau_F 	= tau0_F;
	phi_H	= (1-(1-n)*alphaC_H);
	phi_F	= (1-n*alphaC_F);
	y_H     = y0/n;
	A		= y_H/h_H^alpha;
	y_F		= A*h_F^alpha;
	g_H     = gy_H*y_H;
	g_F     = gy_H*y_F;
	mu_H	= (tau_H*sig_H*y_H^(1-varphi)/(theta2*theta1))^(1/(theta2-1));
	mu_F	= (tau_F*sig_F*y_F^(1-varphi)/(theta2*theta1))^(1/(theta2-1));
	e_H 	= n*sig_H*(1-mu_H)*y_H^(1-varphi);
	e_F 	= (1-n)*sig_H*(1-mu_F)*y_F^(1-varphi);
	c_F 	= (y_F - g_F - theta1*mu_F^theta2*y_F -((1-phi_H)*n/(1-n))* (y_H-g_H-theta1*mu_H^theta2*y_H)/phi_H)/((phi_F-(1-phi_H)*(1-phi_F)/phi_H));
	c_H		= (y_H-g_H-theta1*mu_H^theta2*y_H-(1-phi_F)*c_F*(1-n)/n)/phi_H  ;
	lb_H 	= (c_H-hc_H*c_H)^-sigmaC_H;
	lb_F 	= (c_F-hc_F*c_F)^-sigmaC_F;
	r_H		= piss/beta;
	r_F		= piss/beta;
	pic_H	= piss; pic_F	= piss;
	pi_H	= piss; pi_F	= piss;
	de		= 1;
	NFA_H	= ((phi_H*c_H + (1-phi_F)*c_F*(1-n)/n) - c_H)/(1-r_F/pic_H);
	NFA_F	= -n/(1-n)*NFA_H;
	rer		= 1;
	mc_H	= (epsilon_H-1)/epsilon_H;
	mc_F	= (epsilon_F-1)/epsilon_F;
	varrho_H = mc_H - theta1*mu_H^theta2 - tau_H*(1-varphi)*sig_H*(1-mu_H)*y_H^(-varphi);
	varrho_F = mc_F - theta1*mu_F^theta2 - tau_F*(1-varphi)*sig_F*(1-mu_F)*y_F^(-varphi);
	w_H		= varrho_H/h_H*(alpha*y_H);
	w_F		= varrho_F/h_F*(alpha*y_F);
	p_H		= 1; 
	p_F		= 1;
	ex_H 	= (1-phi_F)*c_F*(1-n);
	ex_F 	= (1-phi_H)*c_H*n;
	chi_H	= lb_H*w_H/(h_H^sigmaH_H);
	chi_F	= lb_F*w_F/(h_F^sigmaH_F);
	e_z_H	= 1; e_p_H = 1; e_r_H = 1; e_x_H = 1; e_t_H = 1; e_g_H  = 1; e_e = 1;
	e_z_F	= 1; e_p_F = 1; e_r_F = 1; e_x_F = 1; e_t_F = 1; e_g_F  = 1;
	gy_H_obs = 0; gy_F_obs = 0; gc_H_obs = 0; gc_F_obs = 0; pi_H_obs = 0; pi_F_obs = 0; r_H_obs = 0; r_F_obs = 0; de_obs = 0;  drer_obs = 0; ex_H_obs = 0; ex_F_obs = 0;
end;

%=====================================================================
% 4. MODEL DEFINITION (the number refers to the equation in the paper)
%=====================================================================
model;
	% ==============
	%%% Households
	[name='FOC c']
	lb_H = (c_H-hc_H*c_H(-1))^-sigmaC_H;
	lb_F = (c_F-hc_F*c_F(-1))^-sigmaC_F;

	[name='Euler equation']
	lb_H = beta*lb_H(+1)*r_H/pic_H(+1);
	lb_F = beta*lb_F(+1)*r_F/pic_F(+1);

	[name='Labor Supply']
	chi_H*h_H^sigmaH_H = lb_H*w_H;
	chi_F*h_F^sigmaH_F = lb_F*w_F;
	
	%%% FIRMS
	[name='NKPC']
	(1-epsilon_H) + epsilon_H*e_p_H*mc_H - xi_H*pi_H*(pi_H-piss) + xi_H*beta*((c_H(+1)-hc_H*c_H)/(c_H-hc_H*c_H(-1)))^-sigmaC_H*pi_H(+1)*(pi_H(+1)-piss)*y_H(+1)/y_H; % (sous entendu = 0)
 	(1-epsilon_F) + epsilon_F*e_p_F*mc_F - xi_F*pi_F*(pi_F-piss) + xi_F*beta*((c_F(+1)-hc_F*c_F)/(c_F-hc_F*c_F(-1)))^-sigmaC_F*pi_F(+1)*(pi_F(+1)-piss)*y_F(+1)/y_H; % (sous entendu = 0)

	[name='FOC h']
	varrho_H = h_H/(alpha*y_H)*w_H;
	varrho_F = h_F/(alpha*y_F)*w_F;

	[name='Production function']
	y_H = A*e_z_H*h_H^alpha;
	y_F = A*e_z_F*h_F^alpha;

	[name='CES price index']
	1 = phi_H*p_H^(1-mu) + (1-phi_H)*rer^(1-mu);
	1 = phi_F*p_F^(1-mu) + (1-phi_F)*(1/rer)^(1-mu);

	[name='Relative price']
	p_H/p_H(-1) = pi_H/pic_H;
	p_F/p_F(-1) = pi_F/pic_F;

	[name='Total emissions']
	e_H = n*sig_H*(1-mu_H)*y_H^(1-varphi);
	e_F = (1-n)*sig_F*(1-mu_F)*y_F^(1-varphi);

	[name='FOC mu']
	varrho_H = mc_H - theta1*mu_H^theta2 - tau_H*(1-varphi)*sig_H*(1-mu_H)*y_H^-varphi;
	varrho_F = mc_F - theta1*mu_F^theta2 - tau_F*(1-varphi)*sig_F*(1-mu_F)*y_F^-varphi;

	[name='FOC y']
	tau_H*sig_H*y_H^(1-varphi) = theta2*theta1*mu_H^(theta2-1);
	tau_F*sig_F*y_F^(1-varphi) = theta2*theta1*mu_F^(theta2-1);

	% ==============
	%%% AGGREGATION
	[name='Resources constraint']
	y_H = phi_H*p_H^-mu*c_H + e_x_F*(1-phi_F)*(p_H/rer)^-mu*c_F*(1-n)/n  + g_H + theta1*mu_H^theta2*y_H + 0.5*xi_H*(pi_H-piss)^2*y_H + 0.5*chi_B*(NFA_H-STEADY_STATE(NFA_H))^2;
	y_F = phi_F*p_F^-mu*c_F + e_x_H*(1-phi_H)*(p_F*rer)^-mu*c_H*n/(1-n)  + g_F + theta1*mu_F^theta2*y_F + 0.5*xi_F*(pi_F-piss)^2*y_F - 0.5*chi_B*(NFA_F-STEADY_STATE(NFA_F))^2;

	% ==============
	%%% POLICIES
	[name='Monetary Policy Rule']
	r_H = r_H(-1)^rho * (STEADY_STATE(r_H)*(pic_H/steady_STATE(pic_H))^phi_pi*(y_H/STEADY_STATE(y_H))^phi_y)^(1-rho)*e_r_H;
	r_F = r_F(-1)^rho * (STEADY_STATE(r_F)*(pic_F/steady_STATE(pic_F))^phi_pi*(y_F/STEADY_STATE(y_F))^phi_y)^(1-rho)*e_r_F;

	[name='Public spending']
	g_H = gy_H*steady_state(y_H)*e_g_H;
	g_F = gy_F*steady_state(y_F)*e_g_F;

	[name='Carbon tax']
	tau_H = tau0_H*e_t_H;
	tau_F = tau0_F*e_t_F;

	% ==============
	%%% Common macro variables from the Home country perspective
	[name='Net Foreign assets accumulation']
	NFA_H = r_F(-1)/pic_H*NFA_H(-1)*de + p_H*(phi_H*p_H^-mu*c_H + e_x_F*(1-phi_F)*(1-n)/n*(p_H/rer)^-mu*c_F) - c_H;

	[name='International financial markets accounting']
	n*NFA_H + (1-n)*NFA_F = 0;

	[name='Nominal exchange rate growth']
	de(+1) = (1+chi_B*(NFA_H-STEADY_STATE(NFA_H)))*r_H/r_F/e_e;

	[name='Real exchange rate']
	rer/rer(-1) = de*pi_F/pi_H;

	[name='Exports']
	ex_H = e_x_H*(1-phi_F)*(p_H/rer)^-mu*c_F*(1-n);
	ex_F = e_x_F*(1-phi_H)*(p_F*rer)^-mu*c_H*n;
	
	% ==============
	%% Observable variables > data from dbnomics should have EXACT SAME names for the chosen series
	[name='measurement GDP']
	gy_H_obs = log(y_H/y_H(-1));
	gy_F_obs = log(y_F/y_F(-1));

	[name='measurement consumption']
	gc_H_obs = log(c_H/c_H(-1));
	gc_F_obs = log(c_H/c_H(-1));

	[name='measurement inflation']
	pi_H_obs = pi_H - steady_state(pi_H);
	pi_F_obs = pi_F - steady_state(pi_F);

	[name='measurement interest rate']
	r_H_obs  = r_H  - steady_state(r_H);
	r_F_obs  = r_F  - steady_state(r_F);

	[name='measurement nominal exchange rate change']
	de_obs  = log(de);

	[name='measurement real exchange rate change']
	drer_obs  = log(rer/rer(-1));

	[name='measurement exports change']
	ex_H_obs  = log(ex_H/ex_H(-1));
	ex_F_obs  = log(ex_F/ex_F(-1));

	% ==============
	%% Stochastic processes
	[name='Country specific shocks']
	%% Home
	log(e_z_H) = rho_z_H*log(e_z_H(-1)) + eta_z_H;	
	log(e_p_H) = rho_p_H*log(e_p_H(-1)) + eta_p_H;
	log(e_r_H) = rho_r_H*log(e_r_H(-1)) + eta_r_H;
	log(e_x_H) = rho_x_H*log(e_x_H(-1)) + eta_x_H;
	log(e_g_H) = rho_x_H*log(e_g_H(-1)) + eta_g_H;
	log(e_t_H) = rho_t_H*log(e_t_H(-1)) + eta_t_H;
	%% Foreign
	log(e_z_F) = rho_z_F*log(e_z_F(-1)) + eta_z_F;
	log(e_p_F) = rho_p_F*log(e_p_F(-1)) + eta_p_F;
	log(e_r_F) = rho_r_F*log(e_r_F(-1)) + eta_r_F;
	log(e_x_F) = rho_x_F*log(e_x_F(-1)) + eta_x_F;
	log(e_g_F) = rho_g_F*log(e_g_F(-1)) + eta_g_F;
	log(e_t_F) = rho_t_F*log(e_t_F(-1)) + eta_t_F;
	%% exchange rate
	log(e_e)   = rho_e*log(e_e(-1)) + eta_e;
end;

% > check residuals : gap in the steady-state and what dynare computes ?
% resid;
steady;
% > check Blanchard-Kahn-conditions :
% check;



%=====================================================================
% 5. ESTIMATION (Kalman Filtering via MLE MCMC)
%=====================================================================
% Now we have to : estimate parameters to mimic chosen observed variables > measurement equations

% --------------------------------
% (1) Provide observable series --
% --------------------------------
% Dynare will look for these EXACT variables in the data matrix specified in estimation(.)
varobs gy_H_obs pi_H_obs ex_F_obs r_H_obs;

% --------------------------------
% (2) PRIORS SELECTION -----------
% --------------------------------
% 'INITVAL' = initial value of likelihood p(.)

%{
estimated_params;
//	PARAM NAME,		INITVAL,	LB,		UB,		PRIOR_SHAPE,		PRIOR_P1,		PRIOR_P2,		PRIOR_P3,		PRIOR_P4,		JSCALE
	stderr eta_g_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_g_H,			.92,    	,		,		beta_pdf,			.5,				0.2;
	stderr eta_p_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_p_H,			.92,    	,		,		beta_pdf,			.5,				0.2;
	stderr eta_r_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_r_H,			.5,    		,		,		beta_pdf,			.5,				0.2;
	stderr eta_e,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_e,				.2,    		,		,		beta_pdf,			.5,				0.2;
	
	rho,				.45,    	,		,		beta_pdf,			0.8,			0.1;
	phi_pi,				1.8,    	,		,		normal_pdf,			1.5,			0.2;
	phi_y,				0.05,    	,		,		beta_pdf,			0.2,			0.15;
end;
%}

estimated_params;
//	PARAM NAME,		INITVAL,	LB,		UB,		PRIOR_SHAPE,		PRIOR_P1,		PRIOR_P2,		PRIOR_P3,		PRIOR_P4,		JSCALE
%	stderr eta_g_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
%	rho_g_H,			.92,    	,		,		beta_pdf,			.5,				0.2;
	stderr eta_p_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_p_H,			,    		,		,		beta_pdf,			.5,				0.2;
	stderr eta_r_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_r_H,			,    		,		,		beta_pdf,			.5,				0.2;
	stderr eta_e,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_e,				,    		,		,		beta_pdf,			.5,				0.2;
	stderr eta_x_F,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_x_F,			,    		,		,		beta_pdf,			.5,				0.2;
	stderr eta_z_H,   	,			,		,		INV_GAMMA_PDF,		.01,			2;
	rho_z_H,			,    		,		,		beta_pdf,			.5,				0.2;
	
	rho,				,    		,		,		beta_pdf,			0.8,			0.1;
	phi_pi,				,    		,		,		normal_pdf,			1.5,			0.2;
	phi_y,				,    		,		,		beta_pdf,			0.2,			0.15;
end;



% --------------------------------
% (3) ESTIMATION BLOCK -----------
% --------------------------------
estimation(datafile=ger_obs,	% Datafile must be in current folder : output of my_db_GER
first_obs=1,					% First observable of the sample, can start later e.g first_obs = 10
mode_compute=6,					% optimization algo, keep it to 4
mh_replic=10000,				% number of sample in Metropolis-Hastings
mh_jscale=0.6,					% /!\ Adjust this to have an acceptance rate between 0.2 and 0.3 in MCMC /!\ meaning 20% of the mh_replic samples accepted  
prefilter=1,					% REMOVE THE MEAN IN THE DATA
lik_init=2,						% >> don't touch
mh_nblocks=1,					% number of mcmc chains
forecast=8						% forecasts horizon
) gy_H_obs pi_H_obs ex_F_obs r_H_obs;

% ----------------------------
% Historical shock decomposition des variables ...
shock_decomposition gy_H_obs pi_H_obs ex_F_obs r_H_obs;

stoch_simul(irf=16,conditional_variance_decomposition=[1,4,10,100],order=1) gy_H_obs pi_H_obs ex_F_obs r_H_obs;
% ----------------------------



%=====================================================================
%======= SAVE WORKSPACE AS A .mat FILE ===============================
%=====================================================================



%=====================================================================
%======= In a new .m FILE ============================================
%=====================================================================



%% >>> Load estimated parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
	'oo_.posterior_mean'	
		> .parameters
		> .shocks_std
%}
load("soe_res_save.mat");
% process ESTIMATED PARAMETERS
fn = fieldnames(oo_.posterior_mean.parameters);
for ix = 1:size(fn,1)
	set_param_value(fn{ix},eval(['oo_.posterior_mean.parameters.' fn{ix} ]))
end
% process ESTIMATED SHOCKS
fx = fieldnames(oo_.posterior_mean.shocks_std);
for ix = 1:size(fx,1)
	idx = strmatch(fx{ix},M_.exo_names,'exact');
	M_.Sigma_e(idx,idx) = eval(['oo_.posterior_mean.shocks_std.' fx{ix}])^2;
end
% load OBSERVED data
load(options_.datafile);
if exist('T') ==1
	Tvec = T;
else
	Tvec = 1:size(dataset_,1);
end
% Tvec : vector of dates
Tfreq = mean(diff(Tvec));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% >>> END OF SAMPLE FORECASTING - PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
	'dataset_' : observed data
		> .data
		> .dates
		> .name

	'dataset_info'

	'M_' : model
	'oo_' : 
		> .shock_decomposition
		> .SmoothedVariables
		> .SmoothedShocks
		> MeanForecast
			> .Mean : foreacast values
			> .Var : uncertainty around forecast
%}
tprior = 20; 	% period before forecasts to plot
Tvec2 = Tvec(end) + (0:(options_.forecast))*Tfreq;
for i1 = 1 :size(dataset_.name,1)
	% position indices of observed variable number i1 in dataset and Model 
	idv		= strmatch(dataset_.name{i1},M_.endo_names,'exact');
	idd		= strmatch(dataset_.name{i1},dataset_.name,'exact');
	if ~isempty(idd) && isfield(oo_.MeanForecast.Mean, dataset_.name{i1})
		% Create chart :
		% Find model based values for observed variables (SmoothedVariables) + add observed mean
		% because the model is based on zero-mean version of the data (prefilter in estimation)
		yobs   = eval(['oo_.SmoothedVariables.' dataset_.name{i1}])+dataset_info.descriptive.mean(idd);
		yfc    = eval(['oo_.MeanForecast.Mean.'  dataset_.name{i1}])+dataset_info.descriptive.mean(idd);
		yfcVar = sqrt(eval(['oo_.MeanForecast.Var.' dataset_.name{i1}]));
		figure;
		plot(Tvec(end-tprior+1:end),yobs(end-tprior+1:end))
		hold on;
			plot(Tvec2,[yobs(end) yfc'] ,'r--','LineWidth',1.5);
			% '1.96' due to normality assumption for 'residuals' in space-state representation of the model
			plot(Tvec2,[yobs(end) (yfc+1.96*yfcVar)'],'r:','LineWidth',1.5)
			plot(Tvec2,[yobs(end) (yfc-1.96*yfcVar)'],'r:','LineWidth',1.5)
			grid on;
			xlim([Tvec(end-tprior+1) Tvec2(end)])
			legend('Sample','Forecasting','Uncertainty')
			title(['forecasting of ' M_.endo_names_tex{idv}])
		hold off;
	else
		warning([ dataset_.name{i1} ' is not an observable or you have not computed its forecast'])
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% >>> COUNTERFACTUAL EXERCISES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stack estimated values for exogenous shocks in a matrix
fx = fieldnames(oo_.SmoothedShocks);
for ix=1:size(fx,1)
	% extract the correct (model-based) series from oo_.SmoothedShocks
	shock_mat = eval(['oo_.SmoothedShocks.' fx{ix}]);
	if ix==1; ee_mat = zeros(length(shock_mat),M_.exo_nbr); end;
	ee_mat(:,strmatch(fx{ix},M_.exo_names,'exact')) = shock_mat;
end

% ------
%>>> Simulate BASELINE scenario
% SOLVE DECISION RULEs
[oo_.dr, info, M_.params] = resol(0, M_, options_, oo_.dr, oo_.dr.ys, oo_.exo_steady_state, oo_.exo_det_steady_state);
% SIMULATE the model
y_            = simult_(M_,options_,oo_.dr.ys,oo_.dr,ee_mat,options_.order);

% ------
%>>> Simulate ALTERNATIVE scenario
% (!) make a copy (!)
Mx  = M_;
oox = oo_;
% (!) CHANGE PARAMETER (!)
Mx.params(strcmp('phi_y',M_.param_names)) = .25;
% solve new decision rule
[oox.dr, info, Mx.params] = resol(0, Mx, options_, oox.dr, oox.dr.ys, oox.exo_steady_state, oox.exo_det_steady_state);
% simulate dovish central bank
ydov            = simult_(Mx,options_,oox.dr.ys,oox.dr,ee_mat,options_.order);


% ------
% Plot results
var_names={'lny','lnc','lni','lnpi','lnr','h_obs'};
Ty = [T(1)-Tfreq;T];
% draw_tables from 'draw_tables.m'
draw_tables(var_names,M_,Ty,[],y_,ydov)
legend('Estimated','Dovish')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

























% ===============================================================
% ===============================================================
% ===============================================================
% ===============================================================
% ===============================================================


%----------------------------------------------------------------
%shocks;
%var eta_t_H; stderr 10;
%end;

%stoch_simul(order=1, irf=12) e_t_H pi_H pi_F rer ex_H ex_F;


%%>> mouvement 5 trimestres de e constant à +1 du steady-state (ça a un sens ??)

%initial_condition_states = repmat(oo_.dr.ys,1,M_.maximum_lag);
%%create shock matrix with number of time periods in line
%shock_matrix = zeros(options_.irf,M_.exo_nbr);
%shock_matrix(1,strmatch('eta_t_H',M_.exo_names,'exact')) = 10;
%shock_matrix(2:4,strmatch('eta_t_H',M_.exo_names,'exact')) = (1-rho_t_H)*(10);

%y2 = simult_(M_,options_,initial_condition_states,oo_.dr,shock_matrix,1);
%y_IRF = y2(:,M_.maximum_lag+1:end)-repmat(oo_.dr.ys,1,options_.irf); %deviation from steady state

%plot(y_IRF(strmatch('pi_H',M_.endo_names,'exact'),:))
%----------------------------------------------------------------


%----------------------------------------------------------------
% Stochastic Simulations
%shocks;
%var eta_z_H;  stderr 0.01;
%var eta_p_H;  stderr 0.01;
%var eta_r_H;  stderr 0.01;
%var eta_e;	  stderr 0.01;
%var eta_x_H;  stderr 0.01;
%end;
% Basic simulation of the model :
% /!\ IRF PRINT DES DEVIATIONS PAR RAPPORT AU STEADY-STATE /!\
%stoch_simul(order=1, irf=20) y_H y_F c_H c_F pi_H pi_F r_H r_F rer ex_H ex_F;
%----------------------------------------------------------------




