clear all; close all; clc; 
dbstop if error

sModelParams = CardioModelParams;
sSimParams.ts = 1e-3; % [sec]
sSimParams.simDuration = 60; % [sec]
sSimParams.VsptSolutionDiffMax = 2; % [mmHg]
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
lastIter = 1;
while lastIter < 10
    display('sim starts')    
    sStateVecInit = CardioSimInit(sModelParams,sSimParams);
    sStateVec = sStateVecInit;
    for i = 1:nIter
        display(['iter: ',int2str(i),' out of ',int2str(nIter)])
        % driverFunc value:
        currentTime = sAllInfoVec.tVec(i);
        [~,closestCenterIdx] = min(abs(driverFuncCenters - currentTime));
        closestCenterTime = driverFuncCenters(closestCenterIdx);
        diffFromCenter = currentTime - closestCenterTime; % [sec]
        diffFromCenterAtIdx = round(diffFromCenter*sModelParams.sDriverFunc.ts);
        desiredIdx = sModelParams.sDriverFunc.centerIdx + diffFromCenterAtIdx;
        desiredIdx = min(desiredIdx , numel(sModelParams.sDriverFunc.tVec));
        desiredIdx = max(desiredIdx , 1);
        driverFuncVal = sModelParams.sDriverFunc.vals(desiredIdx);
%         driverFuncVal = interp1(sModelParams.sDriverFunc.tVec , sModelParams.sDriverFunc.vals , diffFromCenter,'linear');
%         if isnan(driverFuncVal)
%             driverFuncVal = 0;
%         end
        
        if i > 1 % not first iter
            previousVspt = sAllInfoVecCurrentTime.sVolumes.Vspt;
        else
            previousVspt = [];
        end
        
        % cardiomodel time-step:
        [sStateVec,sAllInfoVecCurrentTime,cardioErr] = CardioModelTimeStep(sStateVec,driverFuncVal,previousVspt,sModelParams,sSimParams);
        
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
end
%% analyse:
CardioPlots(sAllInfoVec,lastIter);
