function sModelParams = ModelParamsSwift(sModelParamsInit,sModelParams,sSimParams)

ff = {'Ppl','Rsys','Rmt','Rav','Rtc','Rpv','Rpul','Lav','Lpv'};
for ffIdx = 1:numel(ff)
        currentVal = sModelParams.(ff{ffIdx});
        initVal = sModelParamsInit.(ff{ffIdx});
        newVal = ImplementSwiftFilter(initVal,currentVal,sSimParams.sParamsSwift);
        sModelParams.(ff{ffIdx}) = newVal;        
end

ff = {'P0','lambda','V0','Vd','Ees'};
fPre = {'sLvf','sRvf','sSPT'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        currentVal = sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
        initVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx});
        newVal = ImplementSwiftFilter(initVal,currentVal,sSimParams.sParamsSwift);
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = newVal;        
    end
end

ff = {'P0','lambda','V0'};
fPre = {'sPcd'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        currentVal = sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
        initVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx});
        newVal = ImplementSwiftFilter(initVal,currentVal,sSimParams.sParamsSwift);
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = newVal;        
    end
end

ff = {'Vd','Ees'};
fPre = {'sVc','sPa','sPu','sAo'};
for fPreIdx =1:numel(fPre)
    for ffIdx = 1:numel(ff)
        currentVal = sModelParams.(fPre{fPreIdx}).(ff{ffIdx});
        initVal = sModelParamsInit.(fPre{fPreIdx}).(ff{ffIdx});
        newVal = ImplementSwiftFilter(initVal,currentVal,sSimParams.sParamsSwift);
        sModelParams.(fPre{fPreIdx}).(ff{ffIdx}) = newVal;        
    end
end

end

function newVal = ImplementSwiftFilter(initVal,currentVal,sParamsSwift)
limits = sort(initVal * [(1+sParamsSwift.paramMaxAbsChange) , (1-sParamsSwift.paramMaxAbsChange)]);
noiseVal = initVal * sParamsSwift.noiseStd * randn;
currentNoiseVal = currentVal - initVal; 
newNoiseVal = (1-sParamsSwift.iirAlfa)*currentNoiseVal + sParamsSwift.iirAlfa*noiseVal;
newVal = initVal + newNoiseVal;
newVal = min(max(newVal,limits(1)),limits(2));
end