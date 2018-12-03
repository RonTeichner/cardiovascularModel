function sModelParams = CardioModelParams()


sModelParams.sDriverFunc.ts = 1e-3; % [sec]
sModelParams.sDriverFunc.params.aVec = 1;
sModelParams.sDriverFunc.params.bVec = 80;
sModelParams.sDriverFunc.params.cVec = 0.27;
sModelParams.sDriverFunc.params.n = 1;
sModelParams.sDriverFunc.tVec = [0:sModelParams.sDriverFunc.ts:0.6]; % [sec]

driveMat = zeros(sModelParams.sDriverFunc.params.n , numel(sModelParams.sDriverFunc.tVec));
for i = 1:sModelParams.sDriverFunc.params.n
    driveMat(i,:) = sModelParams.sDriverFunc.params.aVec(i) * exp(-sModelParams.sDriverFunc.params.bVec(i) * (sModelParams.sDriverFunc.tVec - sModelParams.sDriverFunc.params.cVec(i)).^2);
end
sModelParams.sDriverFunc.vals = sum(driveMat,1);
[~,maxIdx] = max(sModelParams.sDriverFunc.vals);
maxTime = sModelParams.sDriverFunc.tVec(maxIdx);
sModelParams.sDriverFunc.tVec = sModelParams.sDriverFunc.tVec - maxTime;

%figure; plot(sModelParams.sDriverFunc.tVec, sModelParams.sDriverFunc.vals); xlabel('sec'); grid on;

sModelParams.heartRate = 80; % [beats@min]

sModelParams.A = [1 -1 0 0 0 0 ; 0 1 -1 0 0 0 ; 0 0 1 -1 0 0 ; 0 0 0 1 -1 0 ; 0 0 0 0 1 -1 ; -1 0 0 0 0 1];
sModelParams.totalBloodVolume = 5.5; %[liter]
sModelParams.Ppl = -4; % [mmHg]

sModelParams.Rsys = 140;
sModelParams.Rmt = 0.06;
sModelParams.Rav = 1.4;
sModelParams.Rtc = 0.18;
sModelParams.Rpv = 0.48;
sModelParams.Rpul = 19;

sModelParams.Lav = 1e-6;
sModelParams.Lpv = 1e-6;

sModelParams.sLvf.P0        = 0.17;
sModelParams.sLvf.lambda    = 15;
sModelParams.sLvf.V0        = 0.005;
sModelParams.sLvf.Vd        = 0.005;
sModelParams.sLvf.Ees       = 454;

sModelParams.sRvf.P0        = 0.16;
sModelParams.sRvf.lambda    = 15;
sModelParams.sRvf.V0        = 0.005;
sModelParams.sRvf.Vd        = 0.005;
sModelParams.sRvf.Ees       = 87;

sModelParams.sSPT.P0        = 0.148;
sModelParams.sSPT.lambda    = 435;
sModelParams.sSPT.V0        = 0.002;
sModelParams.sSPT.Vd        = 0.002;
sModelParams.sSPT.Ees       = 6500;

sModelParams.sPcd.P0        = 0.0667;
sModelParams.sPcd.lambda    = 30;
sModelParams.sPcd.V0        = 0.2;

sModelParams.sVc.Vd        = 2.83;
sModelParams.sVc.Ees       = 1.5;

sModelParams.sPa.Vd        = 0.16;
sModelParams.sPa.Ees       = 45;

sModelParams.sPu.Vd        = 0.2;
sModelParams.sPu.Ees       = 0.8;

sModelParams.sAo.Vd        = 0.8;
sModelParams.sAo.Ees       = 94;
