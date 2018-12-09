function sStateVecInit = CardioSimInit(method,sModelParams,sSimParams)

switch method
    case 'random'
        totalVol = sModelParams.totalBloodVolume; % [l]
        %totalVol = sModelParams.stressedBloodVolume; % [l]
        
        allVolumesAboveZeroPressureVolume = false;
        while ~allVolumesAboveZeroPressureVolume
            mostVolumesAboveZeroPressureVolume = false;
            while ~mostVolumesAboveZeroPressureVolume
                ventricleVolumeLimits = [40,150]*1e-3; % [l]
                sStateVecInit.sVolumes.Vrv = diff(ventricleVolumeLimits)*rand + ventricleVolumeLimits(1); % [l]
                sStateVecInit.sVolumes.Vlv = diff(ventricleVolumeLimits)*rand + ventricleVolumeLimits(1); % [l]
                
                randVolumes = rand(4,1);
                randVolumes = randVolumes ./ sum(randVolumes);
                randVolumes = randVolumes .* (totalVol - (sStateVecInit.sVolumes.Vrv+sStateVecInit.sVolumes.Vlv));
                
                sStateVecInit.sVolumes.Vpa = randVolumes(1); % [l]
                sStateVecInit.sVolumes.Vpu = randVolumes(2); % [l]
                sStateVecInit.sVolumes.Vao = randVolumes(3); % [l]
                sStateVecInit.sVolumes.Vvc = randVolumes(4); % [l]
                
                mostVolumesAboveZeroPressureVolume = (sStateVecInit.sVolumes.Vpa > sModelParams.sPa.Vd) & ...
                    (sStateVecInit.sVolumes.Vpu > sModelParams.sPu.Vd) & ...
                    (sStateVecInit.sVolumes.Vao > sModelParams.sAo.Vd) & ...
                    (sStateVecInit.sVolumes.Vvc > sModelParams.sVc.Vd);
            end
            [Plv, Prv, Pperi, Pspt, Plvf, Prvf, Vspt, Vlvf, Vrvf, debugVsptSolDiff, errVspt] = CalcVentriclesPressures(0,sStateVecInit.sVolumes.Vlv,sStateVecInit.sVolumes.Vrv,[],sModelParams,sSimParams);
            
            
            allVolumesAboveZeroPressureVolume = (sStateVecInit.sVolumes.Vpa > sModelParams.sPa.Vd) & ...
                (sStateVecInit.sVolumes.Vpu > sModelParams.sPu.Vd) & ...
                (sStateVecInit.sVolumes.Vao > sModelParams.sAo.Vd) & ...
                (sStateVecInit.sVolumes.Vvc > sModelParams.sVc.Vd) & ...
                (Vspt > sModelParams.sSPT.Vd) & ...
                (Vlvf > sModelParams.sLvf.Vd) & ...
                (Vrvf > sModelParams.sRvf.Vd);
        end
        
        sStateVecInit.sValves.aortic        = true;
        sStateVecInit.sValves.pulmunary     = true;
        sStateVecInit.sValves.mitral        = true;
        sStateVecInit.sValves.tricuspid     = true;
        
        sStateVecInit.sFlows.Qav = 0; % [l/s]
        sStateVecInit.sFlows.Qpv = 0; % [l/s]
    case 'endDiastolic'
    case 'endSystolic'
    case 'endTenMinNoDriver'
        sLoadedState = load('tenMinRunNoDriverSingleEndRes.mat');
        sStateVecInit.sVolumes.Vrv = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vrv;
        sStateVecInit.sVolumes.Vlv = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vlv;
        sStateVecInit.sVolumes.Vpa = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vpa;
        sStateVecInit.sVolumes.Vpu = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vpu;
        sStateVecInit.sVolumes.Vao = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vao;
        sStateVecInit.sVolumes.Vvc = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vvc;
        sStateVecInit.sValves.aortic = sLoadedState.sAllInfoVecCurrentTime.sValves.aortic;
        sStateVecInit.sValves.pulmunary = sLoadedState.sAllInfoVecCurrentTime.sValves.pulmunary;
        sStateVecInit.sValves.mitral = sLoadedState.sAllInfoVecCurrentTime.sValves.mitral;
        sStateVecInit.sValves.tricuspid = sLoadedState.sAllInfoVecCurrentTime.sValves.tricuspid;
        sStateVecInit.sFlows.Qav = sLoadedState.sAllInfoVecCurrentTime.sFlows.Qav;
        sStateVecInit.sFlows.Qpv = sLoadedState.sAllInfoVecCurrentTime.sFlows.Qpv;
        
        [Plv, Prv, Pperi, Pspt, Plvf, Prvf, Vspt, Vlvf, Vrvf, debugVsptSolDiff, errVspt] = CalcVentriclesPressures(0,sStateVecInit.sVolumes.Vlv,sStateVecInit.sVolumes.Vrv,[],sModelParams,sSimParams);
        
        allVolumesAboveZeroPressureVolume = (sStateVecInit.sVolumes.Vpa > sModelParams.sPa.Vd) & ...
            (sStateVecInit.sVolumes.Vpu > sModelParams.sPu.Vd) & ...
            (sStateVecInit.sVolumes.Vao > sModelParams.sAo.Vd) & ...
            (sStateVecInit.sVolumes.Vvc > sModelParams.sVc.Vd) & ...
            (Vspt > sModelParams.sSPT.Vd) & ...
            (Vlvf > sModelParams.sLvf.Vd) & ...
            (Vrvf > sModelParams.sRvf.Vd);
        if allVolumesAboveZeroPressureVolume
            disp('initial state pass volumes check');
            pause(1);
        else
            disp('initial state not pass volumes check');
            pause(1);
        end
    case 'endTenMin' % with no inertia
        sLoadedState = load('endTenMin.mat');
        sStateVecInit.sVolumes.Vrv = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vrv;
        sStateVecInit.sVolumes.Vlv = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vlv;
        sStateVecInit.sVolumes.Vpa = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vpa;
        sStateVecInit.sVolumes.Vpu = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vpu;
        sStateVecInit.sVolumes.Vao = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vao;
        sStateVecInit.sVolumes.Vvc = sLoadedState.sAllInfoVecCurrentTime.sVolumes.Vvc;
        sStateVecInit.sValves.aortic = sLoadedState.sAllInfoVecCurrentTime.sValves.aortic;
        sStateVecInit.sValves.pulmunary = sLoadedState.sAllInfoVecCurrentTime.sValves.pulmunary;
        sStateVecInit.sValves.mitral = sLoadedState.sAllInfoVecCurrentTime.sValves.mitral;
        sStateVecInit.sValves.tricuspid = sLoadedState.sAllInfoVecCurrentTime.sValves.tricuspid;
        sStateVecInit.sFlows.Qav = sLoadedState.sAllInfoVecCurrentTime.sFlows.Qav;
        sStateVecInit.sFlows.Qpv = sLoadedState.sAllInfoVecCurrentTime.sFlows.Qpv;
        
end