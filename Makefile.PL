# $Id: Makefile.PL,v 1.3 2003/06/06 14:37:56 ian Exp $
#
# Makefile.PL for Class::Declare::Attributes
#
# Copyright (c) 2003 Ian Brayshaw <ian@onemore.org>

use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'        	=> 'Class::Declare::Attributes',
    'VERSION_FROM'	=> 'Attributes.pm',
	# need Class::Declare v0.02 or later as this supports "restricted"
	# methods and attributes rather than "shared"
    'PREREQ_PM'   	=> { 'Class::Declare'      => 0.02 ,
	              	     'Attribute::Handlers' => 0    ,
	              	     'Test::More'          => 0    ,
	              	     'Test::Exception'     => 0    } ,
	'AUTHOR'      	=> 'Ian Brayshaw <ian@onemore.org>'
);
