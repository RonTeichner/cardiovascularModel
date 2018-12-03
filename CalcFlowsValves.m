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

%% Flow calcs:
sFlows.Qsys = (sPressures.Pao - sPressures.Pvc) / sModelParams.Rsys;
sFlows.Qpul = (sPressures.Ppa - sPressures.Ppu) / sModelParams.Rpul;

funcSym = 'h'; [sInputs.P1,sInputs.P2,sInputs.Q] = deal(sPressures.Plv,sPressures.Pao,Qav); [sFuncParams.R,sFuncParams.L,sFuncParams.ts] = deal(sModelParams.Rav,sModelParams.Lav,sSimParams.ts);
Qav = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);
sFlows.Qav = max(Qav * (sValves.aortic + (not(sValves.aortic) && (sPressures.Plv > sPressures.Pao))) , 0);

funcSym = 'h'; [sInputs.P1,sInputs.P2,sInputs.Q] = deal(sPressures.Prv,sPressures.Ppa,Qpv); [sFuncParams.R,sFuncParams.L,sFuncParams.ts] = deal(sModelParams.Rpv,sModelParams.Lpv,sSimParams.ts);
Qpv = cardioUtilityFunctions(funcSym,sInputs,sFuncParams);
sFlows.Qpv = max(Qpv * (sValves.pulmunary + (not(sValves.pulmunary) && (sPressures.Prv > sPressures.Ppa))) , 0);

Qmt = (sPressures.Ppu - sPressures.Plv) / sModelParams.Rmt;
sFlows.Qmt = max(Qmt * (sValves.mitral + (not(sValves.mitral) && (sPressures.Ppu > sPressures.Plv))) , 0);

Qtc = (sPressures.Pvc - sPressures.Prv) / sModelParams.Rtc;
sFlows.Qtc = max(Qtc * (sValves.tricuspid + (not(sValves.tricuspid) && (sPressures.Pvc > sPressures.Prv))) , 0);

%% Valves state update:
sValves.aortic      = (sFlows.Qav > 0);
sValves.pulmunary   = (sFlows.Qpv > 0);
sValves.mitral      = (sFlows.Qmt > 0);
sValves.tricuspid   = (sFlows.Qtc > 0);


