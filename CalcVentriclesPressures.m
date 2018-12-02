function [Plv, Prv, Pperi, Plvf, Prvf, Vspt, Vlvf, Vrvf] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,sModelParams,sSimParams)
% function [Plv, Prv, Pperi, Plvf, Prvf, Vspt, Vlvf, Vrvf] = CalcVentriclesPressures(driverFuncVal,Vlv,Vrv,sModelParams,sSimParams)
% This function calculates the pressures of the ventricles of the heart
%
% INPUTS:
% driverFuncVal - the current elastance of the ventricles
% Vlv - volume of the left ventricle [m^3 ??]
% Vrv - volume of the left ventricle [m^3 ??]
% sModelParams
% sSimParams
%
% OUTPUTS:
% Plv - pressure at the left ventricle [mmHg]
% Prv - pressure at the right ventricle [mmHg]
% Pperi - pressure at the pericardium [mmHg]
% Plvf, Prvf - non physical pressures at left,right free walls
% Vspt, Vlvf, Vrvf - non physical volumes at left,right free walls and at
%   septum free wall
%
% Ron Teichner, 01.12.2018

funcSym = 'f'; sInputs.V = (Vlv+Vrv); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0] = deal(sModelParams.sPcd.P0,sModelParams.sPcd.lambda,sModelParams.sPcd.V0);
Pperi = cardioUtilityFunctions(funcSym,sInputs,sFuncParams) + sModelParams.Ppl;

syms Vspt

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(Vspt,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sSPT.P0,sModelParams.sSPT.lambda,sModelParams.sSPT.V0, sModelParams.sSPT.Ees, sModelParams.sSPT.Vd);
Pspt = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(Vspt + Vlv,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sLvf.P0,sModelParams.sLvf.lambda,sModelParams.sLvf.V0, sModelParams.sLvf.Ees, sModelParams.sLvf.Vd);
Plvf = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);

funcSym = 'g'; [sInputs.V, sInputs.e] = deal(Vrv - Vspt,driverFuncVal); [sFuncParams.P0, sFuncParams.lambda, sFuncParams.V0, sFuncParams.Ees, sFuncParams.Vd] = deal(sModelParams.sRvf.P0,sModelParams.sRvf.lambda,sModelParams.sRvf.V0, sModelParams.sRvf.Ees, sModelParams.sRvf.Vd);
Prvf = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);

