use strict;
use warnings;

package Git::PurePerl::Walker::Role::Method;

# FILENAME: Method.pm
# CREATED: 28/05/12 16:33:59 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A method for traversing a git repository

use Moose::Role;

=consumerole Git::PurePerl::Walker::Role::HasRepo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>>|Git::PurePerl::Walker::Role::HasRepo >>

=cut

with 'Git::PurePerl::Walker::Role::HasRepo';

=rolerequires current

	my $commit = $object->current;

Should return a L<< C<Git::PurePerl::B<Object::Commit>>|Git::PurePerl::Object::Commmit >>

=cut

requires 'current';

=rolerequires has_next

	if ( $object->has_next ) {

	}

Should return true if C<< -E<gt>next >> will expose a previously unseen object.

=cut

requires 'has_next';

=rolerequires next

	my $next_object = $object->next;

Should internally move to the next object, and return that next object.

=cut

requires 'next';

=rolerequires peek_next

	my $next_object = $object->peek_next;

The same as L</next> except internal position should not change.

=cut

requires 'peek_next';

=rolerequires reset

	$object->reset;

Should reset the internal position to some position so that calling
C<< $object->current >> returns the first result again.

=cut

requires 'reset';

no Moose::Role;
1;
