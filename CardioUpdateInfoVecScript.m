%function sAllInfoVec = CardioUpdateInfoVec(sAllInfoVecCurrentTime,sAllInfoVec,i)

sAllInfoVec.sVolumes.Vpa(i) = sAllInfoVecCurrentTime.sVolumes.Vpa;
sAllInfoVec.sVolumes.Vpu(i) = sAllInfoVecCurrentTime.sVolumes.Vpu;
sAllInfoVec.sVolumes.Vlv(i) = sAllInfoVecCurrentTime.sVolumes.Vlv;
sAllInfoVec.sVolumes.Vao(i) = sAllInfoVecCurrentTime.sVolumes.Vao;
sAllInfoVec.sVolumes.Vvc(i) = sAllInfoVecCurrentTime.sVolumes.Vvc;
sAllInfoVec.sVolumes.Vrv(i) = sAllInfoVecCurrentTime.sVolumes.Vrv;
sAllInfoVec.sVolumes.Vspt(i) = sAllInfoVecCurrentTime.sVolumes.Vspt;
sAllInfoVec.sVolumes.Vlvf(i) = sAllInfoVecCurrentTime.sVolumes.Vlvf;
sAllInfoVec.sVolumes.Vrvf(i) = sAllInfoVecCurrentTime.sVolumes.Vrvf;
sAllInfoVec.sVolumes.VsptViaLinearSolver(i) = sAllInfoVecCurrentTime.sVolumes.VsptViaLinearSolver;
sAllInfoVec.sVolumes.debugVsptSolDiff(i) = sAllInfoVecCurrentTime.sVolumes.debugVsptSolDiff;
sAllInfoVec.sVolumes.totalBloodVol(i) = sAllInfoVec.sVolumes.Vpa(i) + sAllInfoVec.sVolumes.Vpu(i) + sAllInfoVec.sVolumes.Vlv(i) + sAllInfoVec.sVolumes.Vao(i) + sAllInfoVec.sVolumes.Vvc(i) + sAllInfoVec.sVolumes.Vrv(i);

sAllInfoVec.sPressures.Plv(i) = sAllInfoVecCurrentTime.sPressures.Plv;
sAllInfoVec.sPressures.Prv(i) = sAllInfoVecCurrentTime.sPressures.Prv;
sAllInfoVec.sPressures.Pperi(i) = sAllInfoVecCurrentTime.sPressures.Pperi;
sAllInfoVec.sPressures.Pspt(i) = sAllInfoVecCurrentTime.sPressures.Pspt;
sAllInfoVec.sPressures.Plvf(i) = sAllInfoVecCurrentTime.sPressures.Plvf;
sAllInfoVec.sPressures.Prvf(i) = sAllInfoVecCurrentTime.sPressures.Prvf;
sAllInfoVec.sPressures.Pao(i) = sAllInfoVecCurrentTime.sPressures.Pao;
sAllInfoVec.sPressures.Pvc(i) = sAllInfoVecCurrentTime.sPressures.Pvc;
sAllInfoVec.sPressures.Ppa(i) = sAllInfoVecCurrentTime.sPressures.Ppa;
sAllInfoVec.sPressures.Ppu(i) = sAllInfoVecCurrentTime.sPressures.Ppu;

sAllInfoVec.sValves.aortic(i) = sAllInfoVecCurrentTime.sValves.aortic;
sAllInfoVec.sValves.pulmunary(i) = sAllInfoVecCurrentTime.sValves.pulmunary;
sAllInfoVec.sValves.mitral(i) = sAllInfoVecCurrentTime.sValves.mitral;
sAllInfoVec.sValves.tricuspid(i) = sAllInfoVecCurrentTime.sValves.tricuspid;

sAllInfoVec.sFlows.Qsys(i) = sAllInfoVecCurrentTime.sFlows.Qsys;
sAllInfoVec.sFlows.Qpul(i) = sAllInfoVecCurrentTime.sFlows.Qpul;
sAllInfoVec.sFlows.Qav(i) = sAllInfoVecCurrentTime.sFlows.Qav;
sAllInfoVec.sFlows.Qpv(i) = sAllInfoVecCurrentTime.sFlows.Qpv;
sAllInfoVec.sFlows.Qmt(i) = sAllInfoVecCurrentTime.sFlows.Qmt;
sAllInfoVec.sFlows.Qtc(i) = sAllInfoVecCurrentTime.sFlows.Qtc;


ff = {'Ppl','Rsys','Rmt','Rav','Rtc','Rpv','Rpul','Lav','Lpv'};
for ffIdx = 1:numel(ff)
    sAllInfoVec.sModelParams.(ff{ffIdx})(i) = sAllInfoVecCurrentTime.sModelParams.(ff{ffIdx});
end

ff = {'P0','lambda','V0','Vd','Ees'};
fPre = {'sLvf','sRvf','sSPT'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx})(i) = sAllInfoVecCurrentTime.sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
    end
end

ff = {'P0','lambda','V0'};
fPre = {'sPcd'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx})(i) = sAllInfoVecCurrentTime.sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
    end
end

ff = {'Vd','Ees'};
fPre = {'sVc','sPa','sPu','sAo'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        sAllInfoVec.sModelParams.(fPre{fPreIdx}).(ff{ffIdx})(i) = sAllInfoVecCurrentTime.sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
    end
end