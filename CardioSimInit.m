function sStateVecInit = CardioSimInit(sModelParams,sSimParams)

%totalVol = sModelParams.totalBloodVolume; % [l]
totalVol = sModelParams.stressedBloodVolume; % [l]

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


sStateVecInit.sValves.aortic        = false;
sStateVecInit.sValves.pulmunary     = false;
sStateVecInit.sValves.mitral        = false;
sStateVecInit.sValves.tricuspid     = false;

sStateVecInit.sFlows.Qav = 0; % [l/s]
sStateVecInit.sFlows.Qpv = 0; % [l/s]