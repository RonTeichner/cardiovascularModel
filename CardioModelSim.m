clear all; 
%close all; 
clc;
dbstop if error

article = 'Simulation of cardiovascular system diseases by including';
%article = 'Unique parameter identification for cardiac diagnosis in critical care using minimal data sets';

if strcmp(article,'Unique parameter identification for cardiac diagnosis in critical care using minimal data sets')
    disp('model has more incductance than implemented now');
end

sModelParams = CardioModelParams(article);
sSimParams.ts = 0.5e-3; % [sec] 
sSimParams.simDuration = 20; % [sec]
sSimParams.VsptSolutionDiffMax = 1; % [mmHg]
sSimParams.seed = round(rand*1e6);
sSimParams.initMethod = 'endTenMin'; % {'random','endDiastolic','endTenMinNoDriver','endTenMin'}
sSimParams.enableMaxFlowIsCurrentVol = false; % the maximum flow in a time-step will not be greater than the whole chamber volume
sSimParams.minSimDuration = min(5, sSimParams.simDuration); % if the implicit function has no solution before sSimParams.minSimDuration is reached the sim will restart
heartOn = true;

rng(sSimParams.seed);
%rng(832713);
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
nIterForMinSimDuration = round(sSimParams.minSimDuration / sSimParams.ts);
while lastIter < nIterForMinSimDuration
    display('sim starts')
    sStateVecInit = CardioSimInit(sSimParams.initMethod,sModelParams,sSimParams);
    sStateVec = sStateVecInit;
    for i = 1:nIter
        if ~mod(i,1e2)
            display(['iter: ',int2str(i),' out of ',int2str(nIter)])
        end
        
%         if ~mod(i,1e4)
%             xLimits = [0,1e3];
%             close all; CardioPlots(sAllInfoVec,i-1,'sec',xLimits); pause(0.5);
%         end
        
        % driverFunc value:
        currentTime = sAllInfoVec.tVec(i);
        [~,closestCenterIdx] = min(abs(driverFuncCenters - currentTime));
        closestCenterTime = driverFuncCenters(closestCenterIdx);
        diffFromCenter = currentTime - closestCenterTime; % [sec]
        diffFromCenterAtIdx = round(diffFromCenter/sModelParams.sDriverFunc.ts);
        desiredIdx = sModelParams.sDriverFunc.centerIdx + diffFromCenterAtIdx;
        desiredIdx = min(desiredIdx , numel(sModelParams.sDriverFunc.tVec));
        desiredIdx = max(desiredIdx , 1);
        if heartOn
            driverFuncVal = sModelParams.sDriverFunc.vals(desiredIdx);
        else
            driverFuncVal = 0;
        end
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

%save('tenMinRunNoDriverEndRes.mat','sAllInfoVec');
%% analyse:
%CardioPlots(sAllInfoVec,lastIter,'samples',xLimits);
xLimits = [0,1e3];
%xLimits = [10,12];
xLimits = [7,9];
CardioPlots(sAllInfoVec,lastIter,'sec',xLimits,sSimParams);
