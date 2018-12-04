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

Pao = (1e-3/sModelParams.mmHg_to_Pa) * Pao; % [mmHg]
Pvc = (1e-3/sModelParams.mmHg_to_Pa) * Pvc; % [mmHg]
Ppa = (1e-3/sModelParams.mmHg_to_Pa) * Ppa; % [mmHg]
Ppu = (1e-3/sModelParams.mmHg_to_Pa) * Ppu; % [mmHg]