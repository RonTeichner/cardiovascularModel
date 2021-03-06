function [Plv, Prv, Pperi, Pspt, Plvf, Prvf, Vspt, Vlvf, Vrvf, debugVsptSolDiff, errVspt, VsptViaLinearSolver] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,previousVspt,sPreviousValuesForLinearSolver,sModelParams,sSimParams)
% function [Plv, Prv, Pperi, Plvf, Prvf, Vspt, Vlvf, Vrvf, debugVsptSolDiff, errVspt] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,previousVspt,sModelParams,sSimParams)
% This function calculates the pressures of the ventricles of the heart
%
% INPUTS:
% driverFuncVal - the current elastance of the ventricles [no-units]
% Vlv - volume of the left ventricle [l]
% Vrv - volume of the left ventricle [l]
% previousVspt - previous value of Vspt, to help the solver [l]
% sPreviousValuesForLinearSolver - values to have the derivatives at the
%   previous point
% sModelParams
% sSimParams
%
% OUTPUTS:
% Plv - pressure at the left ventricle [mmHg]
% Prv - pressure at the right ventricle [mmHg]
% Pperi - pressure at the pericardium [mmHg]
% Pspt, Plvf, Prvf - non physical pressures at left,right free walls [mmHg]
% Vspt, Vlvf, Vrvf - non physical volumes at left,right free walls and at
%   septum free wall [l]
% debugVsptSolDiff - Vspt solution diff for debug (solver performance
%   analisys)
% errVspt - true in case no solution found for Vspt
% VsptViaLinearSolver - Vspt via linear solver - taylor serie around
%   previous Vspt value
% Ron Teichner, 01.12.2018

enableVsptFigure = false;

errVspt = false;

funcSym = 'f'; sInputs.V = (Vlv+Vrv); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0] = deal(sModelParams.sPcd.P0,sModelParams.sPcd.lambda,sModelParams.sPcd.V0);
Pperi = sModelParams.Pa_to_mmHg*1e3*cardioUtilityFunctions(funcSym,sInputs,sFuncParams) + sModelParams.Ppl; % [mmHg]
% 'f' function has units of [kPa]

useMatlabSolver = isempty(previousVspt);
VsptRes = 10e-6; VsptSearchMargins = 0.5e-3; % [l]
[Vspt,Vlvf,Vrvf,Plvf,Prvf,Pspt,debugVsptSolDiff] = VsptSolver(useMatlabSolver,previousVspt,Vlv,Vrv,driverFuncVal,enableVsptFigure,VsptRes,VsptSearchMargins,sModelParams,sSimParams);

% linear solver for impression only:
VsptViaLinearSolver = VsptLinearSolver(sPreviousValuesForLinearSolver,Vlv,Vrv,driverFuncVal,sModelParams,sSimParams);

%% continue with calculations:
if numel(Vspt) == 0
    display('CalcVentriclesPressures: no solution found for Vspt');
    display(['debugVsptSolDiff: ',num2str(debugVsptSolDiff),' [mmHg]'])
    %keyboard
    [Plv, Prv, Pperi, Pspt, Plvf, Prvf, Vspt, Vlvf, Vrvf, debugVsptSolDiff] = deal(0);
    errVspt = true;
    return;
end

Plvf = sModelParams.Pa_to_mmHg * 1e3*Plvf; % [mmHg]
Prvf = sModelParams.Pa_to_mmHg * 1e3*Prvf; % [mmHg]
Pspt = sModelParams.Pa_to_mmHg * 1e3*Pspt; % [mmHg]

Plv = Plvf + Pperi; % [mmHg]
Prv = Prvf + Pperi; % [mmHg]

end

