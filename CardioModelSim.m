sModelParams = CardioModelParams;
sSimParams.ts = 1e-3; % [sec]

%% set initial values:
totalVol = sModelParams.totalBloodVolume;

randVolumes = rand(6,1);
randVolumes = randVolumes ./ sum(randVolumes);
randVolumes = randVolumes .* totalVol;

sStateVec.sVolumes.Vpa = randVolumes(1);
sStateVec.sVolumes.Vpu = randVolumes(2);
sStateVec.sVolumes.Vlv = randVolumes(3);
sStateVec.sVolumes.Vao = randVolumes(4);
sStateVec.sVolumes.Vvc = randVolumes(5);
sStateVec.sVolumes.Vrv = randVolumes(6);

sStateVec.sValves.aortic        = false;
sStateVec.sValves.pulmunary     = false;
sStateVec.sValves.mitral        = false;
sStateVec.sValves.tricuspid     = false;
