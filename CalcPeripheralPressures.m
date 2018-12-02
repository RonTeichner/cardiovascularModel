function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa,Vpu, sModelParams, sSimParams)
% function [Pao, Pvc, Ppa, Ppu] = CalcPeripheralPressures(Vao, Vvc, Vpa,Vpu, sModelParams, sSimParams)
% This function calculates pressures in peripheral assemblies (vena-cava,
% aorta, pulmunary-vein, pulmunary artery)
%
% INPUTS:
% Vao, Vvc, Vpa, Vpu - volumes of peripheral assemblies
% sModelParams, sSimParams
%
% OUTPUTS:
% Pao, Pvc, Ppa, Ppu - pressures at peripheral assemblies
