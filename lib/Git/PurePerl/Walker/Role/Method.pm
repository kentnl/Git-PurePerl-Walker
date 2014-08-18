use 5.008;    #utf8
use strict;
use warnings;
use utf8;

package Git::PurePerl::Walker::Role::Method;

our $VERSION = '0.004001';

# ABSTRACT: A method for traversing a git repository

# AUTHORITY

use Moose::Role qw( with requires );

=consumerole Git::PurePerl::Walker::Role::HasRepo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>>|Git::PurePerl::Walker::Role::HasRepo >>

=cut

with 'Git::PurePerl::Walker::Role::HasRepo';

=imethod for_repository

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<for_repository( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/for_repository >>

=cut

=imethod clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=cut

=imethod _repo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<_repo( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/_repo >>

=cut

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
