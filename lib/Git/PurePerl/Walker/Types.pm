use strict;
use warnings;

package Git::PurePerl::Walker::Types;

# FILENAME: Types.pm
# CREATED: 28/05/12 19:47:20 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Misc utility types for Git::PurePerl::Walker

use MooseX::Types -declare => [
    qw(
      GPPW_Repository
      GPPW_Methodish
      GPPW_Method
      GPPW_OnCommitish
      GPPW_OnCommit
      )
];

use MooseX::Types::Moose qw( Str CodeRef );

class_type GPPW_Repository, { 'class' => 'Git::PurePerl' };
role_type GPPW_Method,   { role => 'Git::PurePerl::Walker::Role::Method' };
role_type GPPW_OnCommit, { role => 'Git::PurePerl::Walker::Role::OnCommit' };
union GPPW_Methodish, [ Str, GPPW_Method ];
union GPPW_OnCommitish, [ Str, CodeRef, GPPW_OnCommit ];

1;

