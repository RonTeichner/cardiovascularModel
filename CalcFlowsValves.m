function [sFlows, sValves] = CalcFlowsValves(sPressures, sValves, Qav, Qpv, sModelParams, sSimParams)
% function [sFlows, sValves] = CalcFlowsValves(sPressures, sValves, Qav, Qpv, sModelParams, sSimParams)
% This function calculates all the flows in the cardiovascular loop.
%
% INPUTS:
% sPressures - all the pressures in the cardiovascular loop [mmHg]
% sValves - all the valves states in the loop
% Qav, Qpv - flows in which inertia effects are included [l/s]
% sModelParams, sSimParams
%
% OUTPUTS:
% sFlows - calculated flows [l/s]
% sValves - updated valves state
%
% Ron Teichner, 1.12.2018

%% Flow calcs:
sFlows.Qsys = (sModelParams.mmHg_to_kPa*(sPressures.Pao - sPressures.Pvc)) / sModelParams.Rsys; % [l/s]
sFlows.Qpul = (sModelParams.mmHg_to_kPa*(sPressures.Ppa - sPressures.Ppu)) / sModelParams.Rpul; % [l/s]

funcSym = 'h'; [sInputs.P1,sInputs.P2,sInputs.Q] = ...
    deal(sModelParams.mmHg_to_kPa*sPressures.Plv, sModelParams.mmHg_to_kPa*sPressures.Pao, Qav); ...
    [sFuncParams.R,sFuncParams.L,sFuncParams.ts] = deal(sModelParams.Rav,sModelParams.Lav,sSimParams.ts);
Qav = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [l/s]
sFlows.Qav = max(Qav * (sValves.aortic + (not(sValves.aortic) && (sPressures.Plv > sPressures.Pao))) , 0);  % [l/s]

funcSym = 'h'; [sInputs.P1,sInputs.P2,sInputs.Q] = ...
    deal(sModelParams.mmHg_to_kPa*sPressures.Prv, sModelParams.mmHg_to_kPa*sPressures.Ppa, Qpv); ...
    [sFuncParams.R,sFuncParams.L,sFuncParams.ts] = deal(sModelParams.Rpv,sModelParams.Lpv,sSimParams.ts);
Qpv = cardioUtilityFunctions(funcSym,sInputs,sFuncParams); % [l/s]
sFlows.Qpv = max(Qpv * (sValves.pulmunary + (not(sValves.pulmunary) && (sPressures.Prv > sPressures.Ppa))) , 0); % [l/s]

Qmt = (sModelParams.mmHg_to_kPa*(sPressures.Ppu - sPressures.Plv)) / sModelParams.Rmt; % [l/s]
sFlows.Qmt = max(Qmt * (sValves.mitral + (not(sValves.mitral) && (sPressures.Ppu > sPressures.Plv))) , 0); % [l/s]

Qtc = (sModelParams.mmHg_to_kPa*(sPressures.Pvc - sPressures.Prv)) / sModelParams.Rtc; % [l/s]
sFlows.Qtc = max(Qtc * (sValves.tricuspid + (not(sValves.tricuspid) && (sPressures.Pvc > sPressures.Prv))) , 0); % [l/s]

%% Valves state update:
sValves.aortic      = (sFlows.Qav > 0);
sValves.pulmunary   = (sFlows.Qpv > 0);
sValves.mitral      = (sFlows.Qmt > 0);
sValves.tricuspid   = (sFlows.Qtc > 0);