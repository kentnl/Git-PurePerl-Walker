use strict;
use warnings;

package Git::PurePerl::Walker::Role::Method;

# FILENAME: Method.pm
# CREATED: 28/05/12 16:33:59 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A method for traversing a git repository

use Moose::Role;
with 'Git::PurePerl::Walker::Role::HasRepo';
requires 'current';
requires 'has_next';
requires 'next';
requires 'peek_next';
requires 'reset';

no Moose::Role;
1;
