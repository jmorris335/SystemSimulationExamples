class Pendulum "simple pendulum"
   parameter Real l=1;
   Real theta(start=0.7);
   Real omega(start=0.0);
equation
   der(theta) = omega;
end Pendulum;

class SwungPendulum "simple pendulum coupled to driving pendulum"
   extends Pendulum;
   Real xddot, yddot;
end SwungPendulum

class DrivingPendulum "driving pendulum"
   extends Pendulum;
   parameter Real speed=0.7;
equation
   if time mod 4 < 2 then
      omega = -speed;
   else
      omega = speed;
   endif;
end DrivenPendulum
   
class DrivenPendulum "driven double pendulum"
   parameter Real g=9.81;
   SwungPendulum swung(theta(start=0.7));
   DrivingPendulum driver(theta(start=0.7));
   Real sum_theta;
equation
   swung.xddot = driver.l * driver.alpha * cos(driver.theta) - driver.omega^2 * sin(driver.theta);
   
   swung.yddot = driver.l * driver.alpha * sin(driver.theta) + driver.omega^2 * cos(driver.theta);
   
   der(swung.omega) = (swung.xddot * cos(swung.theta) + sin(swung.theta) * (swung.yddot + g));

   sum_theta = swung.theta + driver.theta;
end DrivenPendulum;