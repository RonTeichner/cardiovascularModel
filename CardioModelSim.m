clear all; close all; clc; 

sModelParams = CardioModelParams;
sSimParams.ts = 1e-3; % [sec]
sSimParams.simDuration = 5; % [sec]

%% set initial values:
totalVol = sModelParams.totalBloodVolume;

randVolumes = rand(6,1);
randVolumes = randVolumes ./ sum(randVolumes);
randVolumes = randVolumes .* totalVol;

sStateVecInit.sVolumes.Vpa = randVolumes(1);
sStateVecInit.sVolumes.Vpu = randVolumes(2);
sStateVecInit.sVolumes.Vlv = randVolumes(3);
sStateVecInit.sVolumes.Vao = randVolumes(4);
sStateVecInit.sVolumes.Vvc = randVolumes(5);
sStateVecInit.sVolumes.Vrv = randVolumes(6);

sStateVecInit.sValves.aortic        = false;
sStateVecInit.sValves.pulmunary     = false;
sStateVecInit.sValves.mitral        = false;
sStateVecInit.sValves.tricuspid     = false;

sStateVecInit.sFlows.Qav = 0;
sStateVecInit.sFlows.Qpv = 0;

%% allocate:
nIter = round(sSimParams.simDuration / sSimParams.ts);
sAllInfoVec = CardioAllocate(nIter);
sAllInfoVec.tVec = [0:(nIter-1)]*sSimParams.ts;

%% driverFunc centers:
heartBeatsTs = 60 / sModelParams.heartRate; % [sec]
% constant heart beat:
driverFuncCenters = [rand*0.5 : heartBeatsTs : sSimParams.simDuration]; % [sec]
%% runSim: 
sStateVec = sStateVecInit;
for i = 1:nIter
    display(['iter: ',int2str(i),' out of ',int2str(nIter)])
    % driverFunc value:
    currentTime = sAllInfoVec.tVec(i);
    [~,closestCenterIdx] = min(abs(driverFuncCenters - currentTime));
    closestCenterTime = driverFuncCenters(closestCenterIdx);
    diffFromCenter = currentTime - closestCenterTime; % [sec]
    driverFuncVal = interp1(sModelParams.sDriverFunc.tVec , sModelParams.sDriverFunc.vals , diffFromCenter,'linear', 'extrap');
    
    % cardiomodel time-step:
    [sStateVec,sAllInfoVecCurrentTime] = CardioModelTimeStep(sStateVec,driverFuncVal,sModelParams,sSimParams);
    sAllInfoVec = CardioUpdateInfoVec(sAllInfoVecCurrentTime,sAllInfoVec,i);
end

%% analyse:
figure; plot(sAllInfoVec.tVec,sAllInfoVec.sPressures.Pao); xlabel('sec'); title('aortic pressure'); grid on;


