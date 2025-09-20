function Ab=getRebarArea(rebarSize,varargin)
% Hugo Esquivel, 2025.
% -

switch rebarSize
    case '#2'
        Ab=0.049; % in^2
    case '#3'
        Ab=0.11; % in^2
    case '#4'
        Ab=0.20; % in^2
    case '#5'
        Ab=0.31; % in^2
    case '#6'
        Ab=0.44; % in^2
    case '#7'
        Ab=0.60; % in^2
    case '#8'
        Ab=0.79; % in^2
    case '#9'
        Ab=1.00; % in^2
    case '#10'
        Ab=1.27; % in^2
    case '#11'
        Ab=1.56; % in^2
    case '#14'
        Ab=2.25; % in^2
    case '#18'
        Ab=4.00; % in^2
end

if length(varargin)==2
    if any(strcmpi(varargin{1},{'unit','units'}))
        if ~any(strcmpi(varargin{2},{'in','inch','inches'}))
            if any(strcmpi(varargin{2},{'m','meter','meters'}))
                Ab=Ab*0.0254^2; % m^2
            else
                warning('%s is not recognized as a valid unit... using inches instead.',varargin{2})
            end
        end
    end
end
end
