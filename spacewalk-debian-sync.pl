#!/usr/bin/perl

# Debian Repository Sync
#
# Downloads Debian packages from mirror and pushes them into Spacewalk
# using rhnpush. This is a workaround until spacewalk-repo-sync natively
# supports Debian repositories
#
# Author:  Steve Meier
# Version: 20130204
#
# Changelog:
# 20130204 - Initial release
# 20130215 - Fix for downloading security repository
# 20130216 - Fix for downloading from snapshot.debian.org
#
# Here are some sample URLs:
#
# squeeze (Debian 6) Base for i386
# -> http://ftp.debian.org/debian/dists/squeeze/main/binary-i386/
#
# squeeze (Debian 6) Updates for i386
# -> http://ftp.debian.org/debian/dists/squeeze-updates/main/binary-i386/
#
# squeeze (Debian 6) Security for i386
# -> http://security.debian.org/dists/squeeze/updates/main/binary-i386/
#
# Replace for i386 with amd64 for 64-bit (x86_64 in CentOS/RHEL)
# Besides main/ there are also contrib/ and non-free/ which you might
# want to add as sub-channels to main/

use strict;
use warnings;
use Compress::Zlib;
use File::Basename;
use Frontier::Client;
use Getopt::Long;
use WWW::Mechanize;

# No buffering
$| = 1;

my $debug = 0;
my ($getopt, $url, $channel, $username, $password, $debianroot);
my $mech;
my ($packages, $package);
my ($pkgname, $fileurl, $pack, $arch, $ver);
my ($rpack, $rarch, $rver);
my ($client, $session, $allpkg);
my (%inrepo, %inchannel);
my ($synced, $tosync);
my %download;

$getopt = GetOptions( 'url=s'  		=> \$url,
                      'channel=s'	=> \$channel,
		      'username=s'	=> \$username,
		      'password=s'	=> \$password
		    );

# Ubuntu mirrors store data under /ubuntu/
if ($url =~ /(.*ubuntu\/)/) {
  $debianroot = $1;
  &info("Repo URL: $url\n");
  &info("Ubuntu root is $debianroot\n");
}

# Debian mirrors store data under /debian/
if ($url =~ /(.*debian\/)/) {
  $debianroot = $1;
  &info("Repo URL: $url\n");
  &info("Debian root is $debianroot\n");
} 

# security.debian.org has no /debian/ directory
if ($url =~ /security\.debian\.org\//) {
  $debianroot = "http://security.debian.org/";
  &info("Repo URL: $url\n");  
  &info("Debian root is $debianroot\n");
}

# snapshot.debian.org handling
if ($url =~ /(.*\d{8}T\d{6}Z\/)/) {
  $debianroot = $1;
  &info("Repo URL: $url\n");
  &info("Debian root is $debianroot\n");
}

# Abort if we don't know the root
if (not(defined($debianroot))) {
  &error("ERROR: Could not find Debian root directory\n");
  exit(1);
}

# Connect to API
$client = new Frontier::Client(url => "http://localhost/rpc/api") ||
  die "ERROR: Could not connect to API";

# Authenticate to API
$session = $client->call('auth.login', "$username", "$password");
if ($session =~ /^\w+$/) {
  &debug("API Authentication successful\n");
} else {
  &error("API Authentication FAILED!\n");
  exit 3;
}

# Index channel on server
$allpkg = $client->call('channel.software.list_all_packages', $session, $channel);
foreach my $pkg (@$allpkg) {
  &debug("Found $pkg->{'name'} with checksum $pkg->{'checksum'}\n");
  $rarch = $pkg->{'arch_label'};
  $rarch =~ s/-deb//g;
  my @rversionarr = split('-',$pkg->{'version'});
  if ($pkg->{'release'} ne 'X') {
    push @rversionarr, $pkg->{'release'};
  }
  if (@rversionarr > 1) {
    $rver = "$rversionarr[0]-$rversionarr[1]";
  } else {
    $rver = $rversionarr[0];
  }
  #$rpack = "$pkg->{'name'}|$rarch|$rver-$pkg->{'release'}";
  if (length $pkg->{'epoch'}) {
    $rpack = "$pkg->{'name'}|$rarch|$pkg->{'epoch'}:$rver";
  } else {
    $rpack = "$pkg->{'name'}|$rarch|$rver";
  }
  #&info("$rpack\n");
  $inchannel{$rpack} = 1;
}

# Logout from API
$client->call('auth.logout', $session);

# Download Packages.gz (why does this fail on some mirrors? HTTP deflate maybe?)
$mech = WWW::Mechanize->new;
print "INFO: Fetching Packages.gz... ";
$mech->get("$url/Packages.gz");
print "done\n";

if (not($mech->success)) {
  print "ERROR: Could not retrieve Packages.gz\n";
  exit(1);
}

# Uncompress Packages.gz in memory
$packages = Compress::Zlib::memGunzip($mech->content())
  or die "ERROR: Failed to uncompress Packages.gz\n";

# Parse uncompressed Packages.gz
$tosync = 0;
$synced = 0;
foreach $package (split(/\n\n/, $packages)) {
  foreach $_ (split(/\n/, $package)) {
    if (/^Filename: (.*)$/) { $fileurl = $1; };
    if (/^Package: (.*)$/) { $pack = $1; };
    if (/^Version: (.*)$/)   { $ver = $1; };
    if (/^Architecture: (.*)$/) { $arch = $1; };
  }
  $inrepo{basename($fileurl)} = $fileurl;
  &debug("Package ".basename($fileurl)." at $fileurl\n");
  
  my @tver = split('-',$ver);
  
  my $spack = "$pack|$arch|".$tver[0];
  if (@tver > 1) {
    $spack = "$pack|$arch|".$tver[0]."-".$tver[1];
  }
  #&info("$spack\n");
  if ( (not(defined($inchannel{$spack}))) ) {
    $download{basename($fileurl)} = $fileurl;
    $tosync++;
    &debug(basename($fileurl)." needs to be synced\n");
  } else {
    $synced++;
  }
}
&info("Packages in repo:\t\t".scalar(keys %inrepo)."\n");
&info("Packages already synced:\t$synced\n");
&info("Packages to sync:\t\t$tosync\n");

# Download missing packages
$synced = 0;
foreach $_ (keys %download) {
  $synced++;
  &info("$synced/$tosync : $_\n");
 
  $mech->get("$debianroot/$download{$_}", ':content_file' => "/tmp/$_");
  if ($mech->success) {
    system("bash strip.sh /tmp/$_ $channel $username $password &");
    # Wait 500ms to prevent overloading Postgres with many rhnpush requests
    # This is faster than waiting for each rhnpush to complete
    select(undef, undef, undef, 0.5);
  }
}

&info("Sync complete.\n");
exit;

# SUBS
sub debug() {
  if ($debug) { print "DEBUG: @_"; }
}

sub info() {
  print "INFO: @_";
}

sub warning() {
  print "WARNING: @_";
}

sub error() {
  print "ERROR: @_";
}

sub notice() {
  print "NOTICE: @_";
}
