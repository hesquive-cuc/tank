function Ie=getSeismicImportanceFactor(varargin)
% Hugo Esquivel, 2025.
% -
% Seismic Importance Factor (Section 11.5.1 (Table 1.5-2), ASCE 7-22).

% Input:
if nargin==1
    riskCategory=varargin{1};

else
    for i=1:2:length(varargin)
        if any(strcmpi(varargin{i},{'riskCategory','risk category'}))
            riskCategory=varargin{i+1};
        end
    end
end

if ~any(strcmp(riskCategory,{'I','II','III','IV'}))
    error('riskCategory must be I, II, III, or IV.')
end

% Body:
switch riskCategory
    case {'I','II'}
        Ie=1.00;

    case 'III'
        Ie=1.25;

    case 'IV'
        Ie=1.50;
end
end
