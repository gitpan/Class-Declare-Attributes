#!/usr/bin/perl -Tw
# $Id: 10strict.t,v 1.4 2003/06/06 14:35:45 ian Exp $

# strict.t
#
# Ensure turning strict off permits calling of prohibited methods
# (e.g. private, protected, static, etc)

use strict;
use lib                             	qw( t          );
use Class::Declare::Attributes::Test	qw( :constants );

#
# define all the tests permutations that are expected to live
#

# all tests should behave the same regardless of context
my	@contexts	= ( CTX_CLASS    , CTX_DERIVED   , CTX_UNRELATED ,
  	         	    CTX_INSTANCE , CTX_INHERITED , CTX_FOREIGN   );

# class methods are accessible and readable, but not writeable
my	@class		= ( TGT_CLASS    , TGT_DERIVED   );
# instance methods are accessible, readable and writeable
my	@instance	= ( TGT_INSTANCE , TGT_INHERITED );

# add the class tests
#   i.e. for class, static and restricted methods
my	@ctests;	undef @ctests;
foreach my $context ( @contexts ) {
	# the method behaviours are the same for classes as for instances
	foreach my $target ( @class , @instance ) {
		# class methods are accessbile and readable
		# NB: Class::Declare::Test will only test methods for
		#     accessibility and to determine if the values are
		#     readable. All other tests are meaningless for methods.
		push @ctests , ( $context | $target | TST_ALL    | LIVE );
	}
}

# add the instance tests
#   i.e. for public, private and protected methods
my	@itests;	undef @itests;
foreach my $context ( @contexts ) {
	# access is permitted for instances
	foreach my $target ( @instance ) {
		# instance methods are accessbile and readable
		# NB: Class::Declare::Test will only test methods for
		#     accessibility and to determine if the values are
		#     readable. All other tests are meaningless for methods.
		push @itests , ( $context | $target | TST_ALL    | LIVE );
	}

	foreach my $target ( @class ) {
		push @itests , ( $context | $target | TST_ALL    | LIVE );
	}
}


# run the class method tests
foreach my $type ( qw( class static restricted ) ) {
	# create the test object
	my	$test	= Class::Declare::Attributes::Test->new( type   =>  $type   ,
	  	     	                                         tests  => \@ctests ,
	  	     	                                         strict => 0        );
	# run the tests
		$test->run;
}

# run the instance method tests
foreach my $type ( qw( public private protected ) ) {
	# create the test object
	my	$test	= Class::Declare::Attributes::Test->new( type   =>  $type   ,
	  	     	                                         tests  => \@itests ,
	  	     	                                         strict => 0        );
	# run the tests
		$test->run;
}
