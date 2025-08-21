#!/usr/bin/perl -w
use Cwd;
$wd = cwd;

#print "Preparing input files //\n";

$name = "ligand_unbind";
$start = 6.0;
$end = 30.0;
$incr = 0.5;
$force = 400.0;

&prepare_input();

exit(0);

sub prepare_input {
    $dist = $start;
    while ($dist <= $end) {
        printf "Processing distance: %.1f Å\n", $dist;
        &write_mdin0($dist);
        &write_mdin1($dist);
        &write_mdin2($dist);
        &write_disang($dist);
        $dist += $incr;
    }
}

sub write_mdin0 {
    my $d = shift;
    open MDINFILE, '>', "mdin_min.$d";
    print MDINFILE <<EOF;
Minimization for $d Å
&cntrl
  imin = 1,
  maxcyc=5000, ncyc = 500,
  ntpr = 100, ntwr = 1000,
  ntf = 1, ntc = 1, cut = 10.0,
  ntb = 1, ntp = 0,
  nmropt = 1,
&end
&wt
  type='END',
&end
DISANG=disang.$d
EOF
    close MDINFILE;
}

sub write_mdin1 {
    my $d = shift;
    open MDINFILE, '>', "mdin_equi.$d";
    print MDINFILE <<EOF;
Equilibration for $d Å
&cntrl
  imin = 0, ntx = 1, irest = 0,
  ntpr = 5000, ntwr = 50000, ntwx = 0,
  ntf = 2, ntc = 2, cut = 10.0,
  ntb = 1, nstlim = 50000, dt = 0.001,
  tempi=300.0, temp0=300.0, ntt=3,
  gamma_ln=1.0,
  ntp = 0, pres0=1.0, taup=5.0,
  nmropt=1, ioutfm=1,
&end
&wt
  type='END',
&end
DISANG=disang.$d
EOF
    close MDINFILE;
}

sub write_mdin2 {
    my $d = shift;
    open MDINFILE, '>', "mdin_prod.$d";
    print MDINFILE <<EOF;
Production for $d Å
&cntrl
  imin=0, ntx=5, irest=1,
  ntpr=10000, ntwr=0, ntwx=10000,
  ntf=2, ntc=2, cut=10.0,
  nstlim=200000, dt=0.001,
  temp0=300.0, ntt=3,
  gamma_ln=1.0, barostat=2,
  ntp=1, pres0=1.0, taup=5.0,
  nmropt=1, ioutfm=1,
&end
&wt
  type='DUMPFREQ', istep1=50,
&end
&wt
  type='END',
&end
DISANG=disang.$d
DUMPAVE=distance_${d}.dat
EOF
    close MDINFILE;
}

sub write_disang {
    my $d = shift;
    my $r2 = sprintf "%.1f", $d;
    open DISANG, '>', "disang.$d";
    print DISANG <<EOF;
Distance restraint for $r2 Å
&rst
  iat=3560,22,
  r1=0.0, r2=$r2, r3=$r2, r4=50.0,
  rk2=$force, rk3=$force,
&end
EOF
    close DISANG;
}

