function [Plv, Prv, Pperi, Plvf, Prvf, Vspt, Vlvf, Vrvf] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,sModelParams,sSimParams)
% function [Plv, Prv, Pperi, Plvf, Prvf, Vspt, Vlvf, Vrvf] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,sModelParams,sSimParams)
% This function calculates the pressures of the ventricles of the heart
%
% INPUTS:
% driverFuncVal - the current elastance of the ventricles [no-units]
% Vlv - volume of the left ventricle [l]
% Vrv - volume of the left ventricle [l]
% sModelParams
% sSimParams
%
% OUTPUTS:
% Plv - pressure at the left ventricle [mmHg]
% Prv - pressure at the right ventricle [mmHg]
% Pperi - pressure at the pericardium [mmHg]
% Plvf, Prvf - non physical pressures at left,right free walls [mmHg]
% Vspt, Vlvf, Vrvf - non physical volumes at left,right free walls and at
%   septum free wall [l]
%
% Ron Teichner, 01.12.2018

funcSym = 'f'; sInputs.V = (Vlv+Vrv); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0] = deal(sModelParams.sPcd.P0,sModelParams.sPcd.lambda,sModelParams.sPcd.V0);
Pperi = sModelParams.Pa_to_mmHg*1e3*cardioUtilityFunctions(funcSym,sInputs,sFuncParams) + sModelParams.Ppl; % [mmHg]
% 'f' function has units of [kPa]
syms VsptSym

VlvfSym = Vlv + VsptSym; % [l]
VrvfSym = Vrv - VsptSym; % [l]

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VsptSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sSPT.P0,sModelParams.sSPT.lambda,sModelParams.sSPT.V0, sModelParams.sSPT.Ees, sModelParams.sSPT.Vd);
PsptSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VlvfSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sLvf.P0,sModelParams.sLvf.lambda,sModelParams.sLvf.V0, sModelParams.sLvf.Ees, sModelParams.sLvf.Vd);
PlvfSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(VrvfSym,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sRvf.P0,sModelParams.sRvf.lambda,sModelParams.sRvf.V0, sModelParams.sRvf.Ees, sModelParams.sRvf.Vd);
PrvfSym = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [kPa]

%% graphical investigation of numeric solution:
maxPressuretoDisplay = 1000; % [mmHg]
VsptVals = 0:0.01:1;
PsptVals = sModelParams.Pa_to_mmHg * 1e3*double(subs(PsptSym,VsptSym,VsptVals)); PsptValsIdx = (PsptVals < maxPressuretoDisplay);
PlvfVals = sModelParams.Pa_to_mmHg * 1e3*double(subs(PlvfSym,VsptSym,VsptVals)); PlvfValsIdx = (PlvfVals < maxPressuretoDisplay);
PrvfVals = sModelParams.Pa_to_mmHg * 1e3*double(subs(PrvfSym,VsptSym,VsptVals)); PrvfValsIdx = (PrvfVals < maxPressuretoDisplay);
figure; 
plot(VsptVals(PsptValsIdx),PsptVals(PsptValsIdx)); hold all; 
plot(VsptVals(PlvfValsIdx),PlvfVals(PlvfValsIdx)); 
plot(VsptVals(PrvfValsIdx),PrvfVals(PrvfValsIdx)); 
xlabel('[l]'); ylabel('[mmHg]'); legend('Pspt_Vs_Vspt','Plvf_Vs_Vspt','Prvf_Vs_Vspt'); title('numeric solution search'); grid on;

%% continue with calculations:
Vspt = double(vpasolve(PsptSym + PrvfSym - PlvfSym , VsptSym)); % [l]

Vlvf = double(subs(VlvfSym, VsptSym, Vspt)); % [l]
Vrvf = double(subs(VrvfSym, VsptSym, Vspt)); % [l]
Plvf = double(subs(PlvfSym, VsptSym, Vspt)); % [kPa]
Prvf = double(subs(PrvfSym, VsptSym, Vspt)); % [kPa]

Plvf = sModelParams.Pa_to_mmHg * 1e3*Plvf; % [mmHg]
Prvf = sModelParams.Pa_to_mmHg * 1e3*Prvf; % [mmHg]

Plv = Plvf + Pperi; % [mmHg]
Prv = Prvf + Pperi; % [mmHg]

 
