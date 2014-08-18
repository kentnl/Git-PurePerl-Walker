use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package Git::PurePerl::Walker::Method::FirstParent;

our $VERSION = '0.004001';

# ABSTRACT: Walk down a tree following the first parent.

# AUTHORITY

use Moose qw( with has );

=consumerole Git::PurePerl::Walker::Role::Method

L<< C<Git::PurePerl::B<Walker::Role::Method>>|Git::PurePerl::Walker::Role::Method >>

=cut

with qw( Git::PurePerl::Walker::Role::Method );

=imethod for_repository

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<for_repository( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/for_repository >>

=cut

=imethod clone

L<< C<MooseX::B<Clone>-E<gt>I<clone( %params )>>|MooseX::Clone/clone-params >>

=cut

=imethod _repo

L<< C<Git::PurePerl::B<Walker::Role::HasRepo>-E<gt>I<_repo( $repo )>>|Git::PurePerl::Walker::Role::HasRepo/_repo >>

=cut

=carg start

=pcarg _commit

=p_attr _commit

=p_attrmethod _commit

=attr start

=attrmethod start

=cut

has '_commit' => ( isa => 'Maybe[ Object ]', is => 'rw', lazy_build => 1 );
has 'start'   => ( isa => 'Str',             is => 'rw', required   => 1 );

=p_method _build_commit

=cut

sub _build__commit {
  my ($self) = @_;
  return $self->_repo->get_object( $self->start );
}

=rolemethod current

L<< C<Git::PurePerl::B<Walker::Role::Method>-E<gt>I<current()>>|Git::PurePerl::Walker::Role::Method/current >>

=cut

sub current {
  my ($self) = @_;
  return $self->_commit;
}

=rolemethod has_next

L<< C<Git::PurePerl::B<Walker::Role::Method>-E<gt>I<has_next()>>|Git::PurePerl::Walker::Role::Method/has_next >>

=cut

sub has_next {
  my ($self) = @_;
  if ( not $self->_commit ) {
    return;
  }
  if ( not $self->_commit->parent ) {
    return;
  }
  return 1;
}

=rolemethod next

L<< C<Git::PurePerl::B<Walker::Role::Method>-E<gt>I<next()>>|Git::PurePerl::Walker::Role::Method/next >>

=cut

## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub next {
  my ($self) = @_;
  my $commit;
  $self->_commit( $commit = $self->peek_next );
  return $commit;
}
## use critic

=rolemethod peek_next

L<< C<Git::PurePerl::B<Walker::Role::Method>-E<gt>I<peek_next()>>|Git::PurePerl::Walker::Role::Method/peek_next >>

=cut

sub peek_next {
  my $commit = (shift)->_commit->parent;
  return $commit;
}

=rolemethod reset

L<< C<Git::PurePerl::B<Walker::Role::Method>-E<gt>I<reset()>>|Git::PurePerl::Walker::Role::Method/reset >>

=cut

## no critic ( Subroutines::ProhibitBuiltinHomonyms )
sub reset {
  my ($self) = @_;
  $self->_commit( $self->_repo->get_object( $self->start ) );
  return $self;
}
## use critic

no Moose;
__PACKAGE__->meta->make_immutable;
1;
