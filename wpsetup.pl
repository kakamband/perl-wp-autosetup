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
#   
#   DONE
#   x create package to read and assigns .env file and it's variables
#   x test connection to api with read login data from .env file
#   
##############################################################################

use strict;
use warnings;
use PadWalker qw(peek_my peek_our peek_sub closed_over);
use Data::Dumper qw(Dumper);
use HTTP::CookieJar::LWP ();
use LWP::UserAgent ();
use HTTP::Request ();
$\ = "\n";
# Include local folder as lib
use lib "./";
# Load first own created Package: a .env FileReader
use Dotenv;

# Create object with filename of .env file
my $dotenv = Dotenv->new(".env");
# opens the file, reads the content and assigns the variables to hash
my %envvars = $dotenv->open();

# Login credentials
my $host = $envvars{HOST}; 
my $realm = $envvars{REALM};
my $uname = $envvars{USERNAME};
my $pass = $envvars{PASSWORD};

# API-URL 
my $url = $envvars{API_URL};

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