#!/usr/bin/perl -Tw
# $Id: 03class.t,v 1.3 2003/06/05 18:43:18 ian Exp $

# class.t
#
# Ensure class methods are handled correctly.

use strict;
use lib                             	qw( t          );
use Class::Declare::Attributes::Test	qw( :constants );

# define the test type
my	$type	= 'class';		# testing class methods

# class methods should behave the same in a class
# target, as in a class instance, an derived class and a derived
# object, so we can build our list of tests in a loop
my	@tests;		undef @tests;

# define the list of contexts
#   - class methods may be called from anywhere
my	@contexts	= ( CTX_CLASS    , CTX_DERIVED   , CTX_UNRELATED ,
  	        	    CTX_INSTANCE , CTX_INHERITED , CTX_FOREIGN   );

# define the list of targets
#   - class methods may only be called on base classes,
#     base class instances, derived classes and derived objects
my	@targets	= ( TGT_CLASS    , TGT_DERIVED   ,
  	        	    TGT_INSTANCE , TGT_INHERITED );

# add the method tests
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add this method test to the list of tests
		push @tests , ( $context | $target | TST_ACCESS | LIVE ,
		                $context | $target | TST_READ   | LIVE );
	}
}


# create the test object
my	$test	= Class::Declare::Attributes::Test->new( type  =>  $type  ,
  	     	                                         tests => \@tests )
					or die 'could not create test object';
# run the tests
	$test->run;
