function sAllInfoVec = CardioAllocate(nIter)

sAllInfoVec.sVolumes.Vpa = zeros(nIter,1);
sAllInfoVec.sVolumes.Vpu = zeros(nIter,1);
sAllInfoVec.sVolumes.Vlv = zeros(nIter,1);
sAllInfoVec.sVolumes.Vao = zeros(nIter,1);
sAllInfoVec.sVolumes.Vvc = zeros(nIter,1);
sAllInfoVec.sVolumes.Vrv = zeros(nIter,1);
sAllInfoVec.sVolumes.Vspt = zeros(nIter,1);
sAllInfoVec.sVolumes.Vlvf = zeros(nIter,1);
sAllInfoVec.sVolumes.Vrvf = zeros(nIter,1);
sAllInfoVec.sVolumes.VsptViaLinearSolver = zeros(nIter,1);
sAllInfoVec.sVolumes.debugVsptSolDiff = zeros(nIter,1);
sAllInfoVec.sVolumes.totalBloodVol = zeros(nIter,1);

sAllInfoVec.sPressures.Plv = zeros(nIter,1);
sAllInfoVec.sPressures.Prv = zeros(nIter,1);
sAllInfoVec.sPressures.Pperi = zeros(nIter,1);
sAllInfoVec.sPressures.Pspt = zeros(nIter,1);
sAllInfoVec.sPressures.Plvf = zeros(nIter,1);
sAllInfoVec.sPressures.Prvf = zeros(nIter,1);
sAllInfoVec.sPressures.Pao = zeros(nIter,1);
sAllInfoVec.sPressures.Pvc = zeros(nIter,1);
sAllInfoVec.sPressures.Ppa = zeros(nIter,1);
sAllInfoVec.sPressures.Ppu = zeros(nIter,1);

sAllInfoVec.sValves.aortic = false(nIter,1);
sAllInfoVec.sValves.pulmunary = false(nIter,1);
sAllInfoVec.sValves.mitral = false(nIter,1);
sAllInfoVec.sValves.tricuspid = false(nIter,1);

sAllInfoVec.sFlows.Qsys = zeros(nIter,1);
sAllInfoVec.sFlows.Qpul = zeros(nIter,1);
sAllInfoVec.sFlows.Qav = zeros(nIter,1);
sAllInfoVec.sFlows.Qpv = zeros(nIter,1);
sAllInfoVec.sFlows.Qmt = zeros(nIter,1);
sAllInfoVec.sFlows.Qtc = zeros(nIter,1);

ff = {'Ppl','Rsys','Rmt','Rav','Rtc','Rpv','Rpul','Lav','Lpv'};
for ffIdx = 1:numel(ff)
    sAllInfoVec.sModelParams.(ff{ffIdx}) = zeros(nIter,1);    
end

ff = {'P0','lambda','V0','Vd','Ees'};
fPre = {'sLvf','sRvf','sSPT'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = zeros(nIter,1);
    end
end

ff = {'P0','lambda','V0'};
fPre = {'sPcd'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = zeros(nIter,1);
    end
end

ff = {'Vd','Ees'};
fPre = {'sVc','sPa','sPu','sAo'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = zeros(nIter,1);
    end
end