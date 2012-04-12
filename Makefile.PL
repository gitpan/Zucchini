
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "turn templates into static websites",
  "AUTHOR" => "Chisel <chisel\@chizography.net>",
  "BUILD_REQUIRES" => {
    "Config::General" => "2.37",
    "File::Find" => 0,
    "File::Temp" => "0.18",
    "FindBin" => 0,
    "Moose" => 0,
    "Test::File::Contents" => "0.05",
    "Test::More" => "0.72",
    "Test::NoWarnings" => "0.083",
    "Test::UseAllModules" => 0,
    "Zucchini::Test" => 0,
    "Zucchini::TestConfig" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Zucchini",
  "EXE_FILES" => [
    "script/zucchini"
  ],
  "LICENSE" => "perl",
  "NAME" => "Zucchini",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Config::Any" => 0,
    "Digest::MD5" => 0,
    "Exporter" => 0,
    "File::Basename" => 0,
    "File::Copy" => 0,
    "File::Find" => 0,
    "File::Rsync" => 0,
    "File::Slurp" => 0,
    "File::Temp" => 0,
    "File::stat" => 0,
    "Getopt::Long" => 0,
    "HTML::Lint" => 0,
    "IO::File" => 0,
    "Moo" => 0,
    "MooX::Types::MooseLike::Base" => 0,
    "Net::FTP" => 0,
    "Path::Class" => 0,
    "Pod::Usage" => 0,
    "Template" => 0,
    "base" => 0,
    "strict" => 0,
    "version" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.0.18_02",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



