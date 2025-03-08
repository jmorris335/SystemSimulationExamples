class Pendulum "simple pendulum"
   parameter Real m=1, g=9.81, l=1;
   Real theta(start=0.7);
   Real omega(start=0.0);
equation
   der(omega) = -g/l * sin(theta);
   der(theta) = omega;
end Pendulum;
