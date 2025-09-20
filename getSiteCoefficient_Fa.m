function Fa=getSiteCoefficient_Fa(varargin)
% Hugo Esquivel, 2025.
% -
% Site Coefficient Fa.

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

    elseif strcmp(varargin{i},'SS')
        SS=varargin{i+1}; % parameter based on ASCE 7-10...
    elseif strcmp(varargin{i},'Aa')
        Aa=varargin{i+1}; % parameter based on NSR-10...
    end
end

% Body:
switch buildingCode
    case 'ASCE 7-10' % Section 11.4.3 (Table 11.4-1), ASCE 7-10
        x=[0.25,0.50,0.75,1.00,1.25];

        switch siteClass
            case 'A'
                y=[0.8,0.8,0.8,0.8,0.8];

            case 'B'
                y=[1.0,1.0,1.0,1.0,1.0];

            case 'C'
                y=[1.2,1.2,1.1,1.0,1.0];

            case 'D'
                y=[1.6,1.4,1.2,1.1,1.0];

            case 'E'
                y=[2.5,1.7,1.2,0.9,0.9];
        end

        if SS<x(1)
            Fa=y(1);
        elseif SS>x(end)
            Fa=y(end);
        else
            Fa=interp1(x,y,SS);
        end

    case 'NSR-10' % Section A.2.4.5.5 (Table A.2.4-3), NSR-10
        x=[0.1,0.2,0.3,0.4,0.5];

        switch siteClass
            case 'A'
                y=[0.8,0.8,0.8,0.8,0.8];

            case 'B'
                y=[1.0,1.0,1.0,1.0,1.0];

            case 'C'
                y=[1.2,1.2,1.1,1.0,1.0];

            case 'D'
                y=[1.6,1.4,1.2,1.1,1.0];

            case 'E'
                y=[2.5,1.7,1.2,0.9,0.9];
        end

        if Aa<x(1)
            Fa=y(1);
        elseif Aa>x(end)
            Fa=y(end);
        else
            Fa=interp1(x,y,Aa);
        end
end
end
