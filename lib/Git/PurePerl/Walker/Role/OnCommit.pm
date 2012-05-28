use strict;
use warnings;
package Git::PurePerl::Walker::Role::OnCommit;
# FILENAME: OnCommit.pm
# CREATED: 28/05/12 16:35:27 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: An event to execute when a commit is encountered

use Moose::Role;
with 'Git::PurePerl::Walker::Role::HasRepo';
requires 'reset';
requires 'handle';

no Moose::Role;
1;


