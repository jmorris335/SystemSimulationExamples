lA = 0.5;
lB = 0.5;
g = 9.81;

step = 0.01;
time = 0:step:10;

thA = zeros(length(time), 1);
thB = zeros(length(time), 1);
omegaA = zeros(length(time), 1);
omegaB = zeros(length(time), 1);
alphaA = zeros(length(time), 1);
alphaB = zeros(length(time), 1);
xA = zeros(length(time), 1);
yA = zeros(length(time), 1);
xB = zeros(length(time), 1);
yB = zeros(length(time), 1);

thA(1) = pi / 4;
thB(1) = pi / 4;

for i = 1:length(time)-1
    alphaB(i+1) = f_alphaB(thA(i), thB(i), omegaA(i), alphaA(i), lA, lB, g);
    if mod(time(i), 6) < 3
        omegaA(i+1) = pi/3;
    else
        omegaA(i+1) = -pi/3;
    end
    alphaA(i+1) = (omegaA(i+1) - omegaA(i)) / step;
    omegaB(i+1) = omegaB(i) + alphaB(i+1) * step;
    thA(i+1) = thA(i) + omegaA(i+1) * step;
    thB(i+1) = thB(i) + omegaB(i+1) * step;
    xB(i+1) = xA(i+1) + lA * sin(thA(i+1));
    yB(i+1) = yA(i+1) - lA * cos(thA(i+1));
end

animateDoublePendulum(time, 0, 0, thA, thB, lA, lB, step);

function [alphaB] = f_alphaB(thetaA, thetaB, omegaA, alphaA, lA, lB, g)
    xddot = lA * (alphaA * cos(thetaA) - omegaA * omegaA * sin(thetaA));
    yddot = lA * (alphaA * sin(thetaA) + omegaA * omegaA * cos(thetaA));
    alphaB = -1 / lB * (xddot * cos(thetaB) + sin(thetaB) * (yddot + g));
end