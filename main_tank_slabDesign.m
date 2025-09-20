% Hugo Esquivel, 2025.
% -

clearvars; close all; clc;

fprintf('SLAB DESIGN:\n')

% ----------------------------------------------------------------------------------------------------------------------
% INPUT:
% ----------------------------------------------------------------------------------------------------------------------
fc=4e3; % psi (compressive strength of concrete)
fy=60e3; % psi (yield strength of rebars)

h=12; % in (slab thickness)
cr=2; % in (slab cover)

% In direction-1, try:
rebar1dist='(1)#4@5"'; % /layer (rebar distribution in direction-1)

rf1=0.20; % percentage of reinforcement that contributes to tension hoop capacity in direction-1 (+F11)...
rm1=0.70; % percentage of reinforcement that contributes to flexure capacity in direction-1 (M11)...
rv1=1-(rf1+rm1); % percentage of reinforcement that contributes to in-plane shear capacity in direction-1 (F12)...

% In direction-2, try:
rebar2dist='(1)#4@5"'; % /layer (rebar distribution in direction-2)

rf2=0.20; % percentage of reinforcement that contributes to tension hoop capacity in direction-2 (+F22)...
rm2=0.70; % percentage of reinforcement that contributes to flexure capacity in direction-2 (M22)...
rv2=1-(rf2+rm2); % percentage of reinforcement that contributes to in-plane shear capacity in direction-2 (F12)...

% This script assumes that two layers of reinforcement are specified in the slab, such that:
% 50% of the reinforcement is distributed in the bottom face, and the rest in the top face.
numLayers=2; % (number of layers)
% ----------------------------------------------------------------------------------------------------------------------



% ----------------------------------------------------------------------------------------------------------------------
% POST-PROCESSING INPUT:
% ----------------------------------------------------------------------------------------------------------------------
sf=sscanf(rebar1dist,'(%d)#%d@%f"');

numRebars1=sf(1); % (number of rebars within bundle in direction-1)
rebar1=sprintf('#%d',sf(2)); % (bar size in direction-1)
s2=sf(3); % in (center-to-center spacing of rebars in direction-2)

db1=getRebarDiameter(rebar1); % in (rebar diameter in direction-1)
As1=numRebars1*getRebarArea(rebar1); % in^2/layer (rebar area within bundle in direction-1)

sf=sscanf(rebar2dist,'(%d)#%d@%f"');

numRebars2=sf(1); % (number of rebars within bundle in direction-2)
rebar2=sprintf('#%d',sf(2)); % (bar size in direction-2)
s1=sf(3); % in (center-to-center spacing of rebars in direction-1)

db2=getRebarDiameter(rebar2); % in (rebar diameter in direction-2)
As2=numRebars2*getRebarArea(rebar2); % in^2/layer (rebar area within bundle in direction-2)

rho1=numLayers*As1/(s2*h);
rho2=numLayers*As2/(s1*h);
% ----------------------------------------------------------------------------------------------------------------------


fprintf('\n')


% ----------------------------------------------------------------------------------------------------------------------
% DIRECTION 1:
% ----------------------------------------------------------------------------------------------------------------------
fprintf('Considering %s in direction-1...\n',rebar1dist)

dbmin1=0.50; % in (7.12.2.2, ACI 350-06)
if db1<dbmin1, warning('db1<dbmin1'); end

smax1=min([2*h,12]); % in (7.6.5, 7.12.2.2, ACI 350-06)
if s1>smax1, warning('s1>smax1'); end

rhomin1=max([numLayers*3*sqrt(fc)/fy,numLayers*200/fy,0.0050]); % (10.5.1, 7.12.2.1-grade60-withoutJoints, ACI 350-06)
if rho1<rhomin1, warning('rho1<rhomin1'); end

d=h-cr-(db1+db2)/2; % in (effective shear depth)

% hoop design:
Asovers=rf1*numLayers*As1/s2; % in^2/in
phifn1=getHoopCapacityRange('Asovers',Asovers,'h',h,'fc',fc,'fy',fy); % lb/in
fprintf('  phi*fn1:    [%10.4f, %10.4f] kN/m...   compare to F11 range.\n',phifn1/1000*4.45/0.0254)

% flexure design:
Asovers=rm1*As1/s2; % in^2/in
phimn1=getFlexureCapacity('Asovers',Asovers,'d',d,'fc',fc,'fy',fy); % lb*in/in
fprintf('  phi*mn1:    [%10.4f, %10.4f] kN*m/m... compare to M11 range.\n',[-1,1]*phimn1/1000*4.45)

% in-plane shear design:
Asovers=rv1*numLayers*As1/s2; % in^2/in
phivn1in=getInPlaneShearCapacity('Asovers',Asovers,'h',h,'fc',fc,'fy',fy); % lb/in
fprintf('  phi*vn1in:  [%10.4f, %10.4f] kN/m...   compare to F12 range.\n',[-1,1]*phivn1in/1000*4.45/0.0254)

% out-plane shear design:
phivn1out=getOutPlaneShearCapacity('d',d,'fc',fc); % lb/in
fprintf('  phi*vn1out: [%10.4f, %10.4f] kN/m...   compare to V13 range.\n',[-1,1]*phivn1out/1000*4.45/0.0254)
% ----------------------------------------------------------------------------------------------------------------------


fprintf('\n')


% ----------------------------------------------------------------------------------------------------------------------
% DIRECTION 2:
% ----------------------------------------------------------------------------------------------------------------------
fprintf('Considering %s in direction-2...\n',rebar2dist)

dbmin2=0.50; % in (7.12.2.2, ACI 350-06)
if db2<dbmin2, warning('db2<dbmin2'); end

smax2=min([2*h,12]); % in (7.6.5, 7.12.2.2, ACI 350-06)
if s2>smax2, warning('s2>smax2'); end

rhomin2=max([numLayers*3*sqrt(fc)/fy,numLayers*200/fy,0.0050]); % (10.5.1, 7.12.2.1-grade60-withoutJoints, ACI 350-06)
if rho2<rhomin2, warning('rho2<rhomin2'); end

d=h-cr-(db1+db2)/2; % in (effective shear depth)

% hoop design:
Asovers=rf2*numLayers*As2/s1; % in^2/in
phifn2=getHoopCapacityRange('Asovers',Asovers,'h',h,'fc',fc,'fy',fy); % lb/in
fprintf('  phi*fn2:    [%10.4f, %10.4f] kN/m...   compare to F22 range.\n',phifn2/1000*4.45/0.0254)

% flexure design:
Asovers=rm2*As2/s1; % in^2/in
phimn2=getFlexureCapacity('Asovers',Asovers,'d',d,'fc',fc,'fy',fy); % lb*in/in
fprintf('  phi*mn2:    [%10.4f, %10.4f] kN*m/m... compare to M22 range.\n',[-1,1]*phimn2/1000*4.45)

% in-plane shear design:
Asovers=rv2*numLayers*As2/s1; % in^2/in
phivn2in=getInPlaneShearCapacity('Asovers',Asovers,'h',h,'fc',fc,'fy',fy); % lb/in
fprintf('  phi*vn2in:  [%10.4f, %10.4f] kN/m...   compare to F12 range.\n',[-1,1]*phivn2in/1000*4.45/0.0254)

% out-plane shear design:
phivn2out=getOutPlaneShearCapacity('d',d,'fc',fc); % lb/in
fprintf('  phi*vn2out: [%10.4f, %10.4f] kN/m...   compare to V23 range.\n',[-1,1]*phivn2out/1000*4.45/0.0254)
% ----------------------------------------------------------------------------------------------------------------------
