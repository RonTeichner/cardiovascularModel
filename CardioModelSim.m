clear all; 
close all; 
clc;
dbstop if error

article = 'Simulation of cardiovascular system diseases by including';
%article = 'Unique parameter identification for cardiac diagnosis in critical care using minimal data sets';

if strcmp(article,'Unique parameter identification for cardiac diagnosis in critical care using minimal data sets')
    disp('model has more incductance than implemented now');
end

sModelParams = CardioModelParams(article);
sSimParams.ts = 1e-3; % [sec] It's not a good Idea to have ts more than 1ms because the driver function has a narrow peak 
sSimParams.simDuration = 60; % [sec]
sSimParams.VsptSolutionDiffMax = 5; % [mmHg]
sSimParams.seed = round(rand*1e6);
sSimParams.initMethod = 'endTenMin'; % {'random','endDiastolic','endTenMinNoDriver','endTenMin'}
sSimParams.enableMaxFlowIsCurrentVol = false; % the maximum flow in a time-step will not be greater than the whole chamber volume
sSimParams.minSimDuration = min(5, sSimParams.simDuration); % if the implicit function has no solution before sSimParams.minSimDuration is reached the sim will restart
heartOn = true;

%% paramsUpdate:
sSimParams.sParamsSwift.enableAllParamsSwift = false;
sSimParams.sParamsSwift.paramMaxAbsChange = 0.1; % [out of 1, like 10%]
sSimParams.sParamsSwift.noiseStd = 1e-1; % [from initial val]
sSimParams.sParamsSwift.iirAlfa = 0.3; % param = (1-alfa)*previous + alfa*noise
sSimParams.sParamsSwift.iirFs = 0.5; %[hz]
sSimParams.sParamsSwift.iirDecimation = round((1/sSimParams.ts) / sSimParams.sParamsSwift.iirFs);

sSimParams.enableHemorrhage = false;
hemorrhageDuration = 10; % [sec]
totalBloodVolAfterHemorrhage = 0.75 * sModelParams.totalBloodVolume; % [v]
totalInitialBloodVol = sModelParams.totalBloodVolume; % [v]
deltaBloodVol = totalInitialBloodVol - totalBloodVolAfterHemorrhage; % [v]
deltaBloodVolPerTs = deltaBloodVol/(hemorrhageDuration/sSimParams.ts); % [v]

sSimParams.enableThoracicCavityPressureChange = false;
ThoracicCavityPressureChangeDuration = 10; % [sec]
initialPpl = sModelParams.Ppl; % [mmHg]
endPpl = +3; % [mmHg]
deltaPpl = endPpl - initialPpl; % [mmHg]
deltaPplPerTs = deltaPpl/(hemorrhageDuration/sSimParams.ts); % [mmHg]

sSimParams.enableRsysUpdate = false;
rSysUpdateDuration = 10; % [sec]
initialRsys = sModelParams.Rsys; % [KPa*s/l]
endRsys = 80; % [KPa*s/l]
deltaRsys = endRsys - initialRsys; % [KPa*s/l]
deltaRsysPerTs = deltaRsys/(hemorrhageDuration/sSimParams.ts); % [KPa*s/l]

sSimParams.enableHeartElastyUpdate = false;
lvfEsUpdateDuration = 10; % [sec]
initialLvfEs = sModelParams.sLvf.Ees; % [kPa/l]
endLvfEs = 300; % [kPa/l]
deltaLvfEs = endLvfEs - initialLvfEs; % [kPa/l]
deltaLvfEsPerTs = deltaLvfEs/(hemorrhageDuration/sSimParams.ts); % [kPa/l]


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
%driverFuncCenters = [rand*0.5 : heartBeatsTs : sSimParams.simDuration]; % [sec]


%% runSim:
sModelParamsInit = sModelParams;
lastIter = 1;
nIterForMinSimDuration = round(sSimParams.minSimDuration / sSimParams.ts);
while lastIter < nIterForMinSimDuration
    display('sim starts')
    [sStateVecInit,driverFuncFirstCenter] = CardioSimInit(sSimParams.initMethod,sModelParams,sSimParams);
    driverFuncCenters = [driverFuncFirstCenter : heartBeatsTs : sSimParams.simDuration]; % [sec]
    sStateVec = sStateVecInit;
    tic
    for i = 1:nIter
        if ~mod(i,1e3)
            display(['iter: ',int2str(i),' out of ',int2str(nIter)])
        end
        
%         if ~mod(i,1e4)
%             xLimits = [0,1e3];
%             close all; CardioPlots(sAllInfoVec,i-1,'sec',xLimits); pause(0.5);
%         end
        
        %% driverFunc value:
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
        
        %% params update:
        if sSimParams.sParamsSwift.enableAllParamsSwift
            if mod(i,sSimParams.sParamsSwift.iirDecimation) == 0
                sModelParams = ModelParamsSwift(sModelParamsInit,sModelParams,sSimParams);
            end
        end
        
        if sSimParams.enableHemorrhage
            % update blood volume within the first 10 sec:
            if currentTime < hemorrhageDuration
                %sModelParams.totalBloodVolume = totalInitialBloodVol - (currentTime/hemorrhageDuration)*deltaBloodVol;  % [v]
                sStateVec.sVolumes.Vvc = sStateVec.sVolumes.Vvc - deltaBloodVolPerTs; % [v]
            end
        end
        
        if sSimParams.enableThoracicCavityPressureChange
            if currentTime < ThoracicCavityPressureChangeDuration
                sModelParams.Ppl = sModelParams.Ppl + deltaPplPerTs; % [mmHg]
            end            
        end
        
        if sSimParams.enableRsysUpdate
            if currentTime < rSysUpdateDuration
                sModelParams.Rsys = sModelParams.Rsys + deltaRsysPerTs; % [KPa*s/l]
            end            
        end
        
        if sSimParams.enableHeartElastyUpdate
            if currentTime < lvfEsUpdateDuration
                sModelParams.sLvf.Ees = sModelParams.sLvf.Ees + deltaLvfEsPerTs; % [kPa/l]
            end
        end
        
        %% cardiomodel time-step:
        [sStateVec,sAllInfoVecCurrentTime,cardioErr] = CardioModelTimeStep(sStateVec,driverFuncVal,previousVspt,sModelParams,sSimParams);
        
        if cardioErr
            break
        end
        %sAllInfoVec = CardioUpdateInfoVec(sAllInfoVecCurrentTime,sAllInfoVec,i);
        CardioUpdateInfoVecScript
        sAllInfoVec.driverFuncVal(i) = driverFuncVal;
    end
    toc
    
    if cardioErr
        lastIter = i-1;
    else
        lastIter = i;
    end
end
sAllInfoVec.sModelParamsInit = sModelParamsInit;
%save('hourRun.mat','sAllInfoVec');
%% analyse:
%CardioPlots(sAllInfoVec,lastIter,'samples',xLimits);
xLimits = [0,4e3];
%xLimits = [10,12];
%xLimits = [7,9];
plotLastOnly = true;
CardioPlots(sAllInfoVec,lastIter,'sec',xLimits,sSimParams,plotLastOnly);
