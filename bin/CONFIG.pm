#!/usr/bin/perl -w
package CONFIG;
use strict;
use warnings;

use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw($BIN $ROOT $TMP_DIR  $SSH_KEY $QUEUE $OUTPUT_DIR) ;

use FindBin qw($Bin);
use lib $Bin;

our $HOME = "/home/prion";
our $SSH_KEY = "$HOME/.ssh/scp-key";
our $ROOT = "$HOME/cfm_id";
our $BIN = "$ROOT/bin";
our $TMP_DIR = "$ROOT/tmp";
our $OUTPUT_DIR = "$ROOT/cfmid/output";
our $QUEUE = "two.q";
1;
