function phimn=getFlexureCapacity(varargin)
% Hugo Esquivel, 2025.
% -

% Default:
Sd=1.30; % (C.9.2.9.1, ACI 350-06)

% Input:
for i=1:2:length(varargin)
    if strcmp(varargin{i},'Sd')
        Sd=varargin{i+1};
    elseif strcmp(varargin{i},'fc')
        fc=varargin{i+1}; % psi
    elseif strcmp(varargin{i},'fy')
        fy=varargin{i+1}; % psi
    elseif strcmp(varargin{i},'d')
        d=varargin{i+1}; % in
    elseif any(strcmp(varargin{i},{'Asovers','As over s'}))
        Asovers=varargin{i+1}; % in^2/in
    end
end

% Body:
a=Asovers/Sd*fy/(0.85*fc); % in (10.2.7, 10.2.7.1, ACI 350-06)

beta1=min([max([0.85-0.05/1000*(fc-4000),0.65]),0.85]); % (10.2.7.3, ACI 350-06)

epsst=0.003*(beta1*d/a-1); % (10.2, ACI 350-06)

if epsst<0.004, warning('epsst<0.004'), end % (10.3.5, ACI 350-06)

phi=min([max([0.90-250/3*(0.005-epsst),0.65]),0.90]); % (10.3.3, 10.3.4, 9.3.2.1, 9.3.2.2, ACI 350-06)

phimn=phi*Asovers/Sd*fy*(d-a/2); % lb*in/in (flexure flow; based on 10.2, 10.3, ACI 350-06)
end
