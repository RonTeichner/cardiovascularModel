function [sFlows, sValves] = CalcFlowsValves(sPressures, sValves, Qav, Qpv, sModelParams, sSimParams)
% function [sFlows, sValves] = CalcFlowsValves(sPressures, sValves, Qav, Qpv, sModelParams, sSimParams)
% This function calculates all the flows in the cardiovascular loop.
%
% INPUTS:
% sPressures - all the pressures in the cardiovascular loop
% sValves - all the valves states in the loop
% Qav, Qpv - flows in which inertia effects are included
% sModelParams, sSimParams
%
% OUTPUTS:
% sFlows - calculated flows
% sValves - updated valves state
%
% Ron Teichner, 1.12.2018

sFlows.Qsys = (sPressures.Pao - sPressures.Pvc) / sModelParams.Rsys;
sFlows.Qpul = (sPressures.Ppa - sPressures.Ppu) / sModelParams.Rpul;

funcSym = 'h'; [sInputs.P1,sInputs.P2,sInputs.Q] = deal(sPressures.Plv,sPressures.Pao,Qav); [sFuncParams.R,sFuncParams.L,sFuncParams.ts] = deal(sModelParams.Rav,sModelParams.Lav,sSimParams.ts);
Qav = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);
sFlows.Qav = max(Qav * (sValves.aortic + (not(sValves.aortic) && (sPressures.Plv > sPressures.Pao))) , 0);