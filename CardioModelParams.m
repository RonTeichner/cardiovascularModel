function sModelParams = CardioModelParams(article)

sModelParams.mmHg_to_Pa = 133.322387415; % 1[mmHg] = 133.322387415[Pa]
sModelParams.Pa_to_mmHg = 1/sModelParams.mmHg_to_Pa;
sModelParams.mmHg_to_kPa = sModelParams.mmHg_to_Pa/1e3;

switch article
    case 'Simulation of cardiovascular system diseases by including'     
        
        sModelParams.sDriverFunc.ts = 1e-6; % [sec]
        sModelParams.sDriverFunc.params.aVec = 1;
        sModelParams.sDriverFunc.params.bVec = 80;
        sModelParams.sDriverFunc.params.cVec = 0.27;
        sModelParams.sDriverFunc.params.n = 1;
        sModelParams.sDriverFunc.tVec = [0:sModelParams.sDriverFunc.ts:0.6]; % [sec]
        
        driveMat = zeros(sModelParams.sDriverFunc.params.n , numel(sModelParams.sDriverFunc.tVec));
        for i = 1:sModelParams.sDriverFunc.params.n
            driveMat(i,:) = sModelParams.sDriverFunc.params.aVec(i) * exp(-sModelParams.sDriverFunc.params.bVec(i) * (sModelParams.sDriverFunc.tVec - sModelParams.sDriverFunc.params.cVec(i)).^2);
        end
        sModelParams.sDriverFunc.vals = sum(driveMat,1); % [no-units]
        [~,maxIdx] = max(sModelParams.sDriverFunc.vals);
        maxTime = sModelParams.sDriverFunc.tVec(maxIdx);
        sModelParams.sDriverFunc.centerIdx = maxIdx;
        sModelParams.sDriverFunc.tVec = sModelParams.sDriverFunc.tVec - maxTime;
        
        sModelParams.sDriverFunc.tVec = [sModelParams.sDriverFunc.tVec(1) - sModelParams.sDriverFunc.ts , sModelParams.sDriverFunc.tVec , sModelParams.sDriverFunc.tVec(end) + sModelParams.sDriverFunc.ts];
        sModelParams.sDriverFunc.vals = [0 , sModelParams.sDriverFunc.vals , 0];
        sModelParams.sDriverFunc.centerIdx = sModelParams.sDriverFunc.centerIdx + 1;
        
        %figure; plot(sModelParams.sDriverFunc.tVec, sModelParams.sDriverFunc.vals); xlabel('sec'); grid on;
        
        sModelParams.heartRate = 80; % [beats@min]
        
        sModelParams.A = [1 -1 0 0 0 0 ; 0 1 -1 0 0 0 ; 0 0 1 -1 0 0 ; 0 0 0 1 -1 0 ; 0 0 0 0 1 -1 ; -1 0 0 0 0 1];
        
        % one of the folowwing total blood volume should be used:
        sModelParams.totalBloodVolume = 5.5; %[liter] = [l]
        sModelParams.stressedBloodVolume = 1.5; %[liter] = [l]
        
        sModelParams.Ppl = -4; % [mmHg]
        
        sModelParams.Rsys = 140; % [KPa*s/l]
        sModelParams.Rmt = 0.06; % [KPa*s/l]
        sModelParams.Rav = 1.4;  % [KPa*s/l]
        sModelParams.Rtc = 0.18; % [KPa*s/l]
        sModelParams.Rpv = 0.48; % [KPa*s/l]
        sModelParams.Rpul = 19;  % [KPa*s/l]
        
        Lav = 121e-6; Lpv = 100e-6; %1e-6 [KmmHg*s^2/l]
        sModelParams.Lav = Lav * sModelParams.mmHg_to_Pa; % [KPa*s^2/l]
        sModelParams.Lpv = Lpv * sModelParams.mmHg_to_Pa; % [KPa*s^2/l]
        
        sModelParams.sLvf.P0        = 0.17; % [KPa]
        sModelParams.sLvf.lambda    = 15;   % [1/l]
        sModelParams.sLvf.V0        = 0.005;% [l]
        sModelParams.sLvf.Vd        = 0.005;% [l]
        sModelParams.sLvf.Ees       = 454;  % [kPa/l]
        
        sModelParams.sRvf.P0        = 0.16; % [KPa]
        sModelParams.sRvf.lambda    = 15;   % [1/l]
        sModelParams.sRvf.V0        = 0.005;% [l]
        sModelParams.sRvf.Vd        = 0.005;% [l]
        sModelParams.sRvf.Ees       = 87;   % [kPa/l]
        
        sModelParams.sSPT.P0        = 0.148;% [KPa]
        sModelParams.sSPT.lambda    = 435;  % [1/l]
        sModelParams.sSPT.V0        = 0.002;% [l]
        sModelParams.sSPT.Vd        = 0.002;% [l]
        sModelParams.sSPT.Ees       = 6500; % [kPa/l]
        
        sModelParams.sPcd.P0        = 0.0667;% [KPa]
        sModelParams.sPcd.lambda    = 30;    % [1/l]
        sModelParams.sPcd.V0        = 0.2;   % [l]
        
        sModelParams.sVc.Vd        = 2.83;   % [l]
        sModelParams.sVc.Ees       = 1.5;    % [kPa/l]
        
        sModelParams.sPa.Vd        = 0.16;   % [l]
        sModelParams.sPa.Ees       = 45;     % [kPa/l]
        
        sModelParams.sPu.Vd        = 0.2;    % [l]
        sModelParams.sPu.Ees       = 0.8;    % [kPa/l]
        
        sModelParams.sAo.Vd        = 0.8;    % [l]
        sModelParams.sAo.Ees       = 94;     % [kPa/l]
    case 'Unique parameter identification for cardiac diagnosis in critical care using minimal data sets'
        
        sModelParams.heartRate = 80; % [beats@min]
        
        sModelParams.sDriverFunc.ts = 1e-6; % [sec]
        sModelParams.sDriverFunc.params.aVec = 1;
        sModelParams.sDriverFunc.params.bVec = 80;
        sModelParams.sDriverFunc.params.cVec = (60/sModelParams.heartRate)/2;
        sModelParams.sDriverFunc.params.n = 1;
        sModelParams.sDriverFunc.tVec = [0:sModelParams.sDriverFunc.ts:0.6]; % [sec]
        
        driveMat = zeros(sModelParams.sDriverFunc.params.n , numel(sModelParams.sDriverFunc.tVec));
        for i = 1:sModelParams.sDriverFunc.params.n
            driveMat(i,:) = sModelParams.sDriverFunc.params.aVec(i) * exp(-sModelParams.sDriverFunc.params.bVec(i) * (sModelParams.sDriverFunc.tVec - sModelParams.sDriverFunc.params.cVec(i)).^2);
        end
        sModelParams.sDriverFunc.vals = sum(driveMat,1); % [no-units]
        [~,maxIdx] = max(sModelParams.sDriverFunc.vals);
        maxTime = sModelParams.sDriverFunc.tVec(maxIdx);
        sModelParams.sDriverFunc.centerIdx = maxIdx;
        sModelParams.sDriverFunc.tVec = sModelParams.sDriverFunc.tVec - maxTime;
        
        sModelParams.sDriverFunc.tVec = [sModelParams.sDriverFunc.tVec(1) - sModelParams.sDriverFunc.ts , sModelParams.sDriverFunc.tVec , sModelParams.sDriverFunc.tVec(end) + sModelParams.sDriverFunc.ts];
        sModelParams.sDriverFunc.vals = [0 , sModelParams.sDriverFunc.vals , 0];
        sModelParams.sDriverFunc.centerIdx = sModelParams.sDriverFunc.centerIdx + 1;
        
        %figure; plot(sModelParams.sDriverFunc.tVec, sModelParams.sDriverFunc.vals); xlabel('sec'); grid on;
        
        
        
        sModelParams.A = [1 -1 0 0 0 0 ; 0 1 -1 0 0 0 ; 0 0 1 -1 0 0 ; 0 0 0 1 -1 0 ; 0 0 0 0 1 -1 ; -1 0 0 0 0 1];
        
        % one of the folowwing total blood volume should be used:
        sModelParams.totalBloodVolume = 5.5; %[liter] = [l]
        sModelParams.stressedBloodVolume = 1.5; %[liter] = [l]
        
        sModelParams.Ppl = -4; % [mmHg]
        
        sModelParams.Rsys = 1.0889; % [KmmHg*s/l]
        sModelParams.Rsys = sModelParams.Rsys*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        sModelParams.Rmt = 0.0158; % [KmmHg*s/l]
        sModelParams.Rmt = sModelParams.Rmt*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        sModelParams.Rav = 0.0180;  % [KmmHg*s/l]
        sModelParams.Rav = sModelParams.Rav*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        sModelParams.Rtc = 0.0237; % [KmmHg*s/l]
        sModelParams.Rtc = sModelParams.Rtc*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        sModelParams.Rpv = 0.0055; % [KmmHg*s/l]
        sModelParams.Rpv = sModelParams.Rpv*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        sModelParams.Rpul = 0.1552;  % [KmmHg*s/l]
        sModelParams.Rpul = sModelParams.Rpul*sModelParams.mmHg_to_Pa; % [KPa*s/l]
        
        Lav = 1.2189e-4; Lpv = 1e-6; %1e-6 [KmmHg*s^2/l]
        sModelParams.Lav = Lav * sModelParams.mmHg_to_Pa; % [KPa*s^2/l]
        sModelParams.Lpv = Lpv * sModelParams.mmHg_to_Pa; % [KPa*s^2/l]
        
        sModelParams.sLvf.P0        = 0.1203*sModelParams.mmHg_to_kPa; % [KPa]
        sModelParams.sLvf.lambda    = 0.033*1e3;   % [1/l]
        sModelParams.sLvf.V0        = 0;% [l]
        sModelParams.sLvf.Vd        = 0;% [l]
        sModelParams.sLvf.Ees       = 2.8978*sModelParams.mmHg_to_Pa;  % [kPa/l]
        
        sModelParams.sRvf.P0        = 0.2157*sModelParams.mmHg_to_kPa; % [KPa]
        sModelParams.sRvf.lambda    = 0.023*1e3;   % [1/l]
        sModelParams.sRvf.V0        = 0;% [l]
        sModelParams.sRvf.Vd        = 0;% [l]
        sModelParams.sRvf.Ees       = 0.585*sModelParams.mmHg_to_kPa;   % [kPa/l]
        
        sModelParams.sSPT.P0        = 1.1101*sModelParams.mmHg_to_kPa;% [KPa]
        sModelParams.sSPT.lambda    = 0.435*1e3;  % [1/l]
        sModelParams.sSPT.V0        = 0.002;% [l]
        sModelParams.sSPT.Vd        = 0;% [l]
        sModelParams.sSPT.Ees       = 48.754*sModelParams.mmHg_to_kPa; % [kPa/l]
        
        sModelParams.sPcd.P0        = 0.5003*sModelParams.mmHg_to_kPa;% [KPa]
        sModelParams.sPcd.lambda    = 0.030*1e3;    % [1/l]
        sModelParams.sPcd.V0        = 0.2;   % [l]
        
        sModelParams.sVc.Vd        = 0;   % [l]
        sModelParams.sVc.Ees       = 0.0059*sModelParams.mmHg_to_kPa;    % [kPa/l]
        
        sModelParams.sPa.Vd        = 0;   % [l]
        sModelParams.sPa.Ees       = 0.369*sModelParams.mmHg_to_kPa;     % [kPa/l]
        
        sModelParams.sPu.Vd        = 0;    % [l]
        sModelParams.sPu.Ees       = 0.0073*sModelParams.mmHg_to_kPa;    % [kPa/l]
        
        sModelParams.sAo.Vd        = 0;    % [l]
        sModelParams.sAo.Ees       = 0.6913*sModelParams.mmHg_to_kPa;     % [kPa/l]
end
