use strict;
use warnings;

package Git::PurePerl::Walker::Method::FirstParent;

# FILENAME: FirstParent.pm
# CREATED: 28/05/12 16:37:28 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Walk down a tree following the first parent.

use Moose;
with qw( Git::PurePerl::Walker::Role::Method );

has '_commit' => ( isa => 'Maybe[ Object ]', is => 'rw', lazy_build => 1 );
has 'start'   => ( isa => 'Str',             is => 'rw', required   => 1 );

sub _build__commit {
	my ( $self ) = @_;
	return $self->_repo->get_object( $self->start );
}

sub current {
	my ( $self ) = @_;
	return $self->_commit;
}

sub has_next {
	my ( $self ) = @_;
	if ( not $self->_commit ) {
		return;
	}
	if ( not $self->_commit->parent ) {
		return;
	}
	return 1;
}
## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub next {
	my ( $self ) = @_;
	my $commit;
	$self->_commit( $commit = $self->peek_next );
	return $commit;
}
## use critic

sub peek_next {
	my $commit = ( shift )->_commit->parent;
	return $commit;
}

## no critic ( Subroutines::ProhibitBuiltinHomonyms )
sub reset {
	my ( $self ) = @_;
	$self->_commit( $self->_repo->get_object( $self->start ) );
	return $self;
}
## use critic

no Moose;
__PACKAGE__->meta->make_immutable;
1;
