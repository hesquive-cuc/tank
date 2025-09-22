% Hugo Esquivel, 2025.
% -

clearvars; close all; clc;

% ----------------------------------------------------------------------------------------------------------------------
% INPUT:
% ----------------------------------------------------------------------------------------------------------------------
city='Barranquilla'; % Options: Barranquilla, Bogota
runCase='rectangularTank'; % Options: rectangularTank, circularTank

switch runCase
    case 'rectangularTank'
        HL=3.00; % m (design depth of stored liquid)
        L=5.00; % m (inside dimension of tank, parallel to the direction of motion)
        B=4.00; % m (inside dimension of tank, perpendicular to the direction of motion)

        switch city
            case 'Barranquilla'
                d=0.70; % m (height measured from liquid's surface at rest; i.e., tank's freeboard)

            case 'Bogota'
                d=1.50; % m (height measured from liquid's surface at rest; i.e., tank's freeboard)
        end

        tb=0.30; % m (base thickness)
        tw=0.30; % m (wall thickness)
        tr=0.25; % m (roof thickness)

        gammaL=10; % kN/m3 (specific weight of liquid; water in this case)
        gammac=24; % kN/m3 (specific weight of reinforced concrete)

        switch city
            case 'Barranquilla'
                Aa=0.10; % (Table A.2.3-2, NSR-10)
                Av=0.10; % (Table A.2.3-2, NSR-10)

            case 'Bogota'
                Aa=0.15; % (Table A.2.3-2, NSR-10)
                Av=0.20; % (Table A.2.3-2, NSR-10)
        end

        siteClass='D';
        riskCategory='III'; % (Table 1.5-1, ASCE 7-22)

        Ti=0.52; % s (fundamental period of vibration of structure's impulsive component; from SAP2000)

        Ri=3.0; % (Table 15.4-2, ASCE 7-22; recall that Ri = R)
        Rc=1.0; % (Rc is always equal to 1.0)

        numConvectiveSprings=3; % (number of rows of two springs each, oriented parallel to the L dimension)

    case 'circularTank'
        HL=3.00; % m (design depth of stored liquid)
        D=5.00; % m (inside diameter of tank)

        switch city
            case 'Barranquilla'
                d=0.80; % m (height measured from liquid's surface at rest; i.e., tank's freeboard)

            case 'Bogota'
                d=1.90; % m (height measured from liquid's surface at rest; i.e., tank's freeboard)
        end

        tb=0.30; % m (base thickness)
        tw=0.30; % m (wall thickness)
        tr=0.25; % m (roof thickness)

        gammaL=10; % kN/m3 (specific weight of liquid; water in this case)
        gammac=24; % kN/m3 (specific weight of reinforced concrete)

        switch city
            case 'Barranquilla'
                Aa=0.10; % (Table A.2.3-2, NSR-10)
                Av=0.10; % (Table A.2.3-2, NSR-10)

            case 'Bogota'
                Aa=0.15; % (Table A.2.3-2, NSR-10)
                Av=0.20; % (Table A.2.3-2, NSR-10)
        end

        siteClass='D';
        riskCategory='III'; % (Table 1.5-1, ASCE 7-22)

        Ti=0.52; % s (fundamental period of vibration of structure's impulsive component; from SAP2000)

        Ri=3.0; % (Table 15.4-2, ASCE 7-22; recall that Ri = R)
        Rc=1.0; % (Rc is always equal to 1.0)

        numConvectiveSprings=24; % (number of springs, oriented radially)
end
% ----------------------------------------------------------------------------------------------------------------------



% ----------------------------------------------------------------------------------------------------------------------
% BODY:
% ----------------------------------------------------------------------------------------------------------------------
g=9.81; % m/s^2 (gravity acceleration)

SS=3.75*Aa;
S1=1.80*Av;

buildingCode='NSR-10';
Fa=getSiteCoefficient_Fa('building code',buildingCode,'site class',siteClass,'Aa',Aa,'SS',SS);
Fv=getSiteCoefficient_Fv('building code',buildingCode,'site class',siteClass,'Av',Av,'S1',S1);

fprintf('Site coefficient Fa: %.2f.\n',Fa)
fprintf('Site coefficient Fv: %.2f.\n',Fv)

SMS=Fa*SS;
SM1=Fv*S1;

SDS=2/3*SMS; % (Eq. 11.4-1, ASCE 7-22; Eq. A.2.6-3, NSR-10)
SD1=2/3*SM1; % (Eq. 11.4-2, ASCE 7-22; Eq. A.2.6-1, NSR-10, evaluated at T = 1.0 s)

TS=SD1/SDS; % s (11.4.5.2, ASCE 7-22; Eq. A.2.6-2, NSR-10)
TL=2.4*Fv; % s (Eq. A.2.6-4, NSR-10)

Ie=getSeismicImportanceFactor('risk category',riskCategory);
SDC=getSeismicDesignCategory('risk category',riskCategory,'S1',S1,'SDS',SDS,'SD1',SD1);

fprintf('Seismic importance factor: %.2f.\n',Ie)
fprintf('Seismic design category: %s.\n',SDC)

% Design spectral response acceleration of structure's impulsive component:
if Ti<TS
    Sai=SDS; % (Eq. 15.7-7, ASCE 7-22; Eq. 9.4.1a, ACI 350.3-20)
elseif Ti<TL
    Sai=SD1/Ti; % (Eq. 15.7-8, ASCE 7-22; Eq. 9.4.1b, ACI 350.3-20)
else
    Sai=SD1*TL/Ti^2; % (Eq. 15.7-9, ASCE 7-22)
end

% Fundamental period of vibration of structure's convective component:
switch runCase
    case 'rectangularTank'
        ghat=3.16*g*tanh(3.16*HL/L); % m/s^2 (Eq. 9.2.4e, ACI 350.3-20; effective gravity acceleration)
        Tc=2*pi*sqrt(L/ghat); % s (Eq. 9.2.4f, ACI 350.3-20)

    case 'circularTank'
        ghat=3.68*g*tanh(3.68*HL/D); % m/s^2 (Eq. 9.3.4g, ACI 350.3-20; effective gravity acceleration)
        Tc=2*pi*sqrt(D/ghat); % s (Eq. 9.3.4h, ACI 350.3-20)
end

% Fundamental circular frequency of vibration of structure's convective component:
omegac=2*pi/Tc; % rad/s

% Design spectral response acceleration of structure's convective component:
if Tc<TL
    Sac=min([1.5*SD1/Tc,1.5*SDS]); % (Eq. 15.7-10, ASCE 7-22, modified; Eq. 9.4.2a, ACI 350.3-20)
else
    Sac=1.5*SD1*TL/Tc^2; % (Eq. 15.7-11, ASCE 7-22; Eq. 9.4.2b, ACI 350.3-20)
end

% Seismic response coefficient of structure's impulsive component:
Csi=max([Sai/(Ri/Ie),0.044*SDS*Ie,0.03]); % (Eq. 12.8-2, 15.4.1, Eq. 15.4-1, ASCE 7-22)

if S1>=0.6
    Csi=max([Csi,0.8*S1/(Ri/Ie)]); % (15.4.1, Eq. 15.4-2, ASCE 7-22)
end

% Seismic response coefficient of structure's convective component:
Csc=Sac/(Rc/Ie); % (Eq. 12.8-2, ASCE 7-22)

Hw=HL+d; % m (wall height)

switch runCase
    case 'rectangularTank'
        Wb=gammac*(B+2*tw)*(L+2*tw)*tb; % kN (base weight)
        Ww=gammac*2*(B+L+2*tw)*Hw*tw; % kN (wall weight)
        Wr=gammac*(B+2*tw)*(L+2*tw)*tr; % kN (roof weight)

        WL=gammaL*B*L*HL; % kN (liquid weight)

        Wi=tanh(0.866*L/HL)/(0.866*L/HL)*WL; % kN (Eq. 9.2.1a, ACI 350.3-20)
        Wc=0.264*L/HL*tanh(3.16*HL/L)*WL; % kN (Eq. 9.2.1b, ACI 350.3-20)

    case 'circularTank'
        Wb=gammac*1/4*pi*(D+2*tw)^2*tb; % kN (base weight)
        Ww=gammac*pi*(D+tw)*Hw*tw; % kN (wall weight)
        Wr=gammac*1/4*pi*(D+2*tw)^2*tr; % kN (roof weight)

        WL=gammaL*1/4*pi*D^2*HL; % kN (liquid weight)

        Wi=tanh(0.866*D/HL)/(0.866*D/HL)*WL; % kN (Eq. 9.3.1a, ACI 350.3-20)
        Wc=0.230*D/HL*tanh(3.68*HL/D)*WL; % kN (Eq. 9.3.1b, ACI 350.3-20)
end

% Inertial forces:
Pb=Csi*Wb; % kN (due to base weight)
Pw=Csi*Ww; % kN (due to wall weight)
Pr=Csi*Wr; % kN (due to roof weight)
Pi=Csi*Wi; % kN (due to liquid's impulsive weight)
Pc=Csc*Wc; % kN (due to liquid's convective weight)

% Seismic base shear at tank-substructure interface:
V=sqrt((Pb+Pw+Pr+Pi)^2+Pc^2); % kN (Eq. 4.1.2, ACI 350.3-20)

switch runCase
    case 'rectangularTank'
        % if L/HL<4/3
        %     hi=1/2*(1-3/16*L/HL)*HL; % m (Eq. 9.2.2a, ACI 350.3-20)
        % else
        %     hi=3/8*HL; % m (Eq. 9.2.2b, ACI 350.3-20)
        % end
        % 
        % hc=(1-(cosh(sqrt(10)*HL/L)-1)/(sqrt(10)*HL/L*sinh(sqrt(10)*HL/L)))*HL; % m (Eq. 9.2.2c, ACI 350.3-20)

        hi=3/8*HL; % m (equivalent to Eq. 9.2.2b, ACI 350.3-20; obtained from integrating half_Pixz(x,z) exactly)
        hc=(1-1/10*sqrt(10)*tanh(1/2*sqrt(10)*HL/L)*L/HL)*HL; % m (equivalent to Eq. 9.2.2c, ACI 350.3-20; obtained from integrating half_Pcxz(x,z) exactly)

    case 'circularTank'
        % if D/HL<4/3
        %     hi=1/2*(1-3/16*D/HL)*HL; % m (Eq. 9.3.2a, ACI 350.3-20)
        % else
        %     hi=3/8*HL; % m (Eq. 9.3.2b, ACI 350.3-20)
        % end
        % 
        % hc=(1-(cosh(3/2*sqrt(6)*HL/D)-1)/(3/2*sqrt(6)*HL/D*sinh(3/2*sqrt(6)*HL/D)))*HL; % m (Eq. 9.3.2c, ACI 350.3-20)

        hi=3/8*HL; % m (equivalent to Eq. 9.3.2b, ACI 350.3-20; obtained from integrating half_Pixtheta(x,theta) exactly)
        hc=(1-1/9*sqrt(6)*tanh(3/4*sqrt(6)*HL/D)*D/HL)*HL; % m (equivalent to Eq. 9.3.2c, ACI 350.3-20; obtained from integrating half_Pcxtheta(x,theta) exactly)
end

% Maximum vertical displacement of oscillating wave measured from liquid's surface at rest:
switch runCase
    case 'rectangularTank'
        % dmax=1/2*L*Sac*Ie; % m (Eq. 7.1a, ACI 350.3-20; simplified version)
        dmax=max([0.264*L*Ie/((2*g/(omegac^2*Sac*L)-1)*tanh(3.16*HL/L)),0.42*L*Ie*Sac]); % m (Eq. 7.1b, ACI 350.3-20, and Eq. 15.7-13, ASCE 7-22)

    case 'circularTank'
        % dmax=1/2*D*Sac*Ie; % m (Eq. 7.1c, ACI 350.3-20; simplified version)
        dmax=max([0.204*D*Ie/((2*g/(omegac^2*Sac*D)-1)*tanh(3.68*HL/D)),0.42*D*Ie*Sac]); % m (Eq. 7.1d, ACI 350.3-20, and Eq. 15.7-13, ASCE 7-22)
end

if d<dmax, warning('d<dmax'), end

% Spring constants for liquid's convective component:
switch runCase
    case 'rectangularTank'
        kc=2/numConvectiveSprings*(pi/Tc)^2*Wc/g; % kN/m (in the L direction)
        fprintf('Place %d rows, each consisting of two springs with stiffness kc = %.6f kN/m, at x = %.4f m and oriented parallel to the L dimension.\n',...
            numConvectiveSprings,kc,hc)

    case 'circularTank'
        kc=8/numConvectiveSprings*(pi/Tc)^2*Wc/g; % kN/m (in the radial direction)
        fprintf('Place %d springs with a stiffness of kc = %.6f kN/m every %.2fº at x = %.4f m.\n',...
            numConvectiveSprings,kc,360/numConvectiveSprings,hc)
end

numPoints=100;

switch runCase
    case 'rectangularTank'
        % Shape functions over the x-space:
        %   Domain:  x in [0,HL].
        %   Measure: dx.
        %   Hence:   int(N_x(x),x,0,HL) = 1.
        Nix=@(x) 3/2*(1-(x/HL).^2)*1/HL; % (impulsive shape function)
        Ncx=@(x) sqrt(10)*cosh(sqrt(10)*x/L)/sinh(sqrt(10)*HL/L)*1/L; % (convective shape function)

        % Shape functions over the (x,z)-space:
        %   Domain:  x in [0,HL], and z in [0,B].
        %   Measure: dx*dz.
        %   Hence:   int(int(N_xz(x,z),x,0,HL),z,0,B) = 1.
        Nixz=@(x,z) Nix(x)*1/B; % (impulsive shape function)
        Ncxz=@(x,z) Ncx(x)*1/B; % (convective shape function)

        % Impulsive distribution on each wall of width B due to liquid's impulsive weight:
        half_Pix=@(x) 1/2*Pi*Nix(x); % kN/m (R5.3.1, ACI 350.3-20)
        half_Pixz=@(x,z) 1/2*Pi*Nixz(x,z); % kPa (R5.3.1, ACI 350.3-20)

        % Convective distribution on each wall of width B due to liquid's convective weight:
        half_Pcx=@(x) 1/2*Pc*Ncx(x); % kN/m (R5.3.1, ACI 350.3-20)
        half_Pcxz=@(x,z) 1/2*Pc*Ncxz(x,z); % kPa (R5.3.1, ACI 350.3-20)

        % Total distribution on wall due to liquid's inertial weight:
        half_Ptx=@(x) half_Pix(x)+half_Pcx(x); % kPa
        half_Ptxz=@(x,z) half_Pixz(x,z)+half_Pcxz(x,z); % kPa

        x=linspace(0,HL,numPoints);
        z=linspace(0,B,numPoints);

        [X,Z]=meshgrid(x,z);

        max_half_Ptxz=max(max(half_Ptxz(X,Z))); % kPa

        figure

        % Impulsive distribution on wall:
        subplot(2,1,1)
        contourf(Z,X,half_Pixz(X,Z),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(B/2,hi,'ko',MarkerSize=10,LineWidth=2)
        title('Impulsive distribution on wall')
        xlabel('$B$ dimension (m)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")

        % Convective distribution on wall:
        subplot(2,1,2)
        contourf(Z,X,half_Pcxz(X,Z),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(B/2,hc,'ko',MarkerSize=10,LineWidth=2)
        title('Convective distribution on wall')
        xlabel('$B$ dimension (m)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")

        % Total distribution on wall:
        figure
        subplot(2,1,1)
        contourf(Z,X,half_Ptxz(X,Z),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(B/2,(hi*Pi+hc*Pc)/(Pi+Pc),'ko',MarkerSize=10,LineWidth=2)
        title('Total distribution on wall')
        xlabel('$B$ dimension (m)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")

    case 'circularTank'
        % Shape functions over the x-space:
        %   Domain:  x in [0,HL].
        %   Measure: dx.
        %   Hence:   int(N_x(x),x,0,HL) = 1.
        Nix=@(x) 3/2*(1-(x/HL).^2)*1/HL; % (impulsive shape function)
        Ncx=@(x) 3/2*sqrt(6)*cosh(3/2*sqrt(6)*x/D)/sinh(3/2*sqrt(6)*HL/D)*1/D; % (convective shape function)

        % Shape functions over the (x,theta)-space:
        %   Domain:  x in [0,HL], and theta in [-pi/2,pi/2].
        %   Measure: D/2*cos(theta)*dx*dtheta.
        %   Note:    the cos(theta) in the measure is due to summation of forces in the direction of motion.
        %   Hence:   int(int(N_xtheta(x,theta)*D/2*cos(theta),x,0,HL),theta,-pi/2,pi/2) = 1.
        Nixtheta=@(x,theta) 4/pi*Nix(x).*cos(theta)*1/D; % (impulsive shape function)
        Ncxtheta=@(x,theta) 4/pi*Ncx(x).*cos(theta)*1/D; % (convective shape function)

        % Impulsive distribution on wall due to liquid's impulsive weight:
        half_Pix=@(x) 1/2*Pi*Nix(x); % kN/m (R5.3.3, ACI 350.3-20)
        half_Pixtheta=@(x,theta) 1/2*Pi*Nixtheta(x,theta); % kPa (R5.3.3, ACI 350.3-20)

        % Convective distribution on wall due to liquid's convective weight:
        half_Pcx=@(x) 1/2*Pc*Ncx(x); % kN/m (R5.3.3, ACI 350.3-20)
        half_Pcxtheta=@(x,theta) 1/2*Pc*Ncxtheta(x,theta); % kPa (R5.3.3, ACI 350.3-20, modified)

        % Total distribution on wall due to liquid's inertial weight:
        half_Ptx=@(x) half_Pix(x)+half_Pcx(x); % kPa
        half_Ptxtheta=@(x,theta) half_Pixtheta(x,theta)+half_Pcxtheta(x,theta); % kPa

        x=linspace(0,HL,numPoints);
        theta=linspace(-pi,pi,numPoints);

        [X,Theta]=meshgrid(x,theta);

        max_half_Ptxtheta=max(max(half_Ptxtheta(X,Theta))); % kPa

        figure

        % Impulsive distribution on wall:
        subplot(2,1,1)
        contourf(Theta*180/pi,X,half_Pixtheta(X,Theta),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(0,hi,'ko',MarkerSize=10,LineWidth=2)
        title('Impulsive distribution on wall')
        xlabel('$\theta$ dimension (degrees)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")
        xticks(linspace(-180,180,numConvectiveSprings+1))

        % Convective distribution on wall:
        subplot(2,1,2)
        contourf(Theta*180/pi,X,half_Pcxtheta(X,Theta),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(0,hc,'ko',MarkerSize=10,LineWidth=2)
        title('Convective distribution on wall')
        xlabel('$\theta$ dimension (degrees)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")
        xticks(linspace(-180,180,numConvectiveSprings+1))

        % Total distribution on wall:
        figure
        subplot(2,1,1)
        contourf(Theta*180/pi,X,half_Ptxtheta(X,Theta),ShowText=true,LabelFormat="%0.1f kPa",FaceAlpha=0.25)
        hold on
        plot(0,(hi*Pi+hc*Pc)/(Pi+Pc),'ko',MarkerSize=10,LineWidth=2)
        title('Total distribution on wall')
        xlabel('$\theta$ dimension (degrees)',Interpreter="LaTeX")
        ylabel('$H_L$ dimension (m)',Interpreter="LaTeX")
        xticks(linspace(-180,180,numConvectiveSprings+1))
end
% ----------------------------------------------------------------------------------------------------------------------
