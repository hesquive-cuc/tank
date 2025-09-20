function SDC=getSeismicDesignCategory(varargin)
% Hugo Esquivel, 2025.
% -
% Seismic Design Category (Section 11.6, ASCE 7-22).

% Input:
for i=1:2:length(varargin)
    if any(strcmpi(varargin{i},{'riskCategory','risk category'}))
        riskCategory=varargin{i+1};

        if ~any(strcmp(riskCategory,{'I','II','III','IV'}))
            error('riskCategory must be I, II, III, or IV.')
        end
        
    elseif strcmp(varargin{i},'S1')
        S1=varargin{i+1};
    elseif strcmp(varargin{i},'SDS')
        SDS=varargin{i+1};
    elseif strcmp(varargin{i},'SD1')
        SD1=varargin{i+1};
    end
end

% Body:
if S1>=0.75
    switch riskCategory
        case {'I','II','III'}
            SDC='E';

        case 'IV'
            SDC='F';
    end

else
    switch riskCategory
        case {'I','II','III'}
            if SDS<1/6
                SDC='A';
            elseif SDS<2/6
                SDC='B';
            elseif SDS<3/6
                SDC='C';
            else
                SDC='D';
            end

            if SD1<1/15
                SDC=char(max([SDC,'A']));
            elseif SD1<2/15
                SDC=char(max([SDC,'B']));
            elseif SD1<3/15
                SDC=char(max([SDC,'C']));
            else
                SDC=char(max([SDC,'D']));
            end

        case 'IV'
            if SDS<1/6
                SDC='A';
            elseif SDS<2/6
                SDC='C';
            else
                SDC='D';
            end

            if SD1<1/15
                SDC=char(max([SDC,'A']));
            elseif SD1<2/15
                SDC=char(max([SDC,'C']));
            elseif SD1<3/15
                SDC=char(max([SDC,'D']));
            else
                SDC=char(max([SDC,'E'])); % added to be on the conservative side...
            end
    end
end
end
