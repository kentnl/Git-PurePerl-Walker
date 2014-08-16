use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Git::PurePerl::Walker::Types;

our $VERSION = '0.003002';

# ABSTRACT: Misc utility types for Git::PurePerl::Walker

# AUTHORITY

use MooseX::Types -declare => [
  qw(
    GPPW_Repository
    GPPW_Methodish
    GPPW_Method
    GPPW_OnCommitish
    GPPW_OnCommit
    ),
];

use MooseX::Types::Moose qw( Str CodeRef );

## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
class_type GPPW_Repository, { 'class' => 'Git::PurePerl' };
role_type GPPW_Method,      { role    => 'Git::PurePerl::Walker::Role::Method' };
role_type GPPW_OnCommit,    { role    => 'Git::PurePerl::Walker::Role::OnCommit' };
union GPPW_Methodish, [ Str, GPPW_Method ];
union GPPW_OnCommitish, [ Str, CodeRef, GPPW_OnCommit ];
## use critic

1;
