# $Id: Makefile.PL,v 1.7 2008-06-06 14:03:44 ian Exp $
#
# Makefile.PL for Class::Declare::Attributes
#
# Copyright (c) 2003-2007 Ian Brayshaw <ian@onemore.org>

use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'          => 'Class::Declare::Attributes',
  'VERSION'       => '0.05',  # we're now ahead of the module version
  'PREREQ_PM'     => { 'Class::Declare'  => 0.06 ,
                       'Test::More'      => 0    ,
                       'Test::Exception' => 0.15 } , # for lives_and()
  'ABSTRACT_FROM' => 'Attributes.pm',
  'AUTHOR'        => 'Ian Brayshaw <ian@onemore.org>'
);