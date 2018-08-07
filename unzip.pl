#!/usr/bin/perl
# --------------------------------------------------------- #
#  SCRIPT: unzip.pl                                         #
#    DATE: 07-AUG-2018                                      #
#  AUTHOR: DAVID B. MITCHELL                                #
#                                                           #
# DESCRIPTION:                                              #
#                                                           #
# EXTRACTS THE CONTENTS OF A .ZIP ARCHIVE FILE TO THE       #
# DESIGNATED FOLDER.                                        #
#                                                           #
# USAGE:                                                    #
# perl unzip.pl [zipfile] [destination folder]              #
# --------------------------------------------------------- #
use strict;
use warnings;
use File::Basename;
use IO::Uncompress::Unzip qw(unzip $UnzipError);

my $zipfile = $ARGV[0];
my $destfolder = $ARGV[1];
my $u = new IO::Uncompress::Unzip $zipfile;

die "Zipfile has no members"
  if (!defined $u->getHeaderInfo);

my $basename = basename $zipfile;
warn "Decompressing \"$basename\" ...\n";

my $i = 0;
my $j = 0;
for (my $status = 1; $status > 0; $status = $u->nextStream, $i++) {
    my $name = $u->getHeaderInfo->{Name};
    warn "Extracting $name\n";
    if ($name =~ /\/$/) {
        mkdir "$destfolder\\$name";
    } else {
        unzip $zipfile => "$destfolder\\$name", Name => "$name"
            or die "unzip failed: $UnzipError\n";
        $j++;
    }
}
my $k = $i - $j;
warn "$j file(s) extracted.  $k file(s) not extracted.\n";