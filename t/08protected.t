#!/usr/bin/perl -Tw
# $Id: 08protected.t,v 1.3 2003/06/05 18:43:18 ian Exp $

# protected.t
#
# Ensure protected methods behave appropriately.

use strict;
use lib                             	qw( t          );
use Class::Declare::Attributes::Test	qw( :constants );

# define the test type
my	$type	= 'protected';	# testing protected methods

# protected methods should only be accessible from
# within the defining class and inherited classes, as well as instances
# of that class heirarchy
my	@tests;		undef @tests;

# NB: these are instance methods

# first, define all the tests that will succeed: called from within
# the defining class and derived classes, and their instances
my	@contexts	= ( CTX_CLASS , CTX_INSTANCE , CTX_DERIVED , CTX_INHERITED );
my	@targets	= (             TGT_INSTANCE ,               TGT_INHERITED );

# add the method tests
#   - methods should be accessible and readable
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method tests
		push @tests , ( $context | $target | TST_ACCESS | LIVE ,
		                $context | $target | TST_READ   | LIVE );
	}
}



# all other access permutations should die
#   - access is forbidden in a unrelated or foreign object/class
	@contexts	= ( CTX_UNRELATED , CTX_FOREIGN );
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method tests
		push @tests , ( $context | $target | TST_ALL    | DIE  );
	}
}

#   - protected methods can only be accessed through class
#       instances, and not through the classes themselves
	@contexts	= ( CTX_CLASS    , CTX_DERIVED   , CTX_UNRELATED ,
	         	    CTX_INSTANCE , CTX_INHERITED , CTX_FOREIGN   );
	@targets	= ( TGT_CLASS    , TGT_DERIVED   );
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method tests
		push @tests , ( $context | $target | TST_ALL    | DIE  );
	}
}


# create the test object
my	$test	= Class::Declare::Attributes::Test->new( type  =>  $type  ,
  	     	                                         tests => \@tests )
					or die 'could not create test object';
# run the tests
	$test->run;
