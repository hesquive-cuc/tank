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
a=Asovers/Sd*fy/(0.85*fc); % in/in

beta1=min([max([0.85-0.05/1000*(fc-4000),0.65]),0.85]);

phi=min([max([0.90-10/9*(a/(beta1*d)-3/8),0.65]),0.90]);

if phi<0.817, warning('phi<0.817'); end % (10.3.5, ACI 350-06)

phimn=phi*Asovers/Sd*fy*(d-a/2); % lb*in/in (flexure flow)
end
