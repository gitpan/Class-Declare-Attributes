#!/usr/bin/perl -Tw
# $Id: 06public.t,v 1.3 2003/06/05 18:43:18 ian Exp $

# public.t
#
# Ensure public methods are handled correctly.

use strict;
use lib                             	qw( t          );
use Class::Declare::Attributes::Test	qw( :constants );

# define the test type
my	$type	= 'public';		# testing public methods

# public methods are accessible from all defining class
# instances and derived instances, regardless of the context, and they
# are both readable and writeable
my	@tests;		undef @tests;

# define the tests that will succeed first
#   - a public method is only accessible through an object
#       instance, derived or otherwise
#   - the calling context is irrelevant for public methods
my	@contexts	= ( CTX_CLASS    , CTX_DERIVED   , CTX_UNRELATED ,
  	         	    CTX_INSTANCE , CTX_INHERITED , CTX_FOREIGN   );
my	@targets	= ( TGT_INSTANCE , TGT_INHERITED );

# add the method tests
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method test to the list of tests
		push @tests , ( $context | $target | TST_ACCESS | LIVE ,
		                $context | $target | TST_READ   | LIVE );
	}
}

# attempts to access a public method through a class rather
# than an instance should all fail
	@targets	= ( TGT_CLASS , TGT_DERIVED );

# add the method tests
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method test to the list of tests
		push @tests , ( $context | $target | TST_ALL    | DIE  );
	}
}


# create the test object
my	$test	= Class::Declare::Attributes::Test->new( type  =>  $type  ,
  	     	                                         tests => \@tests )
					or die 'could not create test object';
# run the tests
	$test->run;
