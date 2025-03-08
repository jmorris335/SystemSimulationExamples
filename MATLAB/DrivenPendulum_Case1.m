lA = 0.5;
lB = 0.5;
g = 9.81;
time_step = 0.01;
time = 0;
thetaA = pi/4;
thetaB = pi/4;
alphaA = 0;
omegaA = 0;
omegaB = 0;

time = time + time_step;
alphaB = f_alphaB(thetaA, thetaB, omegaA, alphaA, lA, lB, g);
omegaB(2) = alphaB * time_step + omegaB;
thetaB(2) = omegaB(2) * time_step + thetaB;

fprintf('thetaB = %.2f (when time=%.2f)', thetaB(2), time)

function [alphaB] = f_alphaB(thetaA, thetaB, omegaA, alphaA, lA, lB, g)
    xddot = lA * (alphaA * cos(thetaA) - omegaA^2 * sin(thetaA));
    yddot = lA * (alphaA * sin(thetaA) + omegaA^2 * cos(thetaA));
    alphaB = -1 / lB * (xddot * cos(thetaB) + sin(thetaB) * (yddot + g));
end