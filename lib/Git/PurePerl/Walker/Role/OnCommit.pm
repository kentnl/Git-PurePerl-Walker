use 5.006;    # our
use strict;
use warnings;

package Git::PurePerl::Walker::Role::OnCommit;

our $VERSION = '0.004001';

# ABSTRACT: An event to execute when a commit is encountered

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

=rolerequires handle


This is the primary event that is triggered when every commit is processed.

C<handle> is passed a L<<
C<Git::PurePerl::B<Object::Commit>>|Git::PurePerl::Object::Commmit >> for you to
do something with.

	$object->handle( $commit )


=cut

requires 'handle';

=rolerequires reset

This method is signaled when the associated repository is resetting its iteration.

You can either no-op this, or make it do something useful.

=cut

requires 'reset';
no Moose::Role;
1;
