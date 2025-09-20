function Fv=getSiteCoefficient_Fv(varargin)
% Hugo Esquivel, 2025.
% -
% Site Coefficient Fv.

% Input:
for i=1:2:length(varargin)
    if any(strcmpi(varargin{i},{'buildingCode','building code'}))
        buildingCode=varargin{i+1};

        if ~any(strcmp(buildingCode,{'ASCE 7-10','NSR-10'}))
            error('buildingCode must be ASCE 7-10, or NSR-10.')
        end

    elseif any(strcmpi(varargin{i},{'siteClass','site class'}))
        siteClass=varargin{i+1};

        if ~any(strcmp(siteClass,{'A','B','C','D','E'}))
            error('siteClass must be A, B, C, D, or E.')
        end

    elseif strcmp(varargin{i},'S1')
        S1=varargin{i+1}; % parameter based on ASCE 7-10...
    elseif strcmp(varargin{i},'Av')
        Av=varargin{i+1}; % parameter based on NSR-10...
    end
end

% Body:
switch buildingCode
    case 'ASCE 7-10' % Section 11.4.3 (Table 11.4-2), ASCE 7-10
        x=[0.1,0.2,0.3,0.4,0.5];

        switch siteClass
            case 'A'
                y=[0.8,0.8,0.8,0.8,0.8];

            case 'B'
                y=[1.0,1.0,1.0,1.0,1.0];

            case 'C'
                y=[1.7,1.6,1.5,1.4,1.3];

            case 'D'
                y=[2.4,2.0,1.8,1.6,1.5];

            case 'E'
                y=[3.5,3.2,2.8,2.4,2.4];
        end

        if S1<x(1)
            Fv=y(1);
        elseif S1>x(end)
            Fv=y(end);
        else
            Fv=interp1(x,y,S1);
        end

    case 'NSR-10' % Section A.2.4.5.6 (Table A.2.4-4), NSR-10
        x=[0.1,0.2,0.3,0.4,0.5];

        switch siteClass
            case 'A'
                y=[0.8,0.8,0.8,0.8,0.8];

            case 'B'
                y=[1.0,1.0,1.0,1.0,1.0];

            case 'C'
                y=[1.7,1.6,1.5,1.4,1.3];

            case 'D'
                y=[2.4,2.0,1.8,1.6,1.5];

            case 'E'
                y=[3.5,3.2,2.8,2.4,2.4];
        end

        if Av<x(1)
            Fv=y(1);
        elseif Av>x(end)
            Fv=y(end);
        else
            Fv=interp1(x,y,Av);
        end
end
end
