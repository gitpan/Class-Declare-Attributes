# $Id: Makefile.PL,v 1.4 2003/06/15 23:44:25 ian Exp $
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
    'PREREQ_PM'   	=> { 'Class::Declare'      => 0.03 ,
	              	     'Attribute::Handlers' => 0    ,
	              	     'Test::More'          => 0    ,
	              	     'Test::Exception'     => 0    } ,
	'AUTHOR'      	=> 'Ian Brayshaw <ian@onemore.org>'
);
