function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa, Vpu, sModelParams, sSimParams)
% function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa, Vpu, sModelParams, sSimParams)
% This function calculates pressures in peripheral assemblies (vena-cava,
% aorta, pulmunary-vein, pulmunary artery)
%
% INPUTS:
% Vao, Vvc, Vpa, Vpu - volumes of peripheral assemblies [l]
% sModelParams, sSimParams
%
% OUTPUTS:
% Pao, Pvc, Ppa, Ppu - pressures at peripheral assemblies [mmHg]

% Ees [kPa/l]
Pao = sModelParams.sAo.Ees * (Vao - sModelParams.sAo.Vd); % [kPa]
Pvc = sModelParams.sVc.Ees * (Vvc - sModelParams.sVc.Vd); % [kPa]
Ppa = sModelParams.sPa.Ees * (Vpa - sModelParams.sPa.Vd); % [kPa]
Ppu = sModelParams.sPu.Ees * (Vpu - sModelParams.sPu.Vd); % [kPa]

Pao = sModelParams.Pa_to_mmHg * 1e3*Pao; % [mmHg]
Pvc = sModelParams.Pa_to_mmHg * 1e3*Pvc; % [mmHg]
Ppa = sModelParams.Pa_to_mmHg * 1e3*Ppa; % [mmHg]
Ppu = sModelParams.Pa_to_mmHg * 1e3*Ppu; % [mmHg]