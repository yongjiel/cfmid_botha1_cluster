#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  call_qsub_date.pl
#
#        USAGE:  ./call_qsub_date.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  06/14/2011 11:00:25 AM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use FindBin qw($Bin);
use lib $Bin;
use CONFIG;


my $input_file = '';
if (exists $ARGV[0]){
    $input_file = $ARGV[0];
}
if ($input_file eq '' or ! -e  $input_file){
    print STDERR "Usage: perl call_wraper_qsub.pl  <csv cmf_id file>\n";
    exit(-1);
}

 
my ($count) = `wc -l  $input_file` =~ /^\s*(\d+) /;
my $jobs = "1-$count";

my $qsub_args = "-q $QUEUE -e /dev/null ".
                "-o /dev/null -sync no ";
                
print "---- STAR -----\n";
my $cm = "qsub -t $jobs -l h=\"botha-w11\" $qsub_args $BIN/wraper_docker.pl $input_file 2>&1 >/dev/null";
print $cm. "\n";
system($cm);

exit;








