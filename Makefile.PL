# $Id: Makefile.PL 1515 2010-08-22 14:41:53Z ian $
#
# Makefile.PL for Class::Declare::Attributes
#
# Copyright (c) 2003-2010 Ian Brayshaw <ian@onemore.org>

use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
  'NAME'          => 'Class::Declare::Attributes',
  'VERSION_FROM'  => 'Attributes.pm',
  'PREREQ_PM'     => { 'Class::Declare'  => 0.06 ,
                       'Test::More'      => 0    ,
                       'Test::Exception' => 0.15 } , # for lives_and()
  'ABSTRACT_FROM' => 'Attributes.pm',
  'AUTHOR'        => 'Ian Brayshaw <ian@onemore.org>'
);
