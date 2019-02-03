function sModelParams = ModelParamsSwift(sModelParamsInit,sModelParams,sSimParams)

ff = {'Ppl','Rsys','Rmt','Rav','Rtc','Rpv','Rpul','Lav','Lpv'};
for ffIdx = 1:numel(ff)
    limits = sort(sModelParamsInit.(ff{ffIdx}) * [(1+sSimParams.sParamsSwift.paramMaxAbsChange) , (1-sSimParams.sParamsSwift.paramMaxAbsChange)]);
    noiseVal = sModelParamsInit.(ff{ffIdx}) * sSimParams.sParamsSwift.noiseStd * randn;
    sModelParams.(ff{ffIdx}) = sModelParams.(ff{ffIdx}) + noiseVal;
    sModelParams.(ff{ffIdx}) = min(max(sModelParams.(ff{ffIdx}),limits(1)),limits(2));
end

ff = {'P0','lambda','V0','Vd','Ees'};
fPre = {'sLvf','sRvf','sSPT'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        limits = sort(sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * [(1+sSimParams.sParamsSwift.paramMaxAbsChange) , (1-sSimParams.sParamsSwift.paramMaxAbsChange)]);        
        noiseVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * sSimParams.sParamsSwift.noiseStd * randn;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) + noiseVal;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = min(max(sModelParams.(fPre{fPreIdx}).(ff{ffIdx}),limits(1)),limits(2));
    end
end

ff = {'P0','lambda','V0'};
fPre = {'sPcd'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        limits = sort(sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * [(1+sSimParams.sParamsSwift.paramMaxAbsChange) , (1-sSimParams.sParamsSwift.paramMaxAbsChange)]);        
        noiseVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * sSimParams.sParamsSwift.noiseStd * randn;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) + noiseVal;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = min(max(sModelParams.(fPre{fPreIdx}).(ff{ffIdx}),limits(1)),limits(2));
    end
end

ff = {'Vd','Ees'};
fPre = {'sVc','sPa','sPu','sAo'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        limits = sort(sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * [(1+sSimParams.sParamsSwift.paramMaxAbsChange) , (1-sSimParams.sParamsSwift.paramMaxAbsChange)]);        
        noiseVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx}) * sSimParams.sParamsSwift.noiseStd * randn;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) + noiseVal;
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = min(max(sModelParams.(fPre{fPreIdx}).(ff{ffIdx}),limits(1)),limits(2));
    end
end