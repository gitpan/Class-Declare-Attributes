#!/usr/bin/perl

# $Id: Attributes.pm,v 1.7 2003/06/15 23:46:16 ian Exp $
package Class::Declare::Attributes;

use 5.006;	# this is needed to ensure Attribute::Handlers will work
use strict;
use warnings;

# this is an extension of Class::Declare
use base qw( Class::Declare );
use vars qw( $VERSION $REVISION @EXPORT_OK %EXPORT_TAGS );

	$VERSION		= '0.02';
	$REVISION		= '$Revision: 1.7 $';

# need to copy the export symbols from Class::Declare
# to permit Class::Declare::Attributes to provide attribute modifiers
BEGIN {
	@EXPORT_OK		= @Class::Declare::EXPORT_OK;
	%EXPORT_TAGS	= %Class::Declare::EXPORT_TAGS;

	# make sure we copy the globs as well
	no strict 'refs';

	foreach( @EXPORT_OK ) {
		*{ __PACKAGE__ . '::' . $_ }	= *{ 'Class::Declare::' . $_ };
	}
}

# OK, we're cheating a little here, and using lower-case attribute names,
# which is a little poor form on our part (but it does make the code nicer
# to read), so we need to set $^W to zero to prevent Attribute::Handlers
# from displaying a warning message. However, Attribute::Handlers operates
# mainly during the compile phase, so we need to set $^W before
# Attribute::Handlers is called/loaded
#   - remember the state of $^W so that we can restore it once all of the
#       attribute definition code has run
#   - ideally this would be done with local(), but it can't be because local
#       is only in effect until the end of the defining block and the block
#       must be completed for the BEGIN to have effect
my	$saved_W;
BEGIN {
	$saved_W	= $^W;
	$^W			= 0;
}

# use Attribute::Handlers to create the method attributes
use Attribute::Handlers;

# Declare attribute handlers for the six types of methods supported by
# Class::Declare - class, static, restricted, public, private and protected.
#   - because this class will be the base class for other classes, calls to
#       public(), private(), et al. will end up here as part of the normal
#       access control checks of Class::Declare
#   - these invocations should be passed to Class::Declare for proper
#       processing, and should not be handled by the public(), et al. routines
#       of this class
#   - fortunately, it's trivial to tell whether an invocation of public()
#       et al. is the result of the Attribute::Handlers processing, or the
#       access checks of Class::Declare by checking the calling package
#   - if the caller is not Attribute::Handlers, then we simply pass the call
#       on to the Class::Declare methods
BEGIN {

	# $attr()
	#
	# a dummy handler for installing wrapper routines as a result of
	# attribute assignment
	my	$attr	= sub { # <name> <arguments...>
			# extract the attribute type
			my	( $type )	= ( shift =~ m/([^:]+)$/o );

			# if we haven't been called from Attribute::Handlers, then this
			# is a call for public() et al. as part of an access test, so we
			# should defer to Class::Declare
			#    - we can speed up any further requests (that arise because
			#      of object inheritance chaining from the Perl method
			#      dispatch mechanism) buy copying the
			#      Class::Declare::$type() CODEREF to the
			#      Class::Declare::Attributes::$type glob
			# we should only be called from Attribute::Handlers during the
			# compilation phase before we actually start execution, after
			# then all calls to this routine will be the result of requests
			# for the actual Class::Declare::$type() methods
			unless ( caller eq 'Attribute::Handlers' ) {
				no strict   'refs';
				no warnings 'redefine';

				# redefine this GLOB to point to the Class::Declare method
				my	$target		= 'Class::Declare::' . $type;
					*{ __PACKAGE__ . '::' . $type }	= \&{ $target };
				# defer to Class::Declare::$type()
				goto &{ $target };
			}

			# OK, we're here because someone has used a public, private, etc
			# attribute in declaring a package subroutine, so we need to
			# replace the original subroutine with a wrapper routine to
			# invoke the correct public(), private(), etc method as an
			# access check

			my	( $pkg , $glob , $ref )	= @_;
			# extract the intended method name
			my	$method					= *{ $glob }{ NAME };

			# redefine the method
			{
				no warnings 'redefine';

				*{ $glob }	= sub {
						# perform the Class::Declare-style access check
						$pkg->$type( $_[ 0 ] , $pkg . '::' . $method );

						# if the above call succeeds, then we should proceed
						# with the original method as intended
						goto &{ $ref };
					}; # *{ $glob }()
			}
		}; # $attr()

# create the attribute handling methods for class, static, restricted, public,
# private and protected methods

sub class      : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };
sub static     : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };
sub restricted : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };
sub public     : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };
sub private    : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };
sub protected  : ATTR(CODE) { unshift @_ , (caller 0)[3] and goto &{ $attr } };


} # end of BEGIN

# reset the value of $^W
INIT { $^W	= $saved_W; }

1;
__END__
=pod

=head1 NAME

Class::Declare::Attributes - Class::Declare method types using Perl attributes.


