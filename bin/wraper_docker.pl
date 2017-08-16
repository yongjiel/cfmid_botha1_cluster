#/usr/bin/perl -w

#$ -S /usr/bin/perl
#$ -cwd
#$ -r yes
#$ -j no
#$ -pe smp 1 

use strict;
use warnings;
#use FindBin qw($Bin);
#use lib $Bin;
# looks like FindBin not work when submit this script to child nodes.
use lib "/home/prion/cfm_id/bin/";
use CONFIG;


my $id = $ENV{SGE_TASK_ID}; # Batch-scheduler assigns this.
my $input_file = $ARGV[0];

my $line = read_line($input_file, $id);
my ($case, $compound) = $line =~m/^(.*?)\t(.*)/g;

my $o_filename = "$case.out";
my $fail_filename = "$case.fail";
my $log_filename = "$case.log";
foreach my $dir ("positive", "negative", "ei"){
  my $t1=time();
  my $param_file = '';
	my $config_file ='';
	if ($dir eq 'positive'){
    $param_file = "param_output0.log";
    $config_file = "param_config.txt";
	}
	elsif($dir eq 'negative'){
    $param_file = "negative_param_output0.log";
    $config_file = "negative_param_config.txt";
	}
	elsif($dir eq 'ei'){
    $param_file = "ei_param_output.log";
		$config_file = "ei_param_config.txt";
	}
  my $cm = "docker run -v $OUTPUT_DIR:/root -i  cfmid:latest sh -c \"cd /root/; cfm-predict \\\"$compound\\\" 0.001 /root/$param_file /root/$config_file 1 /root/$dir/$o_filename; chmod 777 /root/$dir/$o_filename\" "; 
	my $r = `$cm 2>&1`;
  if (! -s "$OUTPUT_DIR/$dir/$o_filename"){
    my $fail_file = "$OUTPUT_DIR/$dir/$fail_filename";
    open(FA, ">$fail_file") or die "Cannot write $fail_file";
    print FA $cm."\n";
		print FA $r;
	  close FA
	}
	
  #my $log_file = "$OUTPUT_DIR/$dir/$log_filename";
  #open(LOG, ">$log_file") or die "Cannot write $log_file";
  #print LOG (time()-$t1)." seconds done\n";
  #close LOG;
}
exit;

sub read_line{
    my $input_file = shift;
    my $line_number = shift;
    open(IN, $input_file) or die "Cannot open $input_file";
    my $count = 0;
    my $target_line = '';
    while(my $line = <IN>){
        $count++;
        if ($count == $line_number){
            $target_line = $line;
            last;
        }
    }
    close IN;
    return $target_line;
}

