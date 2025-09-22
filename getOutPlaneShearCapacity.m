function phivn=getOutPlaneShearCapacity(varargin)
% Hugo Esquivel, 2025.
% -

% Default:
lambda=1.0; % assuming normalweight concrete...

% Input:
for i=1:2:length(varargin)
    if strcmp(varargin{i},'lambda')
        lambda=varargin{i+1};
    elseif strcmp(varargin{i},'fc')
        fc=varargin{i+1}; % psi
    elseif strcmp(varargin{i},'d')
        d=varargin{i+1}; % in
    end
end

% Body:
phi=0.75; % (9.3.2.3, ACI 350-06)
rootfc=min([sqrt(fc),100]); % psi (11.1.2, ACI 350-06)

phivn=phi*2*lambda*rootfc*d; % lb/in (out-plane shear flow; based on 11.1.1, 11.3.1.1, ACI 350-06, reinforcement is neglected)
end
