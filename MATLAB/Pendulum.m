%{
Class: Pendulum
Author: John Morris jhmmrs@clemson.edu, ORCID: 0009-0005-6571-1959
Purpose: A basic class for simulating a rigid pendulum with a moving base
Arguments:
    theta : 1x3 array of variables for angular position, velocity, and
        acceleration (rad, rad/s, rad/s^2)
    y : 1x3 array of variables for the vertical position, velocity, and
        acceleration of the base (m, m/s, m/s^2)
    x : 1x3 array of variables for the horiztonal position, velocity, and
        acceleration of the base (m, m/s, m/s^2)
    mass : the mass of the bob (kg)
    length : the length of the tether/rod (m)
    g : gravitational acceleration (m/s^2)
Version History:
    1.0 (17 Feb 2025) : Initialized
%}

classdef Pendulum
    properties
        theta (1,3) double = [pi/4, 0, 0];          %rad, rad/s, rad/s^2
        y (1,3) double= [1, 0, 0];                  %m, m/s, m/s^2
        x (1,3) double= [0, 0, 0];                  %m, m/s, m/s^2
        mass (1,1) double {mustBePositive} = 1;     %kg
        length (1,1) double {mustBePositive} = 1;   %meters
        g (1,1) double = 9.81;                      %meters/second^2
    end

    methods
        function obj = Pendulum(theta, y, x, mass, length, g)
            if nargin >= 1
                obj.theta = theta;
            end
            if nargin >= 2
                obj.y = y;
            end
            if nargin >= 3
                obj.x = x;
            end
            if nargin >= 4
                obj.mass = mass;
            end
            if nargin >= 5
                obj.length = length;
            end
            if nargin >= 6
                obj.g = g;
            end
        end

        function [next_theta, next_y, next_x] = simulate(obj, step)
            arguments
                obj (1,1) Pendulum
                step (1,1) double = 0.1                         %seconds
            end
            next_theta(3) = obj.thetaODEFUN();
            next_theta(2) = obj.theta(2) + next_theta(3) * step;
            next_theta(1) = obj.theta(1) + next_theta(2) * step;

            next_y(3) = obj.yODEFUN();
            next_y(2) = obj.y(2) + next_y(3) * step;
            next_y(1) = obj.y(1) + next_y(2) * step;
        
            next_x(3) = obj.xODEFUN();
            next_x(2) = obj.x(2) + next_x(3) * step;
            next_x(1) = obj.x(1) + next_x(2) * step;
        end

        function [thetaprime] = thetaODEFUN(obj)
            thetaprime = -1 / obj.length * (obj.x(3) * cos(obj.theta(1)) + sin(obj.theta(1)) * (obj.y(3) + obj.g));
        end

        function [yprime] = yODEFUN(obj)
            yprime = -obj.g - obj.length * (obj.theta(3) * sin(obj.theta(1)) - obj.theta(2)^2 * cos(obj.theta(1)));
        end

        function [xprime] = xODEFUN(obj)
            xprime = obj.length * (obj.theta(2)^2 * sin(obj.theta(1)) - obj.theta(3) * cos(obj.theta(1)));
        end
    end
end