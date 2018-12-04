function [sUpdatedStateVec,sAllInfoVec] = CardioModelTimeStep(sStateVec,driverFuncVal,sModelParams,sSimParams)
% function [sUpdatedStateVec] = CardioModelTimeStep(sStateVec,sParams)
% This function propagates the Cardiovascular model by a single time-step

% INPUTS:
% sStateVec.
%   sVolumes - volumes of all chambers in the model (aorta, vena-cava,
%       pulmunary artery, pulmunary vein, left and right ventricles)
%   sValves - boolean valve states (aortic, pulmunary, mitral, tricuspid)
%   sFlows - flows in which inertsia effects are included (Qav, Qpv)
% driverFuncVal - the current value of the elastnace of the ventricles
% sModelParams - all physiological parameters
% sSimParams - simulation parameters (for example time-step)
%
% OUTPUTS:
% sUpdatedStateVec - identical to input sStateVec
% sAllInfoVec - a vector containing all model parameters values. Those that
%   are contained in state vec and those that are internal parameters that are not needed for future model propagation 
%
% Ron Teichner, 28.11.2018

%% Calc Ventricles Pressures
[sPressures.Plv, sPressures.Prv, sPressures.Pperi, sPressures.Plvf, sPressures.Prvf,...
    sVolumes.Vspt, sVolumes.Vlvf, sVolumes.Vrvf] = ...
    CalcVentriclesPressures(driverFuncVal, sStateVec.sVolumes.Vlv, sStateVec.sVolumes.Vrv,...
    sModelParams, sSimParams);

%% Calc Peripheral Pressures
[sPressures.Pao, sPressures.Pvc, sPressures.Ppa, sPressures.Ppu] = ...
    CalcPeripheralPressures(sStateVec.sVolumes.Vao, sStateVec.sVolumes.Vvc, sStateVec.sVolumes.Vpa,...
    sStateVec.sVolumes.Vpu, sModelParams, sSimParams);

%% Calc Flows and valves state
[sFlows, sValves] = CalcFlowsValves(sPressures, sStateVec.sValves, sStateVec.sFlows.Qav, sStateVec.sFlows.Qpv,...
    sModelParams, sSimParams);

%% Calc chamber volumes:
V = [sStateVec.sVolumes.Vpa; sStateVec.sVolumes.Vpu; sStateVec.sVolumes.Vlv; sStateVec.sVolumes.Vao; sStateVec.sVolumes.Vvc; sStateVec.sVolumes.Vrv]; % [l]
Q = [sFlows.Qpv; sFlows.Qpul; sFlows.Qmt; sFlows.Qav; sFlows.Qsys; sFlows.Qtc]; % [l/s]

V = V + sSimParams.ts * (sModelParams.A * Q);

%% Update state vec:
sUpdatedStateVec.sVolumes.Vpa = V(1); % [l]
sUpdatedStateVec.sVolumes.Vpu = V(2); % [l]
sUpdatedStateVec.sVolumes.Vlv = V(3); % [l]
sUpdatedStateVec.sVolumes.Vao = V(4); % [l]
sUpdatedStateVec.sVolumes.Vvc = V(5); % [l]
sUpdatedStateVec.sVolumes.Vrv = V(6); % [l]

sUpdatedStateVec.sValves = sValves;

sUpdatedStateVec.sFlows.Qav = sFlows.Qav; % [l/s]
sUpdatedStateVec.sFlows.Qpv = sFlows.Qpv; % [l/s]

%% Update all info vec:
sAllInfoVec.sVolumes.Vpa = V(1); % [l]
sAllInfoVec.sVolumes.Vpu = V(2); % [l]
sAllInfoVec.sVolumes.Vlv = V(3); % [l]
sAllInfoVec.sVolumes.Vao = V(4); % [l]
sAllInfoVec.sVolumes.Vvc = V(5); % [l]
sAllInfoVec.sVolumes.Vrv = V(6); % [l]
sAllInfoVec.sVolumes.Vspt = sVolumes.Vspt; % [l]
sAllInfoVec.sVolumes.Vlvf = sVolumes.Vlvf; % [l]
sAllInfoVec.sVolumes.Vrvf = sVolumes.Vrvf; % [l]

sAllInfoVec.sPressures = sPressures; % [mmHg]

sAllInfoVec.sValves = sValves;

sAllInfoVec.sFlows = sFlows;  % [l/s]

end