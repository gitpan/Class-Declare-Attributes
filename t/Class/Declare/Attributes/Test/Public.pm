#!/usr/bin/perl -Tw

# $Id: Public.pm,v 1.1 2003/06/05 18:19:29 ian Exp $
#
# Class::Declare::Attributes::Test helper class
package Class::Declare::Attributes::Test::Public;

use strict;
use warnings;

use base qw( Class::Declare::Attributes );

# define a public method
sub method : public
{
	my	$self	= shift;
		$self->value;
} # method()


#
# We need to test to see whether we can access the method from
# within and outside of a defining package. To facilitate this, we provide
# an accessor method
#

# create local method accessor
sub call : class
{
	# will be honoured as either a class or instance method
	my	$self	= shift;
	my	$target	= shift || $self;
		$target->method;
} # call()


# include the definition of a derived pacakge
package Class::Declare::Attributes::Test::Public::Derived;

use strict;
use warnings;

use base qw( Class::Declare::Attributes::Test::Public );

# define the method accessor
sub call : class
{
	# will be honoured as either a class or instance method
	my	$self	= shift;
	my	$target	= shift || $self;
		$target->method;
} # call()


# include the definition of an unrelated class
package Class::Declare::Attributes::Test::Public::Unrelated;

use strict;
use warnings;

use base qw( Class::Declare::Attributes );

# define a public method
sub method : public
{
	my	$self	= shift;
		$self->value;
} # method()


# define the method accessor
sub call : class
{
	# will be honoured as either a class or instance method
	my	$self	= shift;
	my	$target	= shift || $self;
		$target->method;
} # call()


################################################################################
1;	# end of module
__END__
