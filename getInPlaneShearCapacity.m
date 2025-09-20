function phivn=getInPlaneShearCapacity(varargin)
% Hugo Esquivel, 2025.
% -

% Default:
Sd=1.30; % (C.9.2.9.3, ACI 350-06)
lambda=1.0;

% Input:
for i=1:2:length(varargin)
    if strcmp(varargin{i},'Sd')
        Sd=varargin{i+1};
    elseif strcmp(varargin{i},'lambda')
        lambda=varargin{i+1};
    elseif strcmp(varargin{i},'fc')
        fc=varargin{i+1}; % psi
    elseif strcmp(varargin{i},'fy')
        fy=varargin{i+1}; % psi
    elseif strcmp(varargin{i},'h')
        h=varargin{i+1}; % in
    elseif any(strcmp(varargin{i},{'Asovers','As over s'}))
        Asovers=varargin{i+1}; % in^2/in
    end
end

% Body:
phi=0.75;
rootfc=min([sqrt(fc),100]); % psi

phivn=phi*6/5*min([2*lambda*rootfc*h+Asovers/Sd*fy,10*rootfc*h]); % lb/in (in-plane shear flow)
end
