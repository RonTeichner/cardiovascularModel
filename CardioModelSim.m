sModelParams = CardioModelParams;
sSimParams.ts = 1e-3; % [sec]
sSimParams.simDuration = 30; % [sec]

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
sStateVec = sStateVecInit;
nIter = sSimParams.simDuration / sSimParams.ts;
[sUpdatedStateVec,sAllInfoVec] = CardioModelTimeStep(sStateVec,driverFuncVal,sModelParams,sSimParams);