=head1 SYNOPSIS

  package My::Class;

  use 5.006;
  use strict;
  use warnings;

  use base qw( Class::Declare::Attributes );

  # declare the class/instance attributes
  __PACKAGE__->declare( ... );

  #
  # declare class/static/restricted/etc methods of this package
  #

  sub my_class      : class      { ... }
  sub my_static     : static     { ... }
  sub my_restricted : restricted { ... }
  sub my_public     : public     { ... }
  sub my_private    : private    { ... }
  sub my_protected  : protected  { ... }


=head1 DESCRIPTION

B<Class::Declare::Attributes> extends L<Class::Declare> by adding support
for Perl attributes for specifying class method types. This extension was
inspired by Damian Conway's L<Attribute::Handlers> module, and Tatsuhiko
Miyagawa's L<Attribute::Protected> module.

The addition of Perl attribute support (not to be confused with
object attributes, which are entirely different, and also supported
by B<Class::Declare>) greatly simplifies the specification of
B<Class::Declare>-derived class and instance methods. This should aid in
the porting of existing code (Perl, Java and C++) to a Class::Declare
framework, as well as simplify the development of new modules.

With the addition of Perl attributes, B<Class::Declare> methods can now be
written as

  sub method : public
  {
    my $self = shift;
    ...
  }

instead of

  sub method
  {
    my $self = __PACKAGE__->public( shift );
    ...
  }


=head2 Attributes

B<Class::Declare::Attributes> defines six method or subroutine attributes
that correspond to the six method and object- and class-attribute types
of B<Class::Declare>:

=over 4

=item B<:class>

B<class> methods are accessible from anywhere, and may be called through
the class, a derived class, or any instance derived from the defining class.
This is the class equivalent of B<public> methods.

=item B<:static>

B<static> methods may only be accessed within the defining class and instances
of that class. This is the class equivalent of B<private> methods.

=item B<:restricted>

B<restricted> methods may only be accessed from within the defining class and
all classes and objects that inherit from it. This is the class equivalent
of B<protected> methods.

=item B<:public>

B<public> methods are accessible from anywhere, but only through object
instances derived from the defining class.

=item B<:private>

B<private> methods are only accessible from within the defining class and
instances of that class, and only through instances of the defining class.

=item B<:protected>

B<protected> methods are only accessible from within the defining class
and all classes and objects derived from the defining class. As an instance
method it may only be accessed via an object instance.

=back

The attributes defined by B<Class::Declare::Attributes> are not
to be confused with the object and class attributes defined by
B<Class::Declare::declare()>. The clash in terminology is unfortunate,
but as long as you remember the context of your attributes, i.e. are they
Perl-attributes, or class-/object-attributes, the distinction should be clear.


=head2 Attribute Modifiers

B<Class::Declare::Attributes> supports the use of the class and instance
attribute modifiers defined by B<Class::Declare>. These modifiers may be
imported into the current namespace by either explicitly listing the modifier
(B<rw> and B<ro>) or using one of the predefined tags: C<:read-write>,
C<:read-only> and C<:modifiers>. For example:

  use Class::Declare::Attributes qw( :read-only );

B<Note:> The "magic" of B<Class::Declare::Attributes> that defines the method
attributes is performed during the compilation of the module it is C<use>d
in. To access the attribute modifiers, the C<use base> approach should be
replaced with the more traditional:

  use Class::Declare::Attributes qw( :modifiers );
  use vars qw( @ISA );
  @ISA = qw( Class::Declare::Attributes );

However, because B<Class::Declare::Attributes> (or more precisely
L<Attribute::Handlers>) operates before the execution phase, the assignment to
C<@ISA> will occur too late to take effect (resulting in an invalid attribute
error). To prevent this error, and to bring the assignment to C<@ISA> forward
in the module compilation/execution phase, the assignment should be wrapped
in a C<BEGIN {}> block.

  BEGIN { @ISA = qw( Class::Declare::Attributes ); }

For more information on class and instance attribute modifiers, please refer
to L<Class::Declare>.

=head1 CAVEATS

B<Class::Declare::Attributes> is distributed as a separate module to
B<Class::Declare> as it requires Perl versions 5.6.0 and greater, while
B<Class::Declare> supports all object-aware versions of Perl (i.e. version
5.0 and above). This is a necessary requirement of L<Attribute::Handlers>.

The interface B<Class::Declare::Attributes> provides is not ideal. In fact,
some might suggest that it's 'illegal'. In some ways, yes, it is illegal,
because it has hijacked some lowercase attribute names that Perl has marked
down for possible future use. However, as of Perl 5.8.0, these attributes
are not in use (C<:shared> is, which is why B<Class::Declare> changed this
class of attributes and methods to C<restricted>), and so we may as well
take advantage of them.

This is an example of what can be done with Perl (especially if you're
willing to bend the rules), and who knows, maybe it's a glimpse of the sort
of capabilities we'll see in Perl 6.


=head1 SEE ALSO

L<Class::Declare>, L<Attribute::Handlers>, L<Attribute::Protected>.


=head1 AUTHOR

Ian Brayshaw, E<lt>ian@onemore.orgE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Ian Brayshaw. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 


=cut
