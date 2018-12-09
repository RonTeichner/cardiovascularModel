function CardioPlots(sAllInfoVec,lastIter,xlabelMethod,xLimits,sSimParams)

switch xlabelMethod
    case 'sec'
        tVec = sAllInfoVec.tVec(1:lastIter);
        [~,startIdx] = min(abs(tVec - xLimits(1)));
        [~,stopIdx] = min(abs(tVec - xLimits(2)));
        tVec = tVec(startIdx:stopIdx);
    case 'samples'
        tVec = xLimits(1):min(lastIterxLimits(2));
end

figure; 
subplot(2,1,1); plot(tVec,sAllInfoVec.driverFuncVal(startIdx:stopIdx)); xlabel('sec'); title('driverFunc e(t)'); grid on;
subplot(2,1,2); plot(tVec,sAllInfoVec.sVolumes.totalBloodVol(startIdx:stopIdx)); xlabel('sec'); ylabel('l'); title('total blood vol'); grid on;

figure; 
subplot(2,4,1); plot(tVec,sAllInfoVec.sPressures.Pao(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('aortic pressure'); grid on;
subplot(2,4,2); plot(tVec,sAllInfoVec.sPressures.Pvc(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('venc-cava pressure'); grid on;
subplot(2,4,3); plot(tVec,sAllInfoVec.sPressures.Ppa(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('p-a pressure'); grid on;
subplot(2,4,4); plot(tVec,sAllInfoVec.sPressures.Ppu(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('p-v pressure'); grid on;

subplot(2,4,5); plot(tVec,sAllInfoVec.sVolumes.Vao(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('aortic vol'); grid on;
subplot(2,4,6); plot(tVec,sAllInfoVec.sVolumes.Vvc(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('venc-cava vol'); grid on;
subplot(2,4,7); plot(tVec,sAllInfoVec.sVolumes.Vpa(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('p-a vol'); grid on;
subplot(2,4,8); plot(tVec,sAllInfoVec.sVolumes.Vpu(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('p-v vol'); grid on;

figure;
subplot(2,3,4); plot(tVec,sAllInfoVec.sVolumes.Vao(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('aortic vol'); grid on;
subplot(2,3,1); plot(tVec,sAllInfoVec.sVolumes.Vvc(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('venc-cava vol'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sVolumes.Vpa(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('p-a vol'); grid on;
subplot(2,3,6); plot(tVec,sAllInfoVec.sVolumes.Vpu(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('p-u vol'); grid on;
subplot(2,3,5); plot(tVec,sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3); title('Vlv volume'); ylabel('[ml]'); xlabel('sec'); grid on;
subplot(2,3,2); plot(tVec,sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3); title('Vrv volume'); ylabel('[ml]'); xlabel('sec'); grid on;

figure;
subplot(2,2,1); plot(tVec,sAllInfoVec.sPressures.Plv(startIdx:stopIdx)); title('Plv'); ylabel('[mmHg]'); xlabel('sec'); grid on;
subplot(2,2,2); plot(tVec,sAllInfoVec.sPressures.Prv(startIdx:stopIdx)); title('Prv'); ylabel('[mmHg]'); xlabel('sec'); grid on; 

subplot(2,2,3); plot(tVec,sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3); title('Vlv'); ylabel('[ml]'); xlabel('sec'); grid on;
subplot(2,2,4); plot(tVec,sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3); title('Vrv'); ylabel('[ml]'); xlabel('sec'); grid on;

figure;
subplot(2,3,1); plot(tVec,sAllInfoVec.sPressures.Plvf(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('Plvf'); grid on;
subplot(2,3,2); plot(tVec,sAllInfoVec.sPressures.Prvf(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('Prvf'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sPressures.Pspt(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('Pspt'); grid on;

subplot(2,3,4); plot(tVec,sAllInfoVec.sVolumes.Vlvf(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('Vlvf'); grid on;
subplot(2,3,5); plot(tVec,sAllInfoVec.sVolumes.Vrvf(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('Vrvf'); grid on;
subplot(2,3,6); plot(tVec,sAllInfoVec.sVolumes.Vspt(startIdx:stopIdx)./1e-3); xlabel('sec'); ylabel('ml'); title('Vspt'); grid on;

figure; 
subplot(3,1,1); plot(tVec,sAllInfoVec.sVolumes.debugVsptSolDiff(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); title('Vspt solution err'); grid on;
percentageVsptErr(startIdx:stopIdx) = transpose(sAllInfoVec.sVolumes.debugVsptSolDiff(startIdx:stopIdx)) ./ sAllInfoVec.sPressures.Pspt(startIdx:stopIdx) * 100;
subplot(3,1,2); plot(tVec,percentageVsptErr(startIdx:stopIdx)); xlabel('sec'); ylabel('[%]'); title('Vspt solution err [%]'); grid on;
subplot(3,1,3); plot(tVec,[0;diff(sAllInfoVec.sVolumes.Vspt(startIdx:stopIdx))]./1e-3); xlabel('sec'); ylabel('ml'); title('Vspt solution diff'); grid on;

figure; 
subplot(2,3,4); plot(tVec,sAllInfoVec.sFlows.Qsys(startIdx:stopIdx)); xlabel('sec'); ylabel('l/s'); title('Qsys'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sFlows.Qpul(startIdx:stopIdx)); xlabel('sec'); ylabel('l/s'); title('Qpul'); grid on;

subplot(2,3,5); 
Qav = sAllInfoVec.sFlows.Qav(startIdx:stopIdx); 
plot(tVec,Qav); xlabel('sec'); ylabel('l/s'); title('Qav'); grid on; 
closeIdx = not(sAllInfoVec.sValves.aortic(startIdx:stopIdx)); hold on; plot(tVec(closeIdx),Qav(closeIdx),'r.');

subplot(2,3,2); 
Qpv = sAllInfoVec.sFlows.Qpv(startIdx:stopIdx); 
plot(tVec,Qpv); xlabel('sec'); ylabel('l/s'); title('Qpv'); grid on; 
closeIdx = not(sAllInfoVec.sValves.pulmunary(startIdx:stopIdx)); hold on; plot(tVec(closeIdx),Qpv(closeIdx),'r.');

subplot(2,3,6); 
Qmt = sAllInfoVec.sFlows.Qmt(startIdx:stopIdx); 
plot(tVec,Qmt); xlabel('sec'); ylabel('l/s'); title('Qmt'); grid on; 
closeIdx = not(sAllInfoVec.sValves.mitral(startIdx:stopIdx)); hold on; plot(tVec(closeIdx),Qmt(closeIdx),'r.');

subplot(2,3,1); 
Qtc = sAllInfoVec.sFlows.Qtc(startIdx:stopIdx); 
plot(tVec,Qtc); xlabel('sec'); ylabel('l/s'); title('Qtc'); grid on; 
closeIdx = not(sAllInfoVec.sValves.tricuspid(startIdx:stopIdx)); hold on; plot(tVec(closeIdx),Qtc(closeIdx),'r.');

figure; hold all; 
plot(tVec,sSimParams.ts*cumsum(sAllInfoVec.sFlows.Qsys(startIdx:stopIdx))./1e-3); xlabel('sec'); ylabel('ml');  grid on;
plot(tVec,sSimParams.ts*cumsum(sAllInfoVec.sFlows.Qpul(startIdx:stopIdx))./1e-3); xlabel('sec'); ylabel('ml'); grid on;


Qav = sAllInfoVec.sFlows.Qav(startIdx:stopIdx); 
plot(tVec,sSimParams.ts*cumsum(Qav)./1e-3); xlabel('sec'); ylabel('ml'); grid on; 

Qpv = sAllInfoVec.sFlows.Qpv(startIdx:stopIdx); 
plot(tVec,sSimParams.ts*cumsum(Qpv)./1e-3); xlabel('sec'); ylabel('ml'); grid on; 

Qmt = sAllInfoVec.sFlows.Qmt(startIdx:stopIdx); 
plot(tVec,sSimParams.ts*cumsum(Qmt)./1e-3); xlabel('sec'); ylabel('ml'); grid on; 
 
Qtc = sAllInfoVec.sFlows.Qtc(startIdx:stopIdx); 
plot(tVec,sSimParams.ts*cumsum(Qtc)./1e-3); xlabel('sec'); ylabel('ml'); grid on; 

title('Flow cumsum');
legend('Qsys','Qpul','Qav','Qpv','Qmt','Qtc');

% figure;
% subplot(2,1,1);
% plot(tVec,sAllInfoVec.sPressures.Prv(startIdx:stopIdx));
% hold all; plot(tVec,sAllInfoVec.sPressures.Pvc(startIdx:stopIdx)); xlabel('sec'); ylabel('mmHg'); grid on;
% legend('Prv','Pvc');
% 
% subplot(2,1,2);
% Qtc = sAllInfoVec.sFlows.Qtc(startIdx:stopIdx); 
% plot(tVec,Qtc); xlabel('sec'); ylabel('l/s'); title('Qtc'); grid on; 
% closeIdx = not(sAllInfoVec.sValves.tricuspid(startIdx:stopIdx)); hold on; plot(tVec(closeIdx),Qtc(closeIdx),'r.');

figure;
subplot(2,3,4); plot(tVec,sAllInfoVec.sPressures.Plv(startIdx:stopIdx)); title('Plv'); ylabel('[mmHg]'); xlabel('sec'); grid on;
hold all; plot(tVec,sAllInfoVec.sPressures.Pao(startIdx:stopIdx)); plot(tVec,sAllInfoVec.sPressures.Ppu(startIdx:stopIdx));
legend('Plv','Pao','Ppu');
%xlim([10,12])
subplot(2,3,5); plot(tVec,sAllInfoVec.sPressures.Prv(startIdx:stopIdx)); title('Prv'); ylabel('[mmHg]'); xlabel('sec'); grid on; 
hold all; plot(tVec,sAllInfoVec.sPressures.Ppa(startIdx:stopIdx)); plot(tVec,sAllInfoVec.sPressures.Pvc(startIdx:stopIdx));
legend('Prv','Ppa','Pvc');
%xlim([10,12])
maxV = max([sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3;sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3]);
minV = min([sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3;sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3]);
subplot(2,3,1); plot(tVec,sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3); title('Vlv'); ylabel('[ml]'); xlabel('sec'); grid on; ylim([min(minV,0) , maxV+10]);
%xlim([10,12])
subplot(2,3,2); plot(tVec,sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3); title('Vrv'); ylabel('[ml]'); xlabel('sec'); grid on; ylim([min(minV,0) , maxV+10]);
%xlim([10,12])


subplot(2,3,3); scatter(sAllInfoVec.sVolumes.Vlv(startIdx:stopIdx)./1e-3 , sAllInfoVec.sPressures.Plv(startIdx:stopIdx),'.'); xlabel('[ml]'); ylabel('[mmHg]'); grid on; title('Left Ventricle'); ylim([-5,140]); xlim([0,150]);
subplot(2,3,6); scatter(sAllInfoVec.sVolumes.Vrv(startIdx:stopIdx)./1e-3 , sAllInfoVec.sPressures.Prv(startIdx:stopIdx),'.'); xlabel('[ml]'); ylabel('[mmHg]'); grid on; title('Right Ventricle'); ylim([-5,140]); xlim([0,150]);
end

