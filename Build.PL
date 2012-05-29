
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Archive::Tar" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "File::pushd" => 0,
    "FindBin" => 0,
    "Module::Build" => "0.3601",
    "Package::Stash" => 0,
    "Scalar::Util" => 0,
    "Test::More" => "0.88"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Walk over a sequence of commits in a Git::PurePerl repo",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Git-PurePerl-Walker",
  "dist_version" => "0.001002",
  "license" => "perl",
  "module_name" => "Git::PurePerl::Walker",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Class::Load" => 0,
    "Git::PurePerl" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::Clone" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::Moose" => 0,
    "Path::Class" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
