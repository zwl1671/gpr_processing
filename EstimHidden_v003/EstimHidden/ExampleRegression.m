  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% HIDDEN REGRESSION E x a m p l e s ("errors in variables" model)
% Observations vector Z 
% The second input argument is noise type
% The third input argument is sigma
% The fourth input argument is observations vector Y
%
% the output is a structure with
%   Dgopt : the selected "dimension" for the density g of X
%   gD : the estimate coefficients for g at the selected dimension Dgopt
%   Dlopt : the selected "dimension" for the product l=b.g
%   lD : the estimate coefficients for l=b.g at the selected dimension Dlopt
%   n : length of the observations
%   abs : linspace(quantila(Z,0.05),quantila(Z,0.95),1001) ->(default values)
%   gord : density g estimates associated to abs
%   lord : l=b.g estimates associated to abs
%   bord : b estimates associated to abs
%   vord : (s^2+b^2)*g estimates associated to abs
%   cord : s^2+b^2 estimates associated to abs
%   s2ord : s^2 estimates associated to abs

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Example A-1/ REGRESSION with errors in variables
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% following the second example of Fan & Truong - Annals of Statistics 1993
n = 2500;
name = 'truong';
W0 = 'normal';
s0 = sqrt(3/7)*0.25;
WY = 'normal';
sY = 0.25;

%%%% SIMULATION
Obs = DeconvSimul(name,n,W0,s0,WY,sY);

%%%% ESTIMATION
estimate = DeconvEstimate(Obs.Z,Obs.W0,Obs.s0,Obs.Y);

subplot(2,2,1)
plot(estimate.abs,pdf('norm',estimate.abs,0.5,0.25),'r',estimate.abs,estimate.gord,'b')
title('density g estimate')
legend('true','estimate')

subplot(2,2,2)
plot(estimate.abs,drift0(estimate.abs,name),'r',estimate.abs,estimate.bord,'b')
title('b estimate')

subplot(2,2,3)
plot(estimate.abs,drift0(estimate.abs,name).^2+volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.cord,'b')
title('b^2+s^2 estimate')

subplot(2,2,4)
plot(estimate.abs,volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.s2ord,'b')
title('s^2 estimate')


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Example A-2/ REGRESSION with errors in variables
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% following the second example of Fan & Truong - Annals of Statistics 1993
n = 5000;
name = 'truong';
W0 = 'symexp';
s0 = sqrt(3/7)*0.25;
WY = 'normal';
sY = 0.25;

%%%% SIMULATION
Obs = DeconvSimul(name,n,W0,s0,WY,sY);

%%%% ESTIMATION
estimate = DeconvEstimate(Obs.Z,Obs.W0,Obs.s0,Obs.Y);

subplot(2,2,1)
plot(estimate.abs,pdf('norm',estimate.abs,0.5,0.25),'r',estimate.abs,estimate.gord,'b')
title('density g estimate')
legend('true','estimate')

subplot(2,2,2)
plot(estimate.abs,drift0(estimate.abs,name),'r',estimate.abs,estimate.bord,'b')
title('b estimate')

subplot(2,2,3)
plot(estimate.abs,drift0(estimate.abs,name).^2+volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.cord,'b')
title('b^2+s^2 estimate')

subplot(2,2,4)
plot(estimate.abs,volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.s2ord,'b')
title('s^2 estimate')


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Example B-1/ AUTO-REGRESSION with errors in variables
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% following the second example of Fan & Truong - Annals of Statistics 1993
n = 5000;
name = 'M10';
W0 = 'normal';
s0 = 0.1;
WY = 'normal';
sY = 1;

%%%% SIMULATION
Obs = DeconvSimul(name,n,W0,s0,WY,sY);

%%%% ESTIMATION
estimate = DeconvEstimate(Obs.Z,Obs.W0,Obs.s0,Obs.Y);

subplot(2,2,1)
plot(estimate.abs,estimate.gord,'b')
title('density g estimate')

subplot(2,2,2)
plot(estimate.abs,drift0(estimate.abs,name),'r',estimate.abs,estimate.bord,'b')
title('b estimate')
legend('true','estimate')

subplot(2,2,3)
plot(estimate.abs,drift0(estimate.abs,name).^2+volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.cord,'b')
title('b^2+s^2 estimate')

subplot(2,2,4)
plot(estimate.abs,volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.s2ord,'b')
title('s^2 estimate')


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Example B-2/ AUTO-REGRESSION with errors in variables
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% following the second example of Fan & Truong - Annals of Statistics 1993
n = 5000;
name = 'M11';
W0 = 'symexp';
s0 = 0.1;
WY = 'normal';
sY = 1;

%%%% SIMULATION
Obs = DeconvSimul(name,n,W0,s0,WY,sY);

%%%% ESTIMATION
estimate = DeconvEstimate(Obs.Z,Obs.W0,Obs.s0,Obs.Y);

