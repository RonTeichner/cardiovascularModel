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
Pperi = (1e-3/sModelParams.mmHg_to_Pa)*cardioUtilityFunctions(funcSym,sInputs,sFuncParams) + sModelParams.Ppl; % [mmHg]
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

Vspt = double(solve(PsptSym + PrvfSym - PlvfSym , VsptSym)); % [l]

Vlvf = double(subs(VlvfSym, VsptSym, Vspt)); % [l]
Vrvf = double(subs(VrvfSym, VsptSym, Vspt)); % [l]
Plvf = double(subs(PlvfSym, VsptSym, Vspt)); % [kPa]
Prvf = double(subs(PrvfSym, VsptSym, Vspt)); % [kPa]

Plvf = (1e-3/sModelParams.mmHg_to_Pa) * Plvf; % [mmHg]
Prvf = (1e-3/sModelParams.mmHg_to_Pa) * Prvf; % [mmHg]

Plv = Plvf + Pperi; % [mmHg]
Prv = Prvf + Pperi; % [mmHg]

 
