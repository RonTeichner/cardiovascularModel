function CardioPlots(sAllInfoVec,lastIter,xlabelMethod)

switch xlabelMethod
    case 'sec'
        tVec = sAllInfoVec.tVec(1:lastIter);
    case 'samples'
        tVec = 1:lastIter;
end

figure; 
subplot(2,1,1); plot(tVec,sAllInfoVec.driverFuncVal(1:lastIter)); xlabel('sec'); title('driverFunc e(t)'); grid on;
subplot(2,1,2); plot(tVec,sAllInfoVec.sVolumes.totalBloodVol(1:lastIter)); xlabel('sec'); ylabel('l'); title('total blood vol'); grid on;

figure; 
subplot(2,4,1); plot(tVec,sAllInfoVec.sPressures.Pao(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('aortic pressure'); grid on;
subplot(2,4,2); plot(tVec,sAllInfoVec.sPressures.Pvc(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('venc-cava pressure'); grid on;
subplot(2,4,3); plot(tVec,sAllInfoVec.sPressures.Ppa(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('p-a pressure'); grid on;
subplot(2,4,4); plot(tVec,sAllInfoVec.sPressures.Ppu(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('p-v pressure'); grid on;

subplot(2,4,5); plot(tVec,sAllInfoVec.sVolumes.Vao(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('aortic vol'); grid on;
subplot(2,4,6); plot(tVec,sAllInfoVec.sVolumes.Vvc(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('venc-cava vol'); grid on;
subplot(2,4,7); plot(tVec,sAllInfoVec.sVolumes.Vpa(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('p-a vol'); grid on;
subplot(2,4,8); plot(tVec,sAllInfoVec.sVolumes.Vpu(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('p-v vol'); grid on;

figure;
subplot(2,3,4); plot(tVec,sAllInfoVec.sVolumes.Vao(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('aortic vol'); grid on;
subplot(2,3,1); plot(tVec,sAllInfoVec.sVolumes.Vvc(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('venc-cava vol'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sVolumes.Vpa(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('p-a vol'); grid on;
subplot(2,3,6); plot(tVec,sAllInfoVec.sVolumes.Vpu(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('p-u vol'); grid on;
subplot(2,3,5); plot(tVec,sAllInfoVec.sVolumes.Vlv(1:lastIter)./1e-3); title('Vlv volume'); ylabel('[ml]'); xlabel('sec'); grid on;
subplot(2,3,2); plot(tVec,sAllInfoVec.sVolumes.Vrv(1:lastIter)./1e-3); title('Vrv volume'); ylabel('[ml]'); xlabel('sec'); grid on;

figure;
subplot(2,2,1); plot(tVec,sAllInfoVec.sPressures.Plv(1:lastIter)); title('Plv'); ylabel('[mmHg]'); xlabel('sec'); grid on;
subplot(2,2,2); plot(tVec,sAllInfoVec.sPressures.Prv(1:lastIter)); title('Prv'); ylabel('[mmHg]'); xlabel('sec'); grid on; 

subplot(2,2,3); plot(tVec,sAllInfoVec.sVolumes.Vlv(1:lastIter)./1e-3); title('Vlv'); ylabel('[ml]'); xlabel('sec'); grid on;
subplot(2,2,4); plot(tVec,sAllInfoVec.sVolumes.Vrv(1:lastIter)./1e-3); title('Vrv'); ylabel('[ml]'); xlabel('sec'); grid on;

figure;
subplot(2,3,1); plot(tVec,sAllInfoVec.sPressures.Plvf(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('Plvf'); grid on;
subplot(2,3,2); plot(tVec,sAllInfoVec.sPressures.Prvf(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('Prvf'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sPressures.Pspt(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('Pspt'); grid on;

subplot(2,3,4); plot(tVec,sAllInfoVec.sVolumes.Vlvf(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('Vlvf'); grid on;
subplot(2,3,5); plot(tVec,sAllInfoVec.sVolumes.Vrvf(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('Vrvf'); grid on;
subplot(2,3,6); plot(tVec,sAllInfoVec.sVolumes.Vspt(1:lastIter)./1e-3); xlabel('sec'); ylabel('ml'); title('Vspt'); grid on;

figure; 
subplot(2,1,1); plot(tVec,sAllInfoVec.sVolumes.debugVsptSolDiff(1:lastIter)); xlabel('sec'); ylabel('mmHg'); title('Vspt solution err'); grid on;
subplot(2,1,2); plot(tVec,[0;diff(sAllInfoVec.sVolumes.Vspt(1:lastIter))]./1e-3); xlabel('sec'); ylabel('ml'); title('Vspt solution diff'); grid on;

figure; 
subplot(2,3,4); plot(tVec,sAllInfoVec.sFlows.Qsys(1:lastIter)); xlabel('sec'); ylabel('l/s'); title('Qsys'); grid on;
subplot(2,3,3); plot(tVec,sAllInfoVec.sFlows.Qpul(1:lastIter)); xlabel('sec'); ylabel('l/s'); title('Qpul'); grid on;

subplot(2,3,5); 
Qav = sAllInfoVec.sFlows.Qav(1:lastIter); 
plot(tVec,Qav); xlabel('sec'); ylabel('l/s'); title('Qav'); grid on; 
closeIdx = not(sAllInfoVec.sValves.aortic(1:lastIter)); hold on; plot(tVec(closeIdx),Qav(closeIdx),'r.');

subplot(2,3,2); 
Qpv = sAllInfoVec.sFlows.Qpv(1:lastIter); 
plot(tVec,Qpv); xlabel('sec'); ylabel('l/s'); title('Qpv'); grid on; 
closeIdx = not(sAllInfoVec.sValves.pulmunary(1:lastIter)); hold on; plot(tVec(closeIdx),Qpv(closeIdx),'r.');

subplot(2,3,6); 
Qmt = sAllInfoVec.sFlows.Qmt(1:lastIter); 
plot(tVec,Qmt); xlabel('sec'); ylabel('l/s'); title('Qmt'); grid on; 
closeIdx = not(sAllInfoVec.sValves.mitral(1:lastIter)); hold on; plot(tVec(closeIdx),Qmt(closeIdx),'r.');

subplot(2,3,1); 
Qtc = sAllInfoVec.sFlows.Qtc(1:lastIter); 
plot(tVec,Qtc); xlabel('sec'); ylabel('l/s'); title('Qtc'); grid on; 
closeIdx = not(sAllInfoVec.sValves.tricuspid(1:lastIter)); hold on; plot(tVec(closeIdx),Qtc(closeIdx),'r.');

figure; hold all; 
plot(tVec,cumsum(sAllInfoVec.sFlows.Qsys(1:lastIter))); xlabel('sec'); ylabel('l');  grid on;
plot(tVec,cumsum(sAllInfoVec.sFlows.Qpul(1:lastIter))); xlabel('sec'); ylabel('l'); grid on;


Qav = sAllInfoVec.sFlows.Qav(1:lastIter); 
plot(tVec,cumsum(Qav)); xlabel('sec'); ylabel('l'); grid on; 

Qpv = sAllInfoVec.sFlows.Qpv(1:lastIter); 
plot(tVec,cumsum(Qpv)); xlabel('sec'); ylabel('l'); grid on; 

Qmt = sAllInfoVec.sFlows.Qmt(1:lastIter); 
plot(tVec,cumsum(Qmt)); xlabel('sec'); ylabel('l'); grid on; 
 
Qtc = sAllInfoVec.sFlows.Qtc(1:lastIter); 
plot(tVec,cumsum(Qtc)); xlabel('sec'); ylabel('l'); grid on; 

title('Flow cumsum');
legend('Qsys','Qpul','Qav','Qpv','Qmt','Qtc');

figure;
subplot(2,1,1);
plot(tVec,sAllInfoVec.sPressures.Prv(1:lastIter));
hold all; plot(tVec,sAllInfoVec.sPressures.Pvc(1:lastIter)); xlabel('sec'); ylabel('mmHg'); grid on;
legend('Prv','Pvc');

subplot(2,1,2);
Qtc = sAllInfoVec.sFlows.Qtc(1:lastIter); 
plot(tVec,Qtc); xlabel('sec'); ylabel('l/s'); title('Qtc'); grid on; 
closeIdx = not(sAllInfoVec.sValves.tricuspid(1:lastIter)); hold on; plot(tVec(closeIdx),Qtc(closeIdx),'r.');

figure;
subplot(2,2,3); plot(tVec,sAllInfoVec.sPressures.Plv(1:lastIter)); title('Plv'); ylabel('[mmHg]'); xlabel('sec'); grid on;
hold all; plot(tVec,sAllInfoVec.sPressures.Pao(1:lastIter)); plot(tVec,sAllInfoVec.sPressures.Ppu(1:lastIter));
legend('Plv','Pao','Ppu');
xlim([10,12])
subplot(2,2,4); plot(tVec,sAllInfoVec.sPressures.Prv(1:lastIter)); title('Prv'); ylabel('[mmHg]'); xlabel('sec'); grid on; 
hold all; plot(tVec,sAllInfoVec.sPressures.Ppa(1:lastIter)); plot(tVec,sAllInfoVec.sPressures.Pvc(1:lastIter));
legend('Prv','Ppa','Pvc');
xlim([10,12])
subplot(2,2,1); plot(tVec,sAllInfoVec.sVolumes.Vlv(1:lastIter)./1e-3); title('Vlv'); ylabel('[ml]'); xlabel('sec'); grid on;
xlim([10,12])
subplot(2,2,2); plot(tVec,sAllInfoVec.sVolumes.Vrv(1:lastIter)./1e-3); title('Vrv'); ylabel('[ml]'); xlabel('sec'); grid on;
xlim([10,12])
end

