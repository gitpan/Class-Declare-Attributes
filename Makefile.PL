# $Id: Makefile.PL,v 1.5 2003/06/16 11:47:32 ian Exp $
#
# Makefile.PL for Class::Declare::Attributes
#
# Copyright (c) 2003 Ian Brayshaw <ian@onemore.org>

use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'        	=> 'Class::Declare::Attributes',
    'VERSION'     	=> '0.03',	# we're now ahead of the module version
	# need Class::Declare v0.03 or later as this supports "restricted"
	# methods and attributes rather than "shared", as well as attribute
	# modifiers
    'PREREQ_PM'   	=> { 'Class::Declare'      => 0.03 ,
	              	     'Attribute::Handlers' => 0    ,
	              	     'Test::More'          => 0    ,
	              	     'Test::Exception'     => 0.15 } , # for lives_and()
	'ABSTRACT_FROM' => 'Attributes.pm',
	'AUTHOR'      	=> 'Ian Brayshaw <ian@onemore.org>'
);
