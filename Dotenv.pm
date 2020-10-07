#!/usr/bin/env perl

##############################################################################
# PACKAGE Dotenv-Reader
# open & read the .env file. Associats and returns the enviromental variables
##############################################################################

package Dotenv;

use strict;
use warnings;
use Data::Dumper qw(Dumper);

# Constructor: Init Dotenv with filename
sub new {
	my $class = shift;
	my $self = bless { 
		filename => shift
	   }, $class;
}

# Opens a given File, also sets or overwrites the variable
# then returns read env variables as hash
sub open {
	# Set new filename when given
	my ($self, $new_filename) = @_;
	$self->{filename} = $new_filename if defined($new_filename);
	
	# Opens given filename or filename given by constructor
	# and assigns content to variable, prints success or dies.
	open(FILE, '<', $self->{filename}) or die $!;
    print("File $self->{filename} opened successfully!\n");
   
    # Set Input Record Seperator to undef to slurp the complete file content!
    local $/ = undef;
    my $content = <FILE>;
    close(FILE);
    print("File $self->{filename} closed and read data successfully!\n");
   
    # Splitting env variable names and values and copy to hash 
    # Just the little regex and perl does the rest
    return my %envvars = split(/[=\n]/, $content); 
}

1;