subplot(2,2,1)
plot(estimate.abs,estimate.gord,'b')
title('density g estimate')

subplot(2,2,2)
plot(estimate.abs,drift0(estimate.abs,name),'r',estimate.abs,estimate.bord,'b')
title('b estimate')
legend('true','estimate')

subplot(2,2,3)
plot(estimate.abs,drift0(estimate.abs,name).^2+volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.cord,'b')
title('b^2+s^2 estimate')

subplot(2,2,4)
plot(estimate.abs,volatility0(estimate.abs,name).^2,'r',estimate.abs,estimate.s2ord,'b')
title('s^2 estimate')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is part of the package EstimHidden devoted to the estimation of 
%
% 1/ the density of X in a convolution model where Z=X+noise1 is observed 
%
% 2/ the functions b (drift) and s^2 (volatility) in an "errors in variables" 
%    model where Z and Y are observed and assumed to follow:
%           Z=X+noise1 and Y=b(X)+s(X)*noise2.
%
% 3/ the functions b (drift) and s^2 (volatility) in an stochastic
%    volatility model where Z is observed and follows:
%           Z=X+noise1 and X_{i+1} = b(X_i) + s(X_i)*noise2
%
% in any cases the density of noise1 is known. We consider three cases for
% this density : Gaussian ('normal'), Laplace ('symexp') and log(Chi2)
% ('logchi2)
%
% See function DeconvEstimate.m and examples in files ExampleDensity.m and
% ExampleRegression.m
%
% Authors : F. COMTE and Y. ROZENHOLC 
%
%
% For more information, see the following references:
%
% DENSITY DECONVOLUTION
%%%%%%%%%%%%%%%%%%%%%%%
%
% 1/ "Penalized contrast estimator for density deconvolution", 
%    The Canadian Journal of Statistics, 34, 431-452, 2006.
%    b y  F .  C O M T E ,  Y .  R O Z E N H O L C ,  and M . - L .  T A U P I N 
%
% 2/ "Finite sample  penalization in adaptive density deconvolution", 
%    Journal of Statistical Computation and Simulation. 
%    Available online.
%    b y  F .  C O M T E ,  Y .  R O Z E N H O L C ,  and M . - L .  T A U P I N 
%
% 3/ "Adaptive density estimation for general ARCH models", 
%    Preprint HAL-CNRS : hal-00101417  at http://hal.archives-ouvertes.fr/
%    b y  F .  C O M T E ,  J. DEDECKER, and  M . - L .  T A U P I N . 
%
% REGRESSION and AUTO-REGRESSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 4/ "Nonparametric estimation of the regression function in an
%    errors-in-variables model", 
%    Statistica Sinica, 17, n�3, 1065-1090, 2007. 
%    b y  F .  C O M T E  and M . - L .  T A U P I N 
%
% 5/ "Adaptive estimation of the dynamics of a discrete time stochastic
%    volatility model", 
%    Preprint HAL-CNRS : hal-00170740 at http://hal.archives-ouvertes.fr/
%    by F .  C O M T E, C. LACOUR, and Y. R O Z E N H O L C . 
%
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 % Y o u  c a n  u s e  t h i s  s o f t w a r e  f o r  N O N - C O M M E R C I A L  U S E  O N L Y .  
 %
 % Y o u  c a n  d i s t r i b u t e  t h i s  s o f w a r e  u n c h a n g e d  a n d  o n l y  u n c h a n g e d ,  w h i c h  i m p l i e s 
 % i n c l u d i n g  a l l  f i l e s  f o u n d  i n  t h e  f o l d e r  c o i n t a i n n i n g  t h i s  f i l e . 
 %
 % T h i s  s o f t w a r e ,  a n d  a n y  p a r t  o f  i t ,  i s  p r o p o s e d  f o r  N O N - C O M M E R C I A L  U S E  
 % O N L Y .  
 %
 % P l e a s e ,  c o n t a c t  t h e  a u t h o r  f o r  a n d  b e f o r e  a n y  n o n - a c a d e m i c  u s e 
 % o f  t h i s  s o f t w a r e . 
 %
 % T o  r e p r o d u c e  t h i s  c o d e  o r  a n y  p a r t  o f  t h i s  c o d e  i n  t h e  o r i g i n a l  l a n g u a g e  
 % o r  i n  a n y  o t h e r  l a n g u a g e ,  f o r  c o m m e r c i a l  u s e ,  p l e a s e  c o n t a c t  t h e  A u t h o r 
 %
 % F o r  a c a d e m i c  p u r p o s e ,  c i t e  this package and t h e  c o n n e c t e d  p a p e r s . 
 %
 % C o r r e s p o n d i n g  a u t h o r  :  Y .  R o z e n h o l c ,  y v e s . r o z e n h o l c @ u n i v - p a r i s 5 . f r 
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Examples in files ExampleDensity.m and ExampleRegression.m
% 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

