function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa, Vpu, sModelParams, sSimParams)
% function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa, Vpu, sModelParams, sSimParams)
% This function calculates pressures in peripheral assemblies (vena-cava,
% aorta, pulmunary-vein, pulmunary artery)
%
% INPUTS:
% Vao, Vvc, Vpa, Vpu - volumes of peripheral assemblies
% sModelParams, sSimParams
%
% OUTPUTS:
% Pao, Pvc, Ppa, Ppu - pressures at peripheral assemblies

Pao = sModelParams.sAo.Ees * (Vao - sModelParams.sAo.Vd);
Pvc = sModelParams.sVc.Ees * (Vvc - sModelParams.sVc.Vd);
Ppa = sModelParams.sPa.Ees * (Vpa - sModelParams.sPa.Vd);
Ppu = sModelParams.sPu.Ees * (Vpu - sModelParams.sPu.Vd);