#!/usr/bin/perl -w
use Cwd;

$wd = cwd;

#print "Preparing dihedral meta file in $wd\n";

# Parameters
$name   = "dihedral_meta.dat";
$start  = 1.0;
$end    = 6.1;
$incr   = 0.1;
$force  = 400;

prepare_input();

exit(0);

sub prepare_input {
    open $meta_fh, '>', $name or die "Cannot open $name: $!";

    $dihed = $start;
    while ($dihed <= $end + 1e-6) {  # small tolerance for floating point
        printf "Processing dihedral: %.1f rad\n", $dihed;
        printf $meta_fh "distance_%.1f.dat %.1f %.5f\n", $dihed, $dihed, $force;
        $dihed += $incr;
    }

    close $meta_fh;
}
