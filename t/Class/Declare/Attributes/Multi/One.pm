#!/usr/bin/perl -Tw

# $Id: One.pm,v 1.1 2003/06/06 09:31:25 ian Exp $
# Helper class for multiple inheritance test
#    - unlike Class::Declare, Class::Declare::Attributes doesn't support
#      on-the-fly generation of modules (Attributes::Handlers is unable to
#      return a meaningful glob for a method generated through a string
#      eval()), so we must explicitly generate modules for testing, rather
#      than have the test script generate them for us.
package Class::Declare::Attributes::Multi::One;

use strict;
use warnings;

use base qw( Class::Declare::Attributes );

# define a public method
sub a : public { 1 };

################################################################################
1;	# end of module
__END__
