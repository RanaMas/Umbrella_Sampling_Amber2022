#!/usr/bin/perl -w
use Cwd;
$wd = cwd;

print "Preparing meta file\n";

$name = "meta.dat";
$start = 6.0;
$end = 30.0;
$incr = 0.5;
$force = 400.0;

&prepare_input();

exit(0);

sub prepare_input {
    my $dist = $start;
    open METAFILE, '>', "$name";
    while ($dist <= $end) {
        printf "Processing distance: %.1f Å\n", $dist;
        printf METAFILE "distance_%.1f.dat %.1f %.5f\n", $dist, $dist, $force;
        $dist += $incr;
    }
    close METAFILE;
}

