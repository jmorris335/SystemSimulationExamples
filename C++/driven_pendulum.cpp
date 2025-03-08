/**
* Filename: pendulum.m
* Author: John Morris, jhmmrs@clemson.edu, ORCID: 0009-0005-6571-1959
* Purpose: Provides a class for dynamically simulating a pendulum.
* History:
* - v1.0, 19 Feb 2025: Initialized
*/

#include <vector>
#include <cmath>
#include <string>
#include <iostream>

#include "plotter.cpp"

using namespace std;

double PI = 3.14159;

class Pendulum {
	public:
		double theta, omega, alpha;
		double l, g, m, step;

		Pendulum(double theta0, double omega0=0.0, double l=1.0, double g=9.81, double m=1.0, double step=0.1) : theta(theta0), omega(omega0), l(l), g(g), m(m), step(step) {}

		double f_alpha() {
			alpha = -g / l * sin(theta);
			return alpha;
		}

		double f_omega() {
			omega = omega + alpha * step;
			return omega;
		}

		double f_theta() {
			theta = theta + omega * step;
			return theta;
		}
};

class SwungPendulum: public Pendulum {
	public:
		using Pendulum :: Pendulum;

		double f_alpha(double thetaA, double omegaA, double alphaA, double lA) {
			double xddot = lA * (alphaA * cos(thetaA) - omegaA * omegaA * sin(thetaA));
			double yddot = lA * (alphaA * sin(thetaA) + omegaA * omegaA * cos(thetaA));
			alpha = -1 / l * (xddot * cos(theta) + sin(theta) * (yddot + g));
			return alpha;
		}
};

class DrivingPendulum: public Pendulum {
	private:
		double speed = PI / 4;

	public:
		using Pendulum :: Pendulum;

		double f_alpha(double prev_omega) {
			alpha = (omega - prev_omega) / step;
			return alpha;
		}

		double f_omega(double t) {
			omega = (fmod(t, 4) < 2) ? -speed : speed;
			return omega;
		}
};

class DrivenPendulum {
	public:
		DrivingPendulum driver;
		SwungPendulum swung;
		double prev_omega;
		double omega;

		DrivenPendulum(double thetaA0=PI/4, double thetaB0=PI/4, double omegaA0=0.0) : driver(thetaA0), swung(thetaB0), omega(omegaA0) {}

		void driver_f_alpha() {
			driver.f_alpha(prev_omega);
		}

		void driver_f_omega(double t) {
			prev_omega = omega;
			omega = driver.f_omega(t);
		}

		void swung_f_alpha() {
			swung.f_alpha(driver.theta, driver.omega, driver.alpha, driver.l);
		}

		double sim_theta(double t) {
			driver_f_omega(t);
			driver_f_alpha();
			driver.f_theta();
			swung_f_alpha();
			swung.f_omega();
			swung.f_theta();
			return driver.theta + swung.theta;
		}
};

int main() {
	// Imperative connection
	DrivingPendulum driver(PI/4);
	SwungPendulum swung(PI/4);
	vector<double> thetaA, thetaB, omegaA, time;
	time.push_back(0.0);
	omegaA.push_back(0.0);
	double end_time = 10.0;

	while (time.back() < end_time) { 
		time.push_back(time.back() + driver.step);
		omegaA.push_back(driver.f_omega(time.back()));
		driver.f_alpha(omegaA[omegaA.size() - 2]);
		thetaA.push_back(driver.f_theta());
		swung.f_alpha(driver.theta, driver.omega, driver.alpha, driver.l);
		swung.f_omega();
		thetaB.push_back(swung.f_theta());
	}

	Plotter plotter(time, thetaB);

	return 0;
}