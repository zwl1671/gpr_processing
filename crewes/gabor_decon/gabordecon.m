function [trout,tvs_op]=gabordecon(trin,t,twin,tinc,tsmo,fsmo,ihyp,stab,phase,p,gdb,transforms,taperpct)
% GABORDECON: seismic deconvolution using the Gabor transform with Fourier operator design.
%
% [trout,tvs_op]=gabordecon(trin,t,twin,tinc,tsmo,fsmo,ihyp,stab,phase,p,gdb)
%
% GABORDECON deconvolves a seismic trace using the Gabor transform as described
%     by Margrave and Lamoureux (2001). This version uses modified Gaussian windowing
%     and designs the operator from the Fourier-Gabor spectrum of the data. 
%     Spectral smoothing may be boxcar or hyperbolic. The operator may be split
%     between analysis and synthesis windows or applied entirely in either one.
%
% trin ... input trace
% t ... time coordinate for trin
% twin ... half width of gaussian temporal window (sec)
% tinc ... temporal increment between windows (sec)
% tsmo ... size of temporal smoother (sec)
% fsmo ... size of frequency smoother (Hz)
% ihyp ... 1 for hyperbolic smoothing, 0 for ordinary boxcar smoothing
%    Hyperbolic smoothing averages the gabor magnitude spectrum along
%    curves of t*f=constant.
% ************** Default = 1 ***********
% stab ... stability constant
%   ************* Default = 0 **************
% phase ... 0 for zero phase, 1 for minimum phase
%   ************* Default = 1 **************
% p ... exponent that determines the analysis and synthesis windows. If g
%   is a modified Gaussian forming a partition, then the analysis window is
%   g.^p and the synthesis window is g.^(1-p). p mus lie in the interval
%   [0,1]. p=1 means the synthesis window is unity and p=0 means the
%   analysis window is unity.
% ***************** default p=1 ********************************
% ********* values other than 1 not currently recommended ******
% gdb ... number of decibels below 1 at which to truncate the Gaussian
%   windows. Used by fgabor. This should be a positive number. Making this
%   larger increases the size of the Gabor transform but gives marginally
%   better performance. Avoid values smaller than 20. Note that many gdb
%   values will result in identical windows because the truncated windows
%   are always expanded to be a power of 2 in length.
% ************** default = 60 ***************
%
% trout ... deconvolved result
% tvs_op ... complex-valued gabor spectrum of the operator. That is,
%   GaborSpectrum(trout) = GaborSpectrum(trin).*tvs_op
%
% by G.F. Margrave, May 2001 updated July 2009, July 2011, Feb 2013
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.
 
% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by 
% its author (identified above) and the CREWES Project.  The CREWES 
% project may be contacted via email at:  crewesinfo@crewes.org
% 
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the 
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may 
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers 
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any 
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE

%hidden parameters
% transforms ... must be one of [1,2,3] with the meaning
%               1 : use old transforms without normalization
%               2 : use old transforms with normalization
%               3 : use new transforms without normalization
%               4 : use new transforms with normalization
% ************* default = 4 ************
% taperpct = size of taper applied to the end of the trace (max time)
%                 expressed as a percent of twin
% ************** default = 200% *********************
% taperpct has a mysteriously beneficial effect. Setting it to zero
% degrades the result in the latter half of the trace

if(nargin<7); ihyp=1; end
if(nargin<8); stab=0; end
if(nargin<9); phase=1; end
if(nargin<10); p=1; end
if(nargin<11); gdb=60; end
if(nargin<12); transforms=4; end
if(nargin<13); taperpct=200; end
normflag=0;
if(transforms==2 || transforms == 4)
    normflag=1;%means we will normalize the Gaussians 
end

[m,n]=size(trin);
if((m-1)*(n-1)~=0)
    error('gabordecon can currently handle only single traces. You need to write a loop')
end
if(m==1)
    trin=trin.';
    %force column vector
end

%scale taperpct to the trace length
taperpct=taperpct*twin/max(t);
%taper trace
if(taperpct>0)
   trin=trin.*mwhalf(length(trin),taperpct);
end


%compute the tvs
if(transforms==1 || transforms==2)
    padflag=1;
    [tvs,trow,fcol]=fgabor_old(trin,t,twin,tinc,padflag,normflag,0);
else
    [tvs,trow,fcol,normf_tout]=fgabor(trin,t,twin,tinc,p,gdb,normflag);
end

%stabilize
%find the minimum maximum
tmp=max(abs(tvs),[],2);%Find the maxima of each spectrum
amax=abs(min(tmp));

dt=trow(2)-trow(1);
df=fcol(2)-fcol(1);
nt=round(tsmo/dt)+1;
nf=round(fsmo/df)+1;

if(~ihyp)
	% smooth with a boxcar
	tvs_op=conv2(abs(tvs)+stab*amax,ones(nt,nf),'same');
else
    %hyperbolic smoothing
    if(normflag==1)
%         [tvsh,smooth,smodev,tflevels]=hypersmooth(abs(tvs).*normf_tout(:,ones(size(fcol))),trow,fcol,100);
        [tvsh,smooth,smodev,tflevels]=hypersmooth(abs(tvs),trow,fcol,100);
    else
        [tvsh,smooth,smodev,tflevels]=hypersmooth(abs(tvs),trow,fcol,100);
    end
    %estimate wavelet
    w=mean(abs(tvs)./tvsh);
    w=convz(w,ones(1,nf))/nf;
    tvs_op=tvsh.*w(ones(length(trow),1),:);
    %estimate wavelet
%     w=abs(tvs)./tvsh;
%     w=conv2(w,ones(nt,nf),'same');
%     %final operator
%     tvs_op=w.*tvsh;
    second_iter=0;
    if(second_iter)
        tmp=abs(tvs)./tvs_op;
        tmp2=hypersmooth(tmp,trow,fcol,100);
        tvs_op=tvs_op.*tmp2;
    end
%     w=mean(abs(tvs)./tvsh);
%     w=convz(w,ones(1,nf))/nf;
%     tvs_op=tvsh.*w(ones(length(trow),1),:);
    %stabilize
    amax=max(tvs_op(:));
    ind=find(tvs_op<stab*amax);
    if(~isempty(ind))
        tvs_op(ind)=stab*amax;
    end
end

%phase if required and invert
if phase==1
  %   tvs_op=exp(-conj(hilbert(log(tvs_op)'))).'; %wrong method
    L1=1:length(fcol);L2=length(fcol)-1:-1:2;
    symspec=[tvs_op(:,L1) tvs_op(:,L2)];%create neg freqs for Hilbert transform
    symspec2=hilbert(log(symspec')).';%transposing to force hilbert to work along frequency
    tvs_op=exp(-conj(symspec2(:,L1)));%toss negative freqs
else
    tvs_op=1 ./tvs_op;
end

%deconvolve

tvs=tvs.*tvs_op;
% tvs=ones(size(tvs)).*tvs_op;

%inverse transform
if(transforms==1 || transforms==2 )
    trout=igabor_old(tvs,fcol);
else
    trout=igabor(tvs,trow,fcol,twin,tinc,p,gdb,normflag);
end
trout=trout(1:length(trin));%truncate to length of input
trout=balans(trout,trin);%balance rms power to that of input