function [Vspt,Vlvf,Vrvf,Plvf,Prvf,Pspt,debugVsptSolDiff] = VsptSolver(useMatlabSolver,previousVspt,Vlv,Vrv,driverFuncVal,enableVsptFigure,VsptRes,VsptSearchMargins,sModelParams,sSimParams)
switch useMatlabSolver
    case true
        % matlab solver is very slow -> use it only at beginning:
        if isempty(previousVspt)
            syms VsptSym
            
            VlvfSym = Vlv + VsptSym; % [l]
            VrvfSym = Vrv - VsptSym; % [l]
            
            funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VsptSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sSPT.P0,sModelParams.sSPT.lambda,sModelParams.sSPT.V0, sModelParams.sSPT.Ees, sModelParams.sSPT.Vd);
            PsptSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
            
            funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VlvfSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sLvf.P0,sModelParams.sLvf.lambda,sModelParams.sLvf.V0, sModelParams.sLvf.Ees, sModelParams.sLvf.Vd);
            PlvfSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
            
            funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VrvfSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sRvf.P0,sModelParams.sRvf.lambda,sModelParams.sRvf.V0, sModelParams.sRvf.Ees, sModelParams.sRvf.Vd);
            PrvfSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
            
            Vspt = double(vpasolve(PsptSym + PrvfSym - PlvfSym , VsptSym)); % [l]
            
            Vlvf = double(subs(VlvfSym, VsptSym, Vspt)); % [l]
            Vrvf = double(subs(VrvfSym, VsptSym, Vspt)); % [l]
            Plvf = double(subs(PlvfSym, VsptSym, Vspt)); % [kPa]
            Prvf = double(subs(PrvfSym, VsptSym, Vspt)); % [kPa]
            Pspt = double(subs(PsptSym, VsptSym, Vspt)); % [kPa]
            
            debugVsptSolDiff = abs(Pspt - (Plvf - Prvf));
        else
            
            % make best effort:
            display(['VsptSolver best effort starts']);
            %tic;
            VsptRes = 1e-6; VsptSearchMargins = 3e-3; % [sec]
            sSimParamsTmp = sSimParams;
            sSimParamsTmp.VsptSolutionDiffMax = 100;
            [Vspt,Vlvf,Vrvf,Plvf,Prvf,Pspt,debugVsptSolDiff] = VsptSolver(false,previousVspt,Vlv,Vrv,driverFuncVal,enableVsptFigure,VsptRes,VsptSearchMargins,sModelParams,sSimParamsTmp);
            %tVsptSolver = toc;
            %display(['VsptSolver best effort ends after ',num2str(tVsptSolver),' sec']);
            
        end
    case false
        VsptValsLimits = VsptSearchMargins*[-1,1] + previousVspt; % [l]
        VsptVals = VsptValsLimits(1) : VsptRes : VsptValsLimits(2);
        
        VlvfVals = Vlv + VsptVals; % [l]
        VrvfVals = Vrv - VsptVals; % [l]
        
        funcSym = 'g';
        %sInputs.V = VsptVals; sInputs.e = driverFuncVal; sFuncParams.P0 = sModelParams.sSPT.P0; sFuncParams.lambda = sModelParams.sSPT.lambda; sFuncParams.V0 = sModelParams.sSPT.V0; sFuncParams.Ees = sModelParams.sSPT.Ees; sFuncParams.Vd = sModelParams.sSPT.Vd;
        [sInputs.V, sInputs.e] = deal(VsptVals,driverFuncVal); 
        [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sSPT.P0,sModelParams.sSPT.lambda,sModelParams.sSPT.V0, sModelParams.sSPT.Ees, sModelParams.sSPT.Vd);
        PsptVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
        
        funcSym = 'g'; 
        [sInputs.V, sInputs.e] = deal(VlvfVals,driverFuncVal); 
        [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sLvf.P0,sModelParams.sLvf.lambda,sModelParams.sLvf.V0, sModelParams.sLvf.Ees, sModelParams.sLvf.Vd);
        PlvfVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
        
        funcSym = 'g'; 
        [sInputs.V, sInputs.e] = deal(VrvfVals,driverFuncVal); 
        [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sRvf.P0,sModelParams.sRvf.lambda,sModelParams.sRvf.V0, sModelParams.sRvf.Ees, sModelParams.sRvf.Vd);
        PrvfVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
        
        [debugVsptSolDiff,solutionIdx] = min(abs(PsptVals - (PlvfVals-PrvfVals)));
        Vspt = VsptVals(solutionIdx);
        
        debugVsptSolDiff = sModelParams.Pa_to_mmHg * 1e3*debugVsptSolDiff; % [mmHg]
        %display(['debugVsptSolDiff: ',num2str(debugVsptSolDiff)]);
        if debugVsptSolDiff < sSimParams.VsptSolutionDiffMax
            [Vlvf,Vrvf,Plvf,Prvf,Pspt] = deal(VlvfVals(solutionIdx),VrvfVals(solutionIdx),PlvfVals(solutionIdx),PrvfVals(solutionIdx),PsptVals(solutionIdx));
        else
            [Vspt,Vlvf,Vrvf,Plvf,Prvf,Pspt,debugVsptSolDiff] = VsptSolver(true,previousVspt,Vlv,Vrv,driverFuncVal,enableVsptFigure,VsptRes,VsptSearchMargins,sModelParams,sSimParams);
        end
end

