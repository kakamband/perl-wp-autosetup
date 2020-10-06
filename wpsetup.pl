#!/usr/bin/env perl

##############################################################################
#   Script for automatic wordpress installation
#   on my shared hosting enviroment
#
#   Planned features: 
#   - database creation throught given api
#   - folder creation based von given project name as argument
#   - creation of subdomain and pointing into previously created folder
#   - download and installtion of wordpress with WP CLI
#   - setup the usual suspected wp-users
#   - install the commonly used wp-plugins
##############################################################################

use strict;
use warnings;
use PadWalker qw(peek_my peek_our peek_sub closed_over);
use Data::Dumper qw(Dumper);
use HTTP::CookieJar::LWP ();
use LWP::UserAgent ();
use HTTP::Request ();

$\ = "\n";

##############################################################################
# Open and read the .env file and associcate
# the enviromental variables with scalars
# - should be a package in the end
##############################################################################

my $filename = "./.env";

open(FH, '<', $filename) or die $!;
print("File $filename opened successfully!\n");

while(<FH>) {
	print $_;
}

close(FH);

# Login credentials
my $host = $ENV{'HOST'}; 
my $realm = $ENV{'REALM'};
my $uname = $ENV{'USERNAME'};
my $pass = $ENV{'PASSSWORD'};

# API-URL 
my $url = $ENV{'API_URL'};

##############################################################################
##############################################################################


my $add_database = "/database/add_database.html";
my $get_database = "/database/get_databases.html";

# User Agent creation
my $jar = HTTP::CookieJar::LWP->new;
my $ua  = LWP::UserAgent->new(
    cookie_jar        => $jar,
    protocols_allowed => ['http', 'https'],
    timeout           => 10,
);

# Authentication
$ua->credentials( $host, $realm, $uname, $pass );

# GET Response Test: List Datenbanken
my $response = $ua->get($url . $get_database);

# Print decoded response or print the error
if ($response->is_success) {
    print $response->decoded_content;
}
else {
    print STDERR $response->status_line, "\n";
}