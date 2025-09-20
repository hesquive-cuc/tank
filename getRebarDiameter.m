function db=getRebarDiameter(rebarSize,varargin)
% Hugo Esquivel, 2025.
% -

switch rebarSize
    case '#2'
        db=0.250; % in
    case '#3'
        db=0.375; % in
    case '#4'
        db=0.500; % in
    case '#5'
        db=0.625; % in
    case '#6'
        db=0.750; % in
    case '#7'
        db=0.875; % in
    case '#8'
        db=1.000; % in
    case '#9'
        db=1.128; % in
    case '#10'
        db=1.270; % in
    case '#11'
        db=1.410; % in
    case '#14'
        db=1.693; % in
    case '#18'
        db=2.257; % in
end

if length(varargin)==2
    if any(strcmpi(varargin{1},{'unit','units'}))
        if ~any(strcmpi(varargin{2},{'in','inch','inches'}))
            if any(strcmpi(varargin{2},{'m','meter','meters'}))
                db=db*0.0254; % m
            else
                warning('%s is not recognized as a valid unit... using inches instead.',varargin{2})
            end
        end
    end
end
end
