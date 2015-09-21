# @file orbitmodel.pl
# @author Raymond Byczko
# @class Planetary Physics 530
# @start_date 2015-09-18
# @bibliography [1] Fundamental Planetary Science - Physics, Chemistry and
# Habitability by Jack J. Lissauer, Imke de Pater.
# @note The return value of subroutines is the last value computed before
# subroutine exit.  Its not needed, but I have added return specifically.
# @note The notation '**' refers to exponentiation.  e.g. 2**3 = 8.

use strict;
use Math::Trig;

# Constants
my $G = 6.6726E-11; # Gravitional constant (m**3 kg**-1 s**-2)
my $M = 1.989E30;   # Mass of Sun (kg)
my $GM = 1.327E20; # m**3 s**-2
my $METERS_PER_AU = 1.496E11; # m**1 AU**-1
my $METERS_PER_KM = 1000;

# get_wn: calculates angular velocity in degrees/day given
# the two following parameters:
# 		Vn: velocity in km/sec
# 		rn: distance in AU.
# output:
#		wn: degrees per day.

sub get_wn {
	my($Vn, $rn) = @_;
	my $secsPerDay = 86400;
	my $kmPerAU = 1.496E8;
	my $degreesPerRadian = 360.0/(2*pi);
	my $wn;
	$wn = ($Vn*$degreesPerRadian*$secsPerDay)/($rn*$kmPerAU);
	return $wn;
}

# get_r: calculates r, the distance from one focus of the eclipse
# where it is assumed the sun is located to the orbiting object.
# r is known as the heliocentric distance [1, p. 26].
# This sub takes the following parameters:
# 		a: semi-major axis length in AU.
#		e: the eccentricity of the orbit
#		theta: the angle formed between the object in orbit, the
#		focus of the ellipse, and the periapse.
# output:
# 		r: distance r in AU.
sub get_r {
	my($a, $e, $theta) = @_;
	my $thetaRadians = deg2rad($theta);
	my $r = $a*(1.0-$e**2)/(1.0+$e*cos($thetaRadians));
	return $r;
}

# get_v: uses the energy equation to figure out the velocity of an
# object at distance r from the sun.
# parameters:
# 		a: semi-major axis in AU
#		r: distance from the sun in AU
# output:
#		velocity (m/s)
sub get_v {
	my($a, $r) = @_;
	my $vel_squared;
	my $v;
	$vel_squared = $GM*((2.0/$r)-(1.0)/$a)/$METERS_PER_AU;
	$v = sqrt($vel_squared);
	return $v;
}

# compute_timeincrement: computes a delta time for each iteration of
# computing a velocity.
# parameters:
# 		orbitalPeriod: total amount of time it takes to orbit a star.
# 			(generally in days, with a return value in days).  Other
# 			time units can be used, with corresponding unit for output.
#		numberTimeSteps: total number of time steps.  Must be greater
#			than zero. (@todo - put in check and raise exception).
sub compute_timeincrement {
	my($orbitalPeriod, $numberTimeSteps) = @_;
	my $timeIncrement;
	$timeIncrement = $orbitalPeriod/$numberTimeSteps;
	return $timeIncrement;
}

# compute_vr_product: a trivial subroutine taht computes the
# product of the velocity and r.
# parameters:
#		v: velocity
#		r: radius
sub compute_vr_product {
	my($v,$r) = @_;
	my $vr_product;
	$vr_product = $v*$r;
	return $vr_product;
}

# mercury_22: specialized subroutine setting parameters appropriately
# for Mercury, computing its orbital characteristics iteratively with
# 22 time increments.  This subroutine utilizes the above general routines
# in a very specific way.
sub mercury_22 {
	### Specific to Mercury and how model is computed.
	my $theta_start = 180; #degrees
	my $theta_n = $theta_start;
	my $e = 0.2056; # eccentricity for Mercury.
	my $a = 0.3871; # semi-major axis length for Mercury, in AU.
	my $orbitalPeriod=87.97; # orbital period of Mercury, in days.
	my $numberTimeIncrements = 22;

	### General variables.
	my $vn;
	my $rn;
	my $vr; # product of vn and rn.
	my $wn;
	my $elapsedTime_n = 0.0;
	my $timeIncrement = compute_timeincrement($orbitalPeriod, $numberTimeIncrements);
	print "Step", "\t", "ElapTime", "\t\t", "Theta", "\t\t", "r", "\t\t", "w", "\t\t", "v", "\n";
	for (my $n=0; $n<($numberTimeIncrements+1); $n++) {
		$rn = get_r($a, $e, $theta_n); # rn is in AU.
		$vn = get_v($a, $rn); # vn is in m/s.
		$wn = get_wn($vn/$METERS_PER_KM, $rn); # wn is in degrees per day.		
		$vr = compute_vr_product($vn/$METERS_PER_KM, $rn);
		#print $n, "\t", $elapsedTime_n, $theta_n, $rn, $vn, $wn, "\n";

		#print $n , "\t", $elapsedTime_n, "\t\t", $theta_n, "\t\t", $rn, "\t\t", $wn, "\t\t", $vn, "\n";

		print $n , "\n", "ET=", $elapsedTime_n, "\n", "THETA=",$theta_n, "\n", "THETA(mod360)=", $theta_n%360, "\n", "R=", $rn, "\n", "W=",$wn, "\n", "V=", $vn, "\n", "VR=", $vr, "\n";

		$theta_n = $theta_n + $wn*$timeIncrement;
		$elapsedTime_n = $elapsedTime_n + $timeIncrement;
	}
}

mercury_22();
