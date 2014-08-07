use strict;
use warnings;

package Git::PurePerl::Walker::Method::FirstParent::FromHEAD;

our $VERSION = '0.003000';

# FILENAME: FromHEAD.pm
# CREATED: 30/05/12 13:57:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Start at the HEAD of the current repo.

use Moose;

=extends  Git::PurePerl::Walker::Method::FirstParent

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>>|Git::PurePerl::Walker::Method::FirstParent >>

=cut

extends 'Git::PurePerl::Walker::Method::FirstParent';

=imethod for_repository

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<for_repository( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/for_repository >>

=cut

=imethod clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=cut

=imethod _repo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<_repo( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/_repo >>

=imethod start

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<start( $commit )>>|Git::PurePerl::Walker::Method::FirstParent/start >>

=cut

=imethod _commit

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<_commit( $commit_object )>>|Git::PurePerl::Walker::Method::FirstParent/_commit >>

=cut

has '+start' => (
	init_arg   => undef,
	lazy_build => 1,
	required   => 0,
);

=p_attrmethod _has_repo

=cut

has '+_repo' => ( predicate => '_has_repo', );

=p_method _build_start

=cut

sub _build_start {
	my $self = shift;
	if ( not $self->_has_repo ) {
		require Carp;
		Carp::confess( 'No repo defined while trying to find a starting commit' );
	}
	return $self->_repo->head_sha1;
}

=imethod _build_commit

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<_build_commit()>>|Git::PurePerl::Walker::Method::FirstParent/_build_commit >>

=cut

=imethod current

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<current()>>|Git::PurePerl::Walker::Method::FirstParent/current >>

=cut

=imethod has_next

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<has_next()>>|Git::PurePerl::Walker::Method::FirstParent/has_next >>

=cut

=imethod next

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<next()>>|Git::PurePerl::Walker::Method::FirstParent/next >>

=cut

=imethod peek_next

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<peek_next()>>|Git::PurePerl::Walker::Method::FirstParent/peek_next >>

=cut

=imethod reset

L<< C<Git::PurePerl::B<Walker::Method::FirstParent>-E<gt>I<reset()>>|Git::PurePerl::Walker::Method::FirstParent/reset >>

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
