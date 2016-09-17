#!/usr/bin/perl
use strict;
use warnings;
use Win32::ODBC;
my $stmt = "";

### Connect to ODBC data source
my $db = new Win32::ODBC("DSN=SIEBEL_DEV01;UID=SADMIN;PWD=SADMIN78") or die Win32::ODBC::Error();

### Prepare sql statement
while (<stdin>) {
  $stmt .= $_;
}
print $stmt;

### Execute sql statement
if ($db->Sql($stmt)) {
    print "SQL Error: " . $db->Error() . "\n";
    $db->Close();
    exit;
}

### Fetch row(s)
my $n = 0;
while ($db->FetchRow) {
  my %data = $db->DataHash();
  foreach my $key (keys %data) {
    print $key, '=', $data{$key}, "\n";
  }
  $n++;
}
warn "\n$n row(s) selected.\n";

### Disconnect from ODBC data source
$db->Close();
sleep(4);
