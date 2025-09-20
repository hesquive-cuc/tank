function phifn_range=getHoopCapacityRange(varargin)
% Hugo Esquivel, 2025.
% -

% Default:
Sd=1.65; % (C.9.2.9.2, ACI 350-06)

% Input:
for i=1:2:length(varargin)
    if strcmp(varargin{i},'Sd')
        Sd=varargin{i+1};
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
phifn_range=zeros(1,2);

phi=0.65;
phifn=0.80*phi*0.85*fc*h; % lb/in
phifn_range(1)=-phifn; % lb/in (compression hoop flow)

phi=0.90;
phifn=phi*Asovers/Sd*fy; % lb/in
phifn_range(2)=phifn; % lb/in (tension hoop flow)
end
