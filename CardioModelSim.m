clear all; close all; clc; 
dbstop if error

sModelParams = CardioModelParams;
sSimParams.ts = 1e-3; % [sec]
sSimParams.simDuration = 5; % [sec]

%% set initial values:
totalVol = sModelParams.totalBloodVolume; % [l]

randVolumes = rand(6,1);
randVolumes = randVolumes ./ sum(randVolumes);
randVolumes = randVolumes .* totalVol;

sStateVecInit.sVolumes.Vpa = randVolumes(1); % [l]
sStateVecInit.sVolumes.Vpu = randVolumes(2); % [l]
sStateVecInit.sVolumes.Vlv = randVolumes(3); % [l]
sStateVecInit.sVolumes.Vao = randVolumes(4); % [l]
sStateVecInit.sVolumes.Vvc = randVolumes(5); % [l]
sStateVecInit.sVolumes.Vrv = randVolumes(6); % [l]

sStateVecInit.sValves.aortic        = false;
sStateVecInit.sValves.pulmunary     = false;
sStateVecInit.sValves.mitral        = false;
sStateVecInit.sValves.tricuspid     = false;

sStateVecInit.sFlows.Qav = 0; % [l/s]
sStateVecInit.sFlows.Qpv = 0; % [l/s]

%% allocate:
nIter = round(sSimParams.simDuration / sSimParams.ts);
sAllInfoVec = CardioAllocate(nIter);
sAllInfoVec.tVec = [0:(nIter-1)]*sSimParams.ts; % [sec]
sAllInfoVec.driverFuncVal = zeros(nIter,1);
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
    [sStateVec,sAllInfoVecCurrentTime,cardioErr] = CardioModelTimeStep(sStateVec,driverFuncVal,sModelParams,sSimParams);
    
    if cardioErr
        break
    end
    sAllInfoVec = CardioUpdateInfoVec(sAllInfoVecCurrentTime,sAllInfoVec,i);
    sAllInfoVec.driverFuncVal(i) = driverFuncVal;
end

if cardioErr
    lastIter = i-1;
else
    lastIter = i;
end
%% analyse:
figure; 
plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.driverFuncVal(1:lastIter)); xlabel('sec'); title('driverFunc e(t)'); grid on;
figure; 
subplot(2,2,1); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Pao(1:lastIter)); xlabel('sec'); title('aortic pressure'); grid on;
subplot(2,2,2); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Pvc(1:lastIter)); xlabel('sec'); title('venc-cava pressure'); grid on;
subplot(2,2,3); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Ppa(1:lastIter)); xlabel('sec'); title('p-a pressure'); grid on;
subplot(2,2,4); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Ppu(1:lastIter)); xlabel('sec'); title('p-v pressure'); grid on;

figure;
subplot(1,2,1); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Plv(1:lastIter)); xlabel('sec'); title('left-v pressure'); grid on;
subplot(1,2,2); plot(sAllInfoVec.tVec(1:lastIter),sAllInfoVec.sPressures.Prv(1:lastIter)); xlabel('sec'); title('right-v pressure'); grid on;

