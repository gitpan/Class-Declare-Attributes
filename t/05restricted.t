#!/usr/bin/perl -Tw
# $Id: 05restricted.t,v 1.4 2003/06/06 14:35:45 ian Exp $

# restricted.t
#
# Ensure restricted methods are handled correctly.

use strict;
use lib                             	qw( t          );
use Class::Declare::Attributes::Test	qw( :constants );

# define the test type
my	$type	= 'restricted';		# testing restricted methods

# restricted methods should only be accessible from within the
# defining class and instances of that class, as well as in derived
# classes and their instances, just as with protected attributes and
# methods, but not confined to class instances.
my	@tests;		undef @tests;

# first, define all the tests that will succeed: called from within the
# inheiritence tree of the defining class
my	@contexts	= ( CTX_CLASS , CTX_DERIVED , CTX_INSTANCE , CTX_INHERITED );
my	@targets	= ( TGT_CLASS , TGT_DERIVED , TGT_INSTANCE , TGT_INHERITED );

# add the method tests
#   - methods should be accessible and readable
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the method test
		push @tests , ( $context | $target | TST_ACCESS | LIVE ,
		                $context | $target | TST_READ   | LIVE );
	}
}

# all other access permutations (i.e. outside the inheritance tree of
# the defining class and their instances0 will fail
	@contexts	= ( CTX_UNRELATED , CTX_FOREIGN );
foreach my $target ( @targets ) {
	foreach my $context ( @contexts ) {
		# add the attribute test
		push @tests , ( $context | $target | TST_ALL    | DIE  );
	}
}


# create the test object
my	$test	= Class::Declare::Attributes::Test->new( type  =>  $type  ,
  	     	                                         tests => \@tests )
					or die 'could not create test object';
# run the tests
	$test->run;
