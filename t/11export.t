#!/usr/bin/perl -w
# $Id: 11export.t,v 1.1 2003/06/15 23:42:40 ian Exp $

# export.t
#
# Ensure the symbol exports from Class::Declare are honoured.

use strict;
use Test::More	tests	=> 1;

# make sure we can import the read-write and read-only modifiers
BEGIN { use_ok( 'Class::Declare::Attributes' , qw( :modifiers ) ) };
