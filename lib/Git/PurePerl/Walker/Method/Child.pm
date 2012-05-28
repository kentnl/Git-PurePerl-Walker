use strict;
use warnings;
package Git::PurePerl::Walker::Method::Child;
# FILENAME: Child.pm
# CREATED: 28/05/12 16:37:28 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Walk down a tree following children.

use Moose;
with qw( Git::PurePerl::Walker::Role::Method );


no Moose;
__PACKAGE__->meta->make_immutable;
1;


