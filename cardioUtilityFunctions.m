function val = cardioUtilityFunctions(funcSym,sInputs,sFuncParams)
% function val = cardioUtilityFunctions(funcSym,sFuncParams)
% this function implements a number of utility functions that are repeating
% throughout the cardiomodel

switch funcSym
    case 'f'
        val = sFuncParams.P0 * (exp(sFuncParams.lambda*(sInputs.V - sFuncParams.V0)) - 1);
    case 'g'
        val = sInputs.e*sFuncParams.Ees*(sInputs.V - sFuncParams.Vd) + (1-sInputs.e)*cardioUtilityFunctions('f',sInputs,sFuncParams);
    case 'h'
        w = exp(-sFuncParams.R/sFuncParams.L*sFuncParams.ts);
        val = w*sInputs.Q + (1-w)*((sInputs.P1 - sInputs.P2)/sFuncParams.R);
end


end