%% graphical investigation of numeric solution:
if enableVsptFigure
    maxPressuretoDisplay = 200; minPressuretoDisplay = -10; % [mmHg]
    VsptRes = 1e-6; % [l]
    VsptVals = 0:VsptRes:20e-3;
    VlvfVals = Vlv + VsptVals; % [l]
    VrvfVals = Vrv - VsptVals; % [l]
    
    funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VsptVals,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sSPT.P0,sModelParams.sSPT.lambda,sModelParams.sSPT.V0, sModelParams.sSPT.Ees, sModelParams.sSPT.Vd);
    PsptVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
    
    funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VlvfVals,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sLvf.P0,sModelParams.sLvf.lambda,sModelParams.sLvf.V0, sModelParams.sLvf.Ees, sModelParams.sLvf.Vd);
    PlvfVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
    
    funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VrvfVals,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sRvf.P0,sModelParams.sRvf.lambda,sModelParams.sRvf.V0, sModelParams.sRvf.Ees, sModelParams.sRvf.Vd);
    PrvfVals = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]
    
    
    PsptValsIdx = (PsptVals < maxPressuretoDisplay) & (PsptVals > minPressuretoDisplay);
    PlvfValsIdx = (PlvfVals < maxPressuretoDisplay) & (PlvfVals > minPressuretoDisplay);
    PrvfValsIdx = (PrvfVals < maxPressuretoDisplay) & (PrvfVals > minPressuretoDisplay);
    
    PlvfValsIdx = PlvfValsIdx & PrvfValsIdx;
    PrvfValsIdx = PlvfValsIdx & PrvfValsIdx;
    
    figure;
    subplot(2,1,1);
    plot(VsptVals(PsptValsIdx),PsptVals(PsptValsIdx)); hold all;
    plot(VsptVals(PlvfValsIdx),PlvfVals(PlvfValsIdx) - PrvfVals(PrvfValsIdx));
    
    if Vspt > 0
        [~,VsptIdx] = min(abs(VsptVals - Vspt));
        plot(VsptVals(VsptIdx),PsptVals(VsptIdx),'o'); hold all;
        plot(VsptVals(VsptIdx),PlvfVals(VsptIdx) - PrvfVals(VsptIdx),'x');
    end
    
    xlabel('[l]'); ylabel('[mmHg]'); legend('Pspt Vs Vspt','(Plvf-Prvf) Vs Vspt'); title('numeric solution search'); grid on;
    
    subplot(2,1,2);
    PsptValsIdx = PsptValsIdx & PlvfValsIdx;
    PlvfValsIdx = PlvfValsIdx & PsptValsIdx;
    PrvfValsIdx = PrvfValsIdx & PsptValsIdx;
    errVsptFig = abs(PsptVals(PsptValsIdx) - (PlvfVals(PlvfValsIdx) - PrvfVals(PrvfValsIdx)));
    plot(VsptVals(PsptValsIdx) , errVsptFig);
    xlabel('[l]'); ylabel('[mmHg]'); title('numeric solution search err'); grid on;
end

end

function [Vspt] = VsptLinearSolver(sPreviousValues,Vlv,Vrv,driverFuncVal,sModelParams,sSimParams)
% This function solves Vspt via an taylor series approximation

if isempty(sPreviousValues)
    Vspt = NaN;
    return
end

previousVspt = sPreviousValues.vSpt;
e = sPreviousValues.driverFuncVal;

% spt:
Ees = sModelParams.sSPT.Ees;
P0 = sModelParams.sSPT.P0;
lambda = sModelParams.sSPT.lambda;
V0 = sModelParams.sSPT.V0;
Vd = sModelParams.sSPT.Vd;
f = P0 * (exp(lambda*(previousVspt-V0)) - 1);

dg_over_dv_at_spt = e*Ees + (1-e)*(P0*lambda*exp(lambda*(previousVspt-V0)));
dg_over_de_at_spt = Ees*(previousVspt - Vd) - f;

% lvf
Ees = sModelParams.sLvf.Ees;
P0 = sModelParams.sLvf.P0;
lambda = sModelParams.sLvf.lambda;
V0 = sModelParams.sLvf.V0;
previousVlv = sPreviousValues.previousVlv;
f = P0 * (exp(lambda*(previousVlv + previousVspt - V0)) - 1);

dg_over_dv_at_lvf = e*Ees + (1-e)*(P0*lambda*exp(lambda*(previousVlv + previousVspt - V0)));
dg_over_de_at_lvf = Ees*(previousVlv + previousVspt - Vd) - f;

% rvf
Ees = sModelParams.sRvf.Ees;
P0 = sModelParams.sRvf.P0;
lambda = sModelParams.sRvf.lambda;
V0 = sModelParams.sRvf.V0;
previousVrv = sPreviousValues.previousVrv;
f = P0 * (exp(lambda*(previousVrv - previousVspt - V0)) - 1);

dg_over_dv_at_rvf = e*Ees + (1-e)*(P0*lambda*exp(lambda*(previousVrv - previousVspt - V0)));
dg_over_de_at_rvf = Ees*(previousVrv - previousVspt - Vd) - f;

deltaVlv = Vlv - previousVlv;
deltaVrv = Vrv - previousVrv;
deltaDrive = driverFuncVal - sPreviousValues.driverFuncVal;

asterisk        = dg_over_dv_at_spt - dg_over_dv_at_lvf - dg_over_dv_at_rvf;
doubleAsterisk  = dg_over_dv_at_lvf*deltaVlv - dg_over_dv_at_rvf*deltaVrv;
tripleAsterisk  = dg_over_de_at_spt - dg_over_de_at_lvf + dg_over_de_at_rvf;
gAll = sPreviousValues.gSpt - sPreviousValues.gLvf + sPreviousValues.gRvf;

deltaVspt = (-gAll + doubleAsterisk - deltaDrive*tripleAsterisk)/(asterisk);

Vspt = deltaVspt + previousVspt;
end